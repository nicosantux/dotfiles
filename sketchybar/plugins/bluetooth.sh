#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/styles.sh"

ITEM=bluetooth
SCRIPT="$CONFIG_DIR/plugins/bluetooth.sh"
SCAN_FILE="/tmp/sketchybar_bluetooth_scan.tsv"
SCAN_PID_FILE="/tmp/sketchybar_bluetooth_scan.pid"
SCAN_SECONDS=8

row=(
  icon.font="$NERD_ICON_FONT"
)

header=(
  icon.font="$LABEL_FONT"
  icon.color="$WHITE"
  $(faux_bold icon "$WHITE")
  label.color="$GREY"
)

is_powered() {
  [[ "$(blueutil --power)" == 1 ]]
}

is_scanning() {
  [[ -f "$SCAN_PID_FILE" ]] && kill -0 "$(cat "$SCAN_PID_FILE")" 2>/dev/null
}

popup_open() {
  [[ "$(sketchybar --query $ITEM | jq -r .popup.drawing)" == on ]]
}

update_icon() {
  local icon=$BLUETOOTH_OFF color=$GREY

  if is_powered; then
    color=$ICON_COLOR
    icon=$BLUETOOTH_ON
    [[ -n "$(blueutil --connected)" ]] && icon=$BLUETOOTH_CONNECTED
  fi

  sketchybar --set $ITEM icon="$icon" icon.color="$color"
}

add_row() {
  local item="$ITEM.row.$ROW"
  ROW=$((ROW + 1))
  args+=(--add item "$item" popup.$ITEM --set "$item" "$@")
}

# Rebuilds the popup. Pass "scanning" to show the scan state before blueutil has started.
render() {
  local scanning="$1" address connected name status

  ROW=0
  args=(--remove "/$ITEM\.row\..*/")

  if ! is_powered; then
    args+=(--set $ITEM.power label="Off" label.color="$GREY")
    sketchybar "${args[@]}" >/dev/null 2>&1
    return
  fi

  args+=(--set $ITEM.power label="On" label.color="$GREEN")

  while IFS=$'\t' read -r address connected name; do
    [[ -z "$address" ]] && continue
    if [[ "$connected" == true ]]; then
      add_row "${row[@]}" icon="$BLUETOOTH_CONNECTED" icon.color="$WHITE" label="$name" label.color="$WHITE" \
        click_script="$SCRIPT toggle $address"
    else
      add_row "${row[@]}" icon="$BLUETOOTH_ON" icon.color="$GREY" label="$name" label.color="$GREY" \
        click_script="$SCRIPT toggle $address"
    fi
  done < <(blueutil --paired --format json | jq -r '.[] | [.address, .connected, .name // .address] | @tsv')

  if [[ -n "$scanning" ]] || is_scanning; then
    status="Scanning…"
  elif [[ ! -s "$SCAN_FILE" ]]; then
    status="None found"
  fi
  add_row "${header[@]}" icon="Nearby" label="$status" click_script="$SCRIPT scan"

  if [[ -f "$SCAN_FILE" ]]; then
    while IFS=$'\t' read -r address name; do
      [[ -z "$address" ]] && continue
      add_row "${row[@]}" icon="$BLUETOOTH_ON" icon.color="$GREY" label="$name" label.color="$GREY" \
        click_script="$SCRIPT pair $address"
    done < "$SCAN_FILE"
  fi

  sketchybar "${args[@]}" >/dev/null 2>&1
}

scan() {
  blueutil --inquiry "$SCAN_SECONDS" --format json \
    | jq -r '.[] | select(.paired | not) | [.address, .name // .address] | @tsv' > "$SCAN_FILE.tmp" \
    && mv "$SCAN_FILE.tmp" "$SCAN_FILE"

  rm -f "$SCAN_PID_FILE"
  popup_open && render
}

start_scan() {
  is_powered || return
  is_scanning && return

  render scanning
  scan >/dev/null 2>&1 &
  echo $! > "$SCAN_PID_FILE"
}

mark_busy() {
  sketchybar --set "$NAME" icon.color="$YELLOW" label.color="$YELLOW"
}

mark_failed() {
  sketchybar --set "$NAME" icon.color="$RED" label.color="$RED"
  sleep 1.5
}

toggle_device() {
  local address="$1" action=--connect

  [[ "$(blueutil --is-connected "$address")" == 1 ]] && action=--disconnect

  mark_busy
  blueutil "$action" "$address" || mark_failed
  render
  update_icon
}

pair_device() {
  local address="$1"

  mark_busy
  if blueutil --pair "$address" && blueutil --connect "$address"; then
    grep -v "^$address"$'\t' "$SCAN_FILE" > "$SCAN_FILE.tmp"
    mv "$SCAN_FILE.tmp" "$SCAN_FILE"
  else
    mark_failed
  fi
  render
  update_icon
}

toggle_power() {
  blueutil --power toggle
  update_icon
  if is_powered; then
    start_scan
  else
    render
  fi
}

case "$1" in
  toggle) toggle_device "$2"; exit 0 ;;
  pair) pair_device "$2"; exit 0 ;;
  power) toggle_power; exit 0 ;;
  scan) start_scan; exit 0 ;;
esac

case "$SENDER" in
  mouse.exited.global)
    sketchybar --set $ITEM popup.drawing=off
    ;;
  mouse.clicked)
    if popup_open; then
      sketchybar --set $ITEM popup.drawing=off
    else
      render
      sketchybar --set $ITEM popup.drawing=on
      start_scan
    fi
    update_icon
    ;;
  *)
    update_icon
    ;;
esac
