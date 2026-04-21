#!/usr/bin/env bash

echo "Removing existing dotfiles..."
# Remove files if they already exist.
rm -rf ~/.gitconfig         \
       ~/.zshrc             \
       ~/.config/aerospace  \
       ~/.config/bat        \
       ~/.config/borders    \
       ~/.config/karabiner  \
       ~/.config/nvim       \
       ~/.config/sketchybar \
       ~/.config/starship   \
       ~/.config/tmux       \
       ~/.config/yazi       \
       2>/dev/null

echo "Creating symlinks..."
# Create necessary folders.
mkdir -p ~/.config/aerospace  \
         ~/.config/bat/themes \
         ~/.config/borders    \
         ~/.config/karabiner  \
         ~/.config/nvim       \
         ~/.config/sketchybar \
         ~/.config/starship   \
         ~/.config/tmux       \
         ~/.config/yazi

# Symlinking files
ln -s ~/dotfiles/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/sketchybar/* ~/.config/sketchybar/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/yazi/theme.toml ~/.config/yazi/theme.toml
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
