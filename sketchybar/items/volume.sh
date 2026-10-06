#!/usr/bin/env bash

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  padding_left=0
  padding_right=0
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$BACKGROUND_2
  slider.knob=$SLIDER_KNOB
  slider.knob.font="$FONT:Regular:12.0"
  slider.knob.drawing=off
)

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  # Optical correction for glyph side bearings
  padding_left=6
  icon=$VOLUME_100
  label.drawing=off
)

sketchybar --add slider volume right   \
  --set volume "${volume_slider[@]}"   \
  --subscribe volume volume_change     \
  mouse.clicked                        \
  --add item volume_icon right         \
  --set volume_icon "${volume_icon[@]}"
