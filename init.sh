#!/usr/bin/env bash

# Detect the OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detecting macOS"
  ~/dotfiles/setup-macos.sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Detecting Arch Linux"
  ~/dotfiles/setup-arch.sh
else
  echo "This script only supports macOS and Arch Linux"
  exit 1
fi
