#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/styles.sh"

# Shared with claude/statusline.sh so both stay in sync and hit the endpoint less often.
CACHE_FILE="/tmp/claude/statusline-usage-cache.json"
CACHE_MAX_AGE=60

fetch_usage() {
  local token response
  token="$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | jq -r '.claudeAiOauth.accessToken // empty')"
  [[ -z "$token" ]] && return 1

  response="$(curl -s --max-time 10 \
    -H "Authorization: Bearer $token" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: claude-code/2.1.34" \
    "https://api.anthropic.com/api/oauth/usage")"

  jq -e '.five_hour' >/dev/null 2>&1 <<< "$response" || return 1

  mkdir -p "$(dirname "$CACHE_FILE")"
  printf '%s' "$response" > "$CACHE_FILE"
}

color_for_pct() {
  if (( $1 >= 90 )); then
    echo "$RED"
  elif (( $1 >= 75 )); then
    echo "$ORANGE"
  elif (( $1 >= 50 )); then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

# Turns an ISO 8601 UTC timestamp into "resets in 2h 14m (19:39)".
format_reset() {
  local iso="$1" format="$2" epoch remaining days hours minutes relative
  [[ -z "$iso" ]] && return

  epoch="$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "${iso:0:19}" +%s 2>/dev/null)" || return
  remaining=$(( epoch - $(date +%s) ))
  (( remaining < 0 )) && remaining=0

  days=$(( remaining / 86400 ))
  hours=$(( remaining % 86400 / 3600 ))
  minutes=$(( remaining % 3600 / 60 ))

  if (( days > 0 )); then
    relative="${days}d ${hours}h"
  elif (( hours > 0 )); then
    relative="${hours}h ${minutes}m"
  else
    relative="${minutes}m"
  fi

  echo "resets in $relative ($(date -r "$epoch" +"$format"))"
}

case "$SENDER" in
  mouse.exited.global)
    sketchybar --set $NAME popup.drawing=off
    exit 0
    ;;
  mouse.clicked)
    sketchybar --set $NAME popup.drawing=toggle
    exit 0
    ;;
esac

CACHE_AGE=$CACHE_MAX_AGE
if [[ -f "$CACHE_FILE" ]]; then
  CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
fi

if (( CACHE_AGE >= CACHE_MAX_AGE )); then
  fetch_usage
fi

read -r FIVE_HOUR FIVE_HOUR_RESET SEVEN_DAY SEVEN_DAY_RESET < <(jq -r '[
  (.five_hour.utilization // empty | round), (.five_hour.resets_at // "-"),
  (.seven_day.utilization // empty | round), (.seven_day.resets_at // "-")
] | join(" ")' "$CACHE_FILE" 2>/dev/null)

if [[ -z "$FIVE_HOUR" ]]; then
  sketchybar --set $NAME label="--"
  exit 0
fi

FIVE_HOUR_COLOR="$(color_for_pct "$FIVE_HOUR")"
SEVEN_DAY_COLOR="$(color_for_pct "$SEVEN_DAY")"

sketchybar --set $NAME label="${FIVE_HOUR}%" \
  --set claude.five_hour \
  icon.color="$FIVE_HOUR_COLOR" icon.shadow.color="$(faux_bold_color "$FIVE_HOUR_COLOR")" \
  label="${FIVE_HOUR}%  ·  $(format_reset "${FIVE_HOUR_RESET#-}" "%H:%M")" \
  --set claude.seven_day \
  icon.color="$SEVEN_DAY_COLOR" icon.shadow.color="$(faux_bold_color "$SEVEN_DAY_COLOR")" \
  label="${SEVEN_DAY}%  ·  $(format_reset "${SEVEN_DAY_RESET#-}" "%a %H:%M")"
