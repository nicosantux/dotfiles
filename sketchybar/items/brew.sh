#!/usr/bin/env bash

# Trigger the brew_udpate event when brew update or upgrade is run from cmdline
# e.g. via function in .zshrc

brew=(
  icon=$BREW
  # Optical correction for glyph side bearings
  label.padding_left=2
  label=?
  update_freq=1800
  script="$PLUGIN_DIR/brew.sh"
)

sketchybar --add event brew_update \
           --add item brew right   \
           --set brew "${brew[@]}" \
           --subscribe brew brew_update
