#!/usr/bin/env bash

# Install tmux tpm.
echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Enable bat theme.
echo "Enabling bat theme..."
curl -L https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme -o ~/.config/bat/themes/catppuccin-mocha.tmTheme
bat cache --build

# Install node lts.
echo "Installing Node LTS..."
fnm install --lts
