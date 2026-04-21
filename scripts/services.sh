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
