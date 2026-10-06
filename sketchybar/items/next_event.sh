#!/usr/bin/env bash

next_event=(
  icon=$CALENDAR
  drawing=off
  updates=on
  update_freq=60
  script="$PLUGIN_DIR/next_event.sh"
  popup.align=right
)

sketchybar --add item next_event right           \
  --set next_event "${next_event[@]}"            \
  --subscribe next_event mouse.clicked mouse.exited.global system_woke
