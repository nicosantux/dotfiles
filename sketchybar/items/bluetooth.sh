#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh"

bluetooth=(
  icon="$BLUETOOTH_ON"
  icon.font="$NERD_ICON_FONT"
  label.drawing=off
  update_freq=30
  script="$PLUGIN_DIR/bluetooth.sh"
  popup.align=right
)

bluetooth_power=(
  icon="Bluetooth"
  icon.font="$LABEL_FONT"
  $(faux_bold icon "$WHITE")
  click_script="$PLUGIN_DIR/bluetooth.sh power"
)

sketchybar --add item bluetooth right                                \
  --set bluetooth "${bluetooth[@]}"                                  \
  --subscribe bluetooth mouse.clicked mouse.exited.global system_woke \
  --add item bluetooth.power popup.bluetooth                         \
  --set bluetooth.power "${bluetooth_power[@]}"
