#!/usr/bin/env bash

weather=(
  padding_right=8
  icon.font="$FONT:Bold:16.0"
  script="$PLUGIN_DIR/weather.sh"
  update_freq=1200
)

sketchybar --add item weather right \
  --set weather "${weather[@]}"     \
  --subscribe weather mouse.clicked

