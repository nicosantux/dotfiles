#!/usr/bin/env bash

# Bluetooth access is granted per app, and sketchybar loses it on every upgrade because its
# ad-hoc signature changes. blueutil runs through BluetoothHelper instead, launched via `open`
# so it is the responsible process, and talks back over a FIFO.
# Usage: bluetooth-helper.sh <blueutil arguments>

APP="$(cd "$(dirname "$0")" && pwd)/bin/BluetoothHelper.app"
TIMEOUT=60

OUTPUT="$(mktemp -u)"
RESULT="$(mktemp)"
trap 'rm -f "$OUTPUT" "$RESULT"' EXIT
mkfifo -m 600 "$OUTPUT"

open -g -n --stdout "$OUTPUT" --stderr /dev/null "$APP" --args "$@" || exit 1

cat "$OUTPUT" > "$RESULT" &
READER=$!
( sleep "$TIMEOUT" && kill "$READER" ) >/dev/null 2>&1 &
WATCHDOG=$!
wait "$READER"
pkill -P "$WATCHDOG" 2>/dev/null
kill "$WATCHDOG" 2>/dev/null

{
  read -r status
  cat
} < "$RESULT"

exit "${status:-1}"
