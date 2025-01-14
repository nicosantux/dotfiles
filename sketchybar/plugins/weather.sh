#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

sketchybar --set $NAME \
  label="Loading..." \
  icon.color=$WHITE

LOC=$(curl -s ipinfo.io | jq '.loc' | sed 's/"//g')

LAT=$(echo $LOC | cut -d',' -f1)
LONG=$(echo $LOC | cut -d',' -f2)

WEATHER=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude="$LAT"&longitude="$LONG"&current=temperature,weathercode")

TEMPERATURE=$(echo $WEATHER | jq '.current.temperature')
WEATHER=$(echo $WEATHER | jq '.current.weathercode')

clear=("0" "1")
cloudy=("2" "3")
fog=("45" "48")
drizzle=("51" "53" "55" "56" "57")
rain=("61" "63" "65" "66" "67")
snow=("71" "73" "75" "77" "85" "86")
showers=("80" "81" "82")
thunderstorm=("95" "96" "99")

if [[ ${clear[@]} =~ $WEATHER ]]; then
  ICON="􀆮"
elif [[ ${cloudy[@]} =~ $WEATHER ]]; then
  ICON="􀇕"
elif [[ ${fog[@]} =~ $WEATHER ]]; then
  ICON="􀇋"
elif [[ ${drizzle[@]} =~ $WEATHER ]]; then
  ICON="􀇅"
elif [[ ${rain[@]} =~ $WEATHER ]]; then
  ICON="􀇇"
elif [[ ${snow[@]} =~ $WEATHER ]]; then
  ICON="􀇥"
elif [[ ${showers[@]} =~ $WEATHER ]]; then
  ICON="􀇇"
elif [[ ${thunderstorm[@]} =~ $WEATHER ]]; then
  ICON="􀇟"
fi

sketchybar --set $NAME \
  icon="$ICON" label="$TEMPERATURE$(echo '°')C"
