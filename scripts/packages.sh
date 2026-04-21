#!/usr/bin/env bash

echo "Tapping Brew..."
tap=(
  "felixkratz/formulae"
  "gentleman-programming/tap"
  "nikitabobko/tap"
  "oven-sh/bun"
)

for tap in "${tap[@]}"; do
  if brew tap | grep -q "^$tap\$"; then
    echo "$tap is already tapped. Skipping..."
  else
    echo "Tapping $tap..."
    brew tap "$tap"
  fi
done

# Define an array of packages to install using Homebrew.
packages=(
  "bat"
  "carapace"
  "eza"
  "fd"
  "felixkratz/formulae/borders"
  "felixkratz/formulae/sketchybar"
  "fnm"
  "fzf"
  "gentleman-programming/tap/engram"
  "gh"
  "git"
  "git-delta"
  "jq"
  "lazygit"
  "mas"
  "neovim"
  "opencode"
  "oven-sh/bun/bun"
  "pstree"
  "ripgrep"
  "starship"
  "tmux"
  "tree"
  "tree-sitter-cli"
  "yazi"
  "zoxide"
  "zsh"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
  if brew list --formula | grep -q "^$package\$"; then
    echo "$package is already installed. Skipping..."
  else
    echo "Installing $package..."
    brew install "$package"
  fi
done

# Add the Homebrew zsh to allowed shells.
echo "Changing default shell to Homebrew zsh..."
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells >/dev/null
# Set the Homebrew zsh as default shell.
chsh -s "$(brew --prefix)/bin/zsh"

# Define an array of applications to install using Homebrew Cask.
apps=(
  "affinity"
  "arc"
  "claude"
  "discord"
  "docker-desktop"
  "figma"
  "font-sf-pro"
  "font-sketchybar-app-font"
  "ghostty"
  "karabiner-elements"
  "keka"
  "nikitabobko/tap/aerospace"
  "notion"
  "raycast"
  "sf-symbols"
  "slack"
  "spotify"
)

# Loop over the array to install each application.
for app in "${apps[@]}"; do
  if brew list --cask | grep -q "^$app\$"; then
    echo "$app is already installed. Skipping..."
  else
    echo "Installing $app..."
    brew install --cask "$app"
  fi
done

echo "Installing Mac App Store apps..."

mas_apps=(
  "747648890" # Telegram
  "310633997" # WhatsApp Messenger
)

for app in "${mas_apps[@]}"; do
  mas install "$app"
done
