#!/usr/bin/env bash

weather=(
  # Optical correction for glyph side bearings
  label.padding_left=1
  script="$PLUGIN_DIR/weather.sh"
  update_freq=1200
)

sketchybar --add item weather center \
  --set weather "${weather[@]}"     \
  --subscribe weather mouse.clicked

