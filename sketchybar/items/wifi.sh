#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh"

wifi=(
  label.width=0
  label.padding_left=0
  label.padding_right=0
  icon="$WIFI_DISCONNECTED"
  script="$PLUGIN_DIR/wifi.sh"
  update_freq=300
  popup.align=right
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi wifi_change mouse.clicked mouse.exited.global
