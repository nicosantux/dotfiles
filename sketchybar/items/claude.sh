#!/usr/bin/env bash

claude=(
  icon=":claude:"
  icon.font="$APP_FONT:Regular:15.0"
  # Optical correction for glyph side bearings
  padding_left=6
  icon.padding_right=2
  label=?
  update_freq=60
  script="$PLUGIN_DIR/claude.sh"
  popup.align=right
)

claude_detail=(
  icon.width=70
  icon.font="$LABEL_FONT"
  $(faux_bold icon "$WHITE")
)

sketchybar --add item claude right                    \
  --set claude "${claude[@]}"                         \
  --subscribe claude mouse.clicked mouse.exited.global \
  --add item claude.five_hour popup.claude            \
  --set claude.five_hour "${claude_detail[@]}" icon="Session" \
  --add item claude.seven_day popup.claude            \
  --set claude.seven_day "${claude_detail[@]}" icon="Weekly"
