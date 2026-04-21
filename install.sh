#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/scripts/homebrew.sh"
source "$SCRIPT_DIR/scripts/symlinks.sh"
source "$SCRIPT_DIR/scripts/packages.sh"
source "$SCRIPT_DIR/scripts/fonts.sh"
source "$SCRIPT_DIR/scripts/macos.sh"
source "$SCRIPT_DIR/scripts/services.sh"
source "$SCRIPT_DIR/scripts/tools.sh"
source "$SCRIPT_DIR/scripts/git.sh"
source "$SCRIPT_DIR/scripts/wallpaper.sh"


echo "Your development environment has been configured"

# Restart the computer to apply all changes.
for ((i=5; i>=1; i--)); do
  echo "Restarting your computer in $i seconds"
  sleep 1
done

sudo shutdown -r now
