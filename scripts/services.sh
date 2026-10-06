#!/usr/bin/env bash

# Start services.
echo "Starting services..."

services=(
  "borders"
  "sketchybar"
)

for service in "${services[@]}"; do
  brew services start "$service"
done

# Location access is required to read Wi-Fi SSIDs; this opens the macOS permission prompt.
echo "Authorizing sketchybar Wi-Fi helper..."
make -C ~/.config/sketchybar/helpers/wifi authorize
