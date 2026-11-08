#!/usr/bin/env bash

echo "Removing existing dotfiles..."
# Remove files if they already exist.
rm -rf ~/.agents/.skill-lock.json \
  ~/.claude/commands \
  ~/.claude/settings.json \
  ~/.claude/statusline.sh \
  ~/.config/aerospace \
  ~/.config/bat \
  ~/.config/borders \
  ~/.config/ghostty \
  ~/.config/herdr/config.toml \
  ~/.config/karabiner/karabiner.json \
  ~/.config/mise/config.toml \
  ~/.config/nvim \
  ~/.config/opencode/command \
  ~/.config/opencode/opencode.jsonc \
  ~/.config/sketchybar \
  ~/.config/starship \
  ~/.config/tmux \
  ~/.config/yazi \
  ~/.zshrc \
  2>/dev/null

echo "Creating symlinks..."
# Create necessary folders.
mkdir -p ~/.agents \
  ~/.claude \
  ~/.config/aerospace \
  ~/.config/bat/themes \
  ~/.config/borders \
  ~/.config/ghostty \
  ~/.config/herdr \
  ~/.config/karabiner \
  ~/.config/mise \
  ~/.config/nvim \
  ~/.config/opencode \
  ~/.config/sketchybar \
  ~/.config/starship \
  ~/.config/tmux \
  ~/.config/yazi \
  ~/.local/bin

# Agent instruction files are owned by rtk and codegraph, which append to them,
# so Claude imports the shared instructions and opencode loads them via `instructions`.
for agent_file in ~/.claude/CLAUDE.md ~/.config/opencode/AGENTS.md; do
  if [ -L "$agent_file" ]; then
    rm "$agent_file"
  fi
done
claude_import="@~/dotfiles/agents/AGENTS.md"
if ! grep -qxF "$claude_import" ~/.claude/CLAUDE.md 2>/dev/null; then
  claude_existing="$(cat ~/.claude/CLAUDE.md 2>/dev/null)"
  printf '%s\n\n%s\n' "$claude_import" "$claude_existing" > ~/.claude/CLAUDE.md
fi

# Symlinking files
ln -s ~/dotfiles/agents/claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/agents/claude/statusline.sh ~/.claude/statusline.sh
ln -s ~/dotfiles/agents/commands ~/.claude/commands
ln -s ~/dotfiles/agents/commands ~/.config/opencode/command
ln -s ~/dotfiles/agents/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -s ~/dotfiles/agents/skill-lock.json ~/.agents/.skill-lock.json
ln -s ~/dotfiles/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/ghostty/config ~/.config/ghostty/config
ln -s ~/dotfiles/herdr/config.toml ~/.config/herdr/config.toml
ln -s ~/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/dotfiles/mise/config.toml ~/.config/mise/config.toml
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/sketchybar/* ~/.config/sketchybar/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/yazi/theme.toml ~/.config/yazi/theme.toml
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
