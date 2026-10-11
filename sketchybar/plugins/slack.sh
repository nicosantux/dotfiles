#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/styles.sh"

if [[ "$SENDER" == "mouse.clicked" ]]; then
  [[ "$BUTTON" == "left" ]] && open -a Slack
  exit 0
fi

if ! pgrep -xq Slack; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

# Dock badge: a number for mentions and DMs, "•" for unread channels, empty otherwise.
BADGE="$(lsappinfo info -only StatusLabel "Slack" | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')"

if [[ "$BADGE" =~ ^[0-9]+$ ]]; then
  sketchybar --set $NAME drawing=on icon.color="$RED" \
    label="$BADGE" label.drawing=on
elif [[ -n "$BADGE" ]]; then
  sketchybar --set $NAME drawing=on icon.color="$YELLOW" label.drawing=off
else
  sketchybar --set $NAME drawing=on icon.color="$ICON_COLOR" label.drawing=off
fi
