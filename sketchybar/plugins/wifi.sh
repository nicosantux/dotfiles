#!/usr/bin/env bash

update() {
  source "$CONFIG_DIR/icons.sh"
  SSID="$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')"
  IP="$(ipconfig getifaddr en0)"

  ICON="$([ -n "$IP" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
  LABEL="$([ -n "$IP" ] && echo "$SSID" || echo "Disconnected")"

  sketchybar --set $NAME icon="$ICON" label="$LABEL"
}

click() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

  WIDTH=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi

  sketchybar --animate sin 20 --set $NAME label.width="$WIDTH"
}

case "$SENDER" in
  "wifi_change") update
  ;;
  "mouse.clicked") click
  ;;
esac
