#!/usr/bin/env bash

notch=(
  drawing=off
  updates=on
  script="$PLUGIN_DIR/notch.sh"
)

sketchybar --add item notch left     \
           --set notch "${notch[@]}" \
           --subscribe notch display_change system_woke
