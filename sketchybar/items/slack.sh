#!/usr/bin/env bash

slack=(
  icon=":slack:"
  icon.font="$APP_FONT:Regular:15.0"
  # Optical correction for glyph side bearings
  padding_left=6
  icon.padding_right=2
  label.drawing=off
  updates=on
  update_freq=10
  script="$PLUGIN_DIR/slack.sh"
)

sketchybar --add item slack right \
  --set slack "${slack[@]}"       \
  --subscribe slack mouse.clicked front_app_switched system_woke
