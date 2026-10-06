#!/usr/bin/env bash

echo "Removing existing dotfiles..."
# Remove files if they already exist.
rm -rf ~/.agents/.skill-lock.json \
       ~/.claude/CLAUDE.md  \
       ~/.claude/settings.json \
       ~/.claude/statusline.sh \
       ~/.config/aerospace  \
       ~/.config/bat        \
       ~/.config/borders    \
       ~/.config/ghostty    \
       ~/.config/herdr/config.toml \
       ~/.config/karabiner/karabiner.json \
       ~/.config/nvim       \
       ~/.config/opencode/AGENTS.md \
       ~/.config/opencode/command \
       ~/.config/opencode/opencode.jsonc \
       ~/.config/sketchybar \
       ~/.config/starship   \
       ~/.config/tmux       \
       ~/.config/yazi       \
       ~/.zshrc             \
       2>/dev/null

echo "Creating symlinks..."
# Create necessary folders.
mkdir -p ~/.agents            \
         ~/.claude            \
         ~/.config/aerospace  \
         ~/.config/bat/themes \
         ~/.config/borders    \
         ~/.config/ghostty    \
         ~/.config/herdr      \
         ~/.config/karabiner  \
         ~/.config/nvim       \
         ~/.config/opencode   \
         ~/.config/sketchybar \
         ~/.config/starship   \
         ~/.config/tmux       \
         ~/.config/yazi

# Symlinking files
ln -s ~/dotfiles/AGENTS.md ~/.claude/CLAUDE.md
ln -s ~/dotfiles/AGENTS.md ~/.config/opencode/AGENTS.md
ln -s ~/dotfiles/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/claude/skill-lock.json ~/.agents/.skill-lock.json
ln -s ~/dotfiles/claude/statusline.sh ~/.claude/statusline.sh
ln -s ~/dotfiles/ghostty/config ~/.config/ghostty/config
ln -s ~/dotfiles/herdr/config.toml ~/.config/herdr/config.toml
ln -s ~/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/opencode/command ~/.config/opencode/command
ln -s ~/dotfiles/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -s ~/dotfiles/sketchybar/* ~/.config/sketchybar/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/yazi/theme.toml ~/.config/yazi/theme.toml
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
