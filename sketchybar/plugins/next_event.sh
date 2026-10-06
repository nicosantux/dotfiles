#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/styles.sh"

export LC_ALL=en_US.UTF-8

ITEM=next_event
SCRIPT="$CONFIG_DIR/plugins/next_event.sh"
EVENTS_FILE="$HOME/.cache/sketchybar/next_event.db"
PROMPTED_FILE="$HOME/.cache/sketchybar/next_event.prompted"
FIELD_SEP=$'\x1f' # Not whitespace, so `read` keeps empty fields

EXCLUDED_CALENDARS="Birthdays,Holidays in Argentina,Festivos en Argentina,Recordatorios"
COUNTDOWN_SECONDS=1800 # The countdown only shows this long before an event starts
SOON_SECONDS=900 # How long before it starts an event turns yellow and replaces the one in progress
JOIN_PROMPT_SECONDS=60 # How long before a meeting starts the join dialog shows up
JOIN_PROMPT_GRACE=300 # Still prompt this long after the start, e.g. after waking from sleep
MEETING_URL='https://(teams\.microsoft\.com/(l/meetup-join|meet)/|meet\.google\.com/|([a-z0-9-]+\.)?zoom\.us/j/|[a-z0-9-]+\.webex\.com/)[^[:space:]<>"]+'

header=(
  icon.font="$LABEL_FONT"
  icon.color="$WHITE"
  $(faux_bold icon "$WHITE")
  label.drawing=off
)

# Writes start, end, meeting link and title (separated by FIELD_SEP) of today's and tomorrow's events
# that have not ended yet, sorted by start.
fetch_events() {
  local sep=$FIELD_SEP now line when rest title start end link
  now=$(date +%s)
  mkdir -p "$(dirname "$EVENTS_FILE")"

  icalBuddy -n -nc -nrd -ea -npn -b "" -nnr " " -df "%Y-%m-%d" -tf "%H:%M" \
    -iep "datetime,title,location,notes" -po "datetime,title,location,notes" \
    -ps "|$sep|" -ec "$EXCLUDED_CALENDARS" eventsToday+1 2>/dev/null |
  while IFS= read -r line; do
    when="${line%%"$sep"*}"
    rest="${line#*"$sep"}"
    title="${rest%%"$sep"*}"

    [[ "$when" =~ ^([0-9-]+)\ at\ ([0-9:]+)(\ -\ (([0-9-]+)\ at\ )?([0-9:]+))?$ ]] || continue
    start=$(date -j -f "%Y-%m-%d %H:%M:%S" "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}:00" +%s)
    end=$(date -j -f "%Y-%m-%d %H:%M:%S" "${BASH_REMATCH[5]:-${BASH_REMATCH[1]}} ${BASH_REMATCH[6]:-${BASH_REMATCH[2]}}:00" +%s)
    (( end < now )) && continue

    link="$(grep -oE "$MEETING_URL" <<< "$rest" | head -1)"
    printf '%s\n' "$start$sep$end$sep$link$sep$title"
  done | sort -n > "$EVENTS_FILE.tmp" && mv "$EVENTS_FILE.tmp" "$EVENTS_FILE"
}

load_events() {
  STARTS=() ENDS=() LINKS=() TITLES=()
  [[ -f "$EVENTS_FILE" ]] || return
  while IFS=$FIELD_SEP read -r start end link title; do
    STARTS+=("$start") ENDS+=("$end") LINKS+=("$link") TITLES+=("$title")
  done < "$EVENTS_FILE"
}

# Prints the index of the event to show: the one in progress, unless another one starts soon.
pick_event() {
  local now i current="" upcoming=""
  now=$(date +%s)

  for i in "${!STARTS[@]}"; do
    if (( STARTS[i] <= now && now < ENDS[i] )); then
      current=$i
    elif (( STARTS[i] > now )) && [[ -z "$upcoming" ]]; then
      upcoming=$i
    fi
  done

  if [[ -n "$upcoming" ]] && { [[ -z "$current" ]] || (( STARTS[upcoming] - now <= SOON_SECONDS )); }; then
    echo "$upcoming"
  else
    echo "$current"
  fi
}

# Prints the time left until <start> as "now" or "15m".
countdown() {
  local minutes=$(( ($1 - $(date +%s) + 59) / 60 ))
  (( minutes <= 0 )) && echo "now" || echo "${minutes}m"
}

update() {
  load_events
  local index start now color=$ICON_COLOR label_color=$LABEL_COLOR show_label=on
  index="$(pick_event)"

  if [[ -z "$index" ]]; then
    sketchybar --set $ITEM drawing=off popup.drawing=off
    return
  fi

  start=${STARTS[index]}
  now=$(date +%s)

  if (( start <= now )); then
    color=$RED
    label_color=$RED
  elif (( start - now <= SOON_SECONDS )); then
    color=$YELLOW
    label_color=$YELLOW
  elif (( start - now > COUNTDOWN_SECONDS )); then
    show_label=off
  fi

  sketchybar --set $ITEM drawing=on icon.color="$color" label.color="$label_color" \
    label.drawing=$show_label label="$(countdown "$start")"
}

render_popup() {
  load_events
  local i day last_day="" selected label color args
  selected="$(pick_event)"
  args=(--remove "/$ITEM\.row\..*/")

  for i in "${!STARTS[@]}"; do
    day="$(date -r "${STARTS[i]}" +%F)"
    if [[ "$day" != "$last_day" ]]; then
      args+=(--add item "$ITEM.row.day$i" popup.$ITEM --set "$ITEM.row.day$i" "${header[@]}"
             icon="$([[ "$day" == "$(date +%F)" ]] && echo Today || echo Tomorrow)")
      last_day="$day"
    fi

    label="${TITLES[i]}"
    [[ -n "${LINKS[i]}" ]] && label="$label  $VIDEO_CALL"
    color=$GREY
    [[ "$i" == "$selected" ]] && color=$WHITE

    args+=(--add item "$ITEM.row.$i" popup.$ITEM --set "$ITEM.row.$i"
           icon="$(date -r "${STARTS[i]}" +%H:%M)" icon.font="$LABEL_FONT" icon.width=50 icon.color="$color"
           label="$label" label.color="$color" click_script="$SCRIPT open $i")
  done

  sketchybar "${args[@]}" --set $ITEM popup.drawing=on >/dev/null 2>&1
}

# Joins the meeting of event <index>, or opens Calendar when it has no link.
open_event() {
  local link
  sketchybar --set $ITEM popup.drawing=off
  link="$(sed -n "$(( $1 + 1 ))p" "$EVENTS_FILE" | cut -d "$FIELD_SEP" -f3)"

  if [[ -n "$link" ]]; then
    open "$link"
  else
    open -a Calendar
  fi
}

# Asks to join <title> at <link>. Both come from the invite, so they are only passed as arguments.
ask_to_join() {
  local answer
  answer="$(osascript - "$1" "$JOIN_PROMPT_GRACE" <<'EOF'
on run argv
  activate
  try
    set reply to display dialog "\"" & item 1 of argv & "\" is starting." with title "Meeting" buttons {"Dismiss", "Join"} default button "Join" giving up after (item 2 of argv as integer)
    return button returned of reply
  on error
    return ""
  end try
end run
EOF
)"
  [[ "$answer" == Join ]] && open "$2"
}

# Shows the join dialog once for each meeting with a link that is about to start.
prompt_meetings() {
  local i key now
  now=$(date +%s)
  touch "$PROMPTED_FILE"

  for i in "${!STARTS[@]}"; do
    [[ -z "${LINKS[i]}" ]] && continue
    (( STARTS[i] - now <= JOIN_PROMPT_SECONDS && now - STARTS[i] <= JOIN_PROMPT_GRACE )) || continue

    key="${STARTS[i]}$FIELD_SEP${LINKS[i]}"
    grep -qxF "$key" "$PROMPTED_FILE" && continue
    echo "$key" >> "$PROMPTED_FILE"
    ask_to_join "${TITLES[i]}" "${LINKS[i]}" >/dev/null 2>&1 &
  done

  awk -F "$FIELD_SEP" -v since=$(( now - 86400 )) '$1 >= since' "$PROMPTED_FILE" > "$PROMPTED_FILE.tmp" \
    && mv "$PROMPTED_FILE.tmp" "$PROMPTED_FILE"
}

case "$1" in
  open) open_event "$2"; exit 0 ;;
esac

case "$SENDER" in
  mouse.exited.global)
    sketchybar --set $ITEM popup.drawing=off
    ;;
  mouse.clicked)
    if [[ "$BUTTON" == right || "$MODIFIER" == shift ]]; then
      load_events
      open_event "$(pick_event)"
    elif [[ "$(sketchybar --query $ITEM | jq -r .popup.drawing)" == on ]]; then
      sketchybar --set $ITEM popup.drawing=off
    else
      fetch_events
      update
      render_popup
    fi
    ;;
  *)
    fetch_events
    update
    prompt_meetings
    ;;
esac
