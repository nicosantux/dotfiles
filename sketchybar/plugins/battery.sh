#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

DRAWING=on
COLOR=$WHITE

if [ "$PERCENTAGE" -ge 90 ]; then
  ICON=$BATTERY_100
elif [ "$PERCENTAGE" -ge 60 ]; then
  ICON=$BATTERY_75
elif [ "$PERCENTAGE" -ge 30 ]; then
  ICON=$BATTERY_50
elif [ "$PERCENTAGE" -ge 10 ]; then
  ICON=$BATTERY_25
  COLOR=$ORANGE
else
  ICON=$BATTERY_0
  COLOR=$RED
fi

if [ -n "$CHARGING" ]; then
  ICON=$BATTERY_CHARGING
  DRAWING=off
fi

sketchybar --set $NAME drawing="$DRAWING" icon="$ICON" icon.color="$COLOR" label="$PERCENTAGE%"
