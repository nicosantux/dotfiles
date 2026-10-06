#!/usr/bin/env bash

# Joins the network at line <index> (0-based) of the last scan from wifi.sh.
# Usage: wifi_connect.sh <index>

WIFI_HELPER="$CONFIG_DIR/helpers/wifi/wifi-helper.sh"
SCAN_FILE="/tmp/sketchybar_wifi_scan"
MAX_ATTEMPTS=3

ask_password() {
  osascript - "$1" "$2" <<'EOF'
on run argv
  set ssid to item 1 of argv
  set message to item 2 of argv
  try
    set answer to display dialog message & "Enter the password for \"" & ssid & "\"." default answer "" with hidden answer with title "Wi-Fi" buttons {"Cancel", "Join"} default button "Join"
    return text returned of answer
  on error
    return ""
  end try
end run
EOF
}

notify() {
  osascript - "$1" <<'EOF'
on run argv
  display notification (item 1 of argv) with title "Wi-Fi"
end run
EOF
}

sketchybar --set wifi popup.drawing=off

IFS=$'\t' read -r SSID _ _ _ _ < <(sed -n "$(( $1 + 1 ))p" "$SCAN_FILE")
[ -z "$SSID" ] && exit 0

RESULT="$("$WIFI_HELPER" connect "$SSID")"

ATTEMPT=0
MESSAGE=""
while [ "$RESULT" = "password_required" ] && [ "$ATTEMPT" -lt "$MAX_ATTEMPTS" ]; do
  PASSWORD="$(ask_password "$SSID" "$MESSAGE")"
  [ -z "$PASSWORD" ] && exit 0

  RESULT="$(printf '%s\n' "$PASSWORD" | "$WIFI_HELPER" connect "$SSID" --password-stdin)"
  MESSAGE="Incorrect password. "
  ATTEMPT=$((ATTEMPT + 1))
done

case "$RESULT" in
  "joined") notify "Connected to $SSID" ;;
  "password_required") notify "Could not join $SSID: incorrect password" ;;
  *) notify "Could not join $SSID${RESULT#failed}" ;;
esac
