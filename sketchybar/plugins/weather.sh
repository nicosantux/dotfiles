#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Dims the current reading while fetching so a click gives feedback without changing the width.
sketchybar --set $NAME icon.color=$GREY label.color=$GREY

read -r LAT LONG < <(curl -s --max-time 10 "http://ip-api.com/json?fields=lat,lon" | jq -r '"\(.lat // empty) \(.lon // empty)"')

if [[ -z "$LAT" || -z "$LONG" ]]; then
  sketchybar --set $NAME icon="$WEATHER_UNAVAILABLE" label="--" icon.color=$ICON_COLOR label.color=$LABEL_COLOR
  exit 0
fi

read -r TEMPERATURE WEATHER IS_DAY < <(curl -s --max-time 10 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LONG&current=temperature_2m,weather_code,is_day" | jq -r '"\(.current.temperature_2m // empty) \(.current.weather_code // empty) \(.current.is_day // 1)"')

if [[ -z "$TEMPERATURE" ]]; then
  sketchybar --set $NAME icon="$WEATHER_UNAVAILABLE" label="--" icon.color=$ICON_COLOR label.color=$LABEL_COLOR
  exit 0
fi

case "$WEATHER" in
  0|1) ICON="$([ "$IS_DAY" = 1 ] && echo "$WEATHER_CLEAR" || echo "$WEATHER_CLEAR_NIGHT")" ;;
  2) ICON="$([ "$IS_DAY" = 1 ] && echo "$WEATHER_PARTLY_CLOUDY" || echo "$WEATHER_PARTLY_CLOUDY_NIGHT")" ;;
  3) ICON="$WEATHER_CLOUDY" ;;
  45|48) ICON="$WEATHER_FOG" ;;
  51|53|55|56|57|61|63|66) ICON="$WEATHER_RAIN" ;;
  65|67|80|81|82) ICON="$WEATHER_POURING" ;;
  71|73|75|77|85|86) ICON="$WEATHER_SNOW" ;;
  95|96|99) ICON="$WEATHER_STORM" ;;
  *) ICON="$WEATHER_UNAVAILABLE" ;;
esac

TEMPERATURE="$(awk -v t="$TEMPERATURE" 'BEGIN { r = sprintf("%.0f", t); print (r == "-0" ? 0 : r) }')"

sketchybar --set $NAME icon="$ICON" label="${TEMPERATURE}°" icon.color=$ICON_COLOR label.color=$LABEL_COLOR
