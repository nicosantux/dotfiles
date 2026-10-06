#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/styles.sh"

WIFI_HELPER="$CONFIG_DIR/helpers/wifi/wifi-helper.sh"
SCAN_FILE="/tmp/sketchybar_wifi_scan"

update() {
  SSID="$("$WIFI_HELPER" current)"
  IP="$(ipconfig getifaddr en0)"

  ICON="$([ -n "$IP" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
  LABEL="$([ -n "$IP" ] && echo "$SSID" || echo "Disconnected")"

  sketchybar --set $NAME icon="$ICON" label="$LABEL"
}

toggle_label() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

  WIDTH=0
  PADDING=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
    PADDING=$GLYPH_PADDING
  fi

  sketchybar --animate sin 20 --set $NAME label.width="$WIDTH" \
    label.padding_left="$PADDING" label.padding_right="$PADDING"
}

scan() {
  "$WIFI_HELPER" scan > "$SCAN_FILE.tmp" && mv "$SCAN_FILE.tmp" "$SCAN_FILE"
}

network_item() {
  local index="$1"
  shift
  ARGS+=(--add item wifi.network.$index popup.$NAME
         --set wifi.network.$index icon.width=20 "$@")
}

# The popup is built from the last background scan and never changes while visible:
# resizing an open popup is what makes it stutter.
open_networks() {
  [ -s "$SCAN_FILE" ] || scan

  CURRENT_SSID="$1"
  ARGS=(--remove '/wifi.network\..*/')
  INDEX=0
  while IFS=$'\t' read -r SSID _; do
    if [ "$SSID" = "$CURRENT_SSID" ]; then
      network_item $INDEX icon=$CHECK label="$SSID" label.color=$WHITE
    else
      network_item $INDEX icon="" label="$SSID" label.color=$GREY \
        click_script="$CONFIG_DIR/plugins/wifi_connect.sh $INDEX"
    fi
    INDEX=$((INDEX + 1))
  done < "$SCAN_FILE"

  if [ "$INDEX" -eq 0 ]; then
    network_item 0 label="No networks found" label.color=$GREY
  fi

  sketchybar "${ARGS[@]}" --set $NAME popup.drawing=on 2>/dev/null
}

close_networks() {
  sketchybar --set $NAME popup.drawing=off
  scan
}

popup_state() {
  sketchybar --query $NAME | jq -r '"\(.popup.drawing)\t\(.label.value)"'
}

case "$SENDER" in
  "forced") update; scan
  ;;
  "wifi_change") update
  ;;
  "routine")
    IFS=$'\t' read -r POPUP _ < <(popup_state)
    [ "$POPUP" = "on" ] || scan
  ;;
  "mouse.exited.global")
    IFS=$'\t' read -r POPUP _ < <(popup_state)
    [ "$POPUP" = "on" ] && close_networks
  ;;
  "mouse.clicked")
    if [ "$BUTTON" = "right" ] || [ "$MODIFIER" = "shift" ]; then
      toggle_label
      exit 0
    fi

    IFS=$'\t' read -r POPUP CURRENT_SSID < <(popup_state)
    if [ "$POPUP" = "on" ]; then
      close_networks
    else
      open_networks "$CURRENT_SSID"
    fi
  ;;
esac
