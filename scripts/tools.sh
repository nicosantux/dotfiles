#!/usr/bin/env bash

# Install tmux tpm.
echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Enable bat theme.
echo "Enabling bat theme..."
curl -L https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme -o ~/.config/bat/themes/catppuccin-mocha.tmTheme
bat cache --build

# Configure rtk for Claude Code and OpenCode.
echo "Configuring rtk..."
rtk init --global --opencode --auto-patch

# Install herdr plugins.
echo "Installing herdr plugins..."
herdr plugin install paulbkim-dev/vim-herdr-navigation --yes

# Install node lts.
echo "Installing Node LTS..."
fnm install --lts

# Restore global agent skills from the versioned lock file.
echo "Installing agent skills..."
eval "$(fnm env)"
fnm use lts-latest
jq -r '.skills | to_entries[] | "\(.value.source) \(.key)"' ~/dotfiles/claude/skill-lock.json |
  while read -r source skill; do
    npx -y skills add "$source" --global --agent claude-code --skill "$skill" --yes </dev/null
  done
