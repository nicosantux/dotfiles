#!/usr/bin/env bash

calendar=(
  icon=cal
  icon.font="$LABEL_FONT"
  icon.color=$SUBTEXT
  $(faux_bold icon "$SUBTEXT")
  label.padding_left=10
  # Optical correction for glyph side bearings
  padding_left=5
  update_freq=10
  script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar center       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
