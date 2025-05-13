#!/usr/bin/env bash

# Install Homebrew if it isn't already installed.
if ! command -v brew &>/dev/null; then
  echo "Homebrew not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session.
    if [ -x "/opt/homebrew/bin/brew" ]; then
      # For Apple Silicon Macs.
      echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
      export PATH="/opt/homebrew/bin:$PATH"
    fi
  else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible.
if ! command -v brew &>/dev/null; then
  echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
  exit 1
fi

brew analytics off

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
       ~/.config/wezterm    \
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
         ~/.config/wezterm

# Symlinking files
ln -s ~/dotfiles/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -s ~/dotfiles/borders/bordersrc ~/.config/borders/bordersrc
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/sketchybar/* ~/.config/sketchybar/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc

echo "Tapping Brew..."
tap=(
  "felixkratz/formulae"
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
  "borders"
  "bun"
  "eza"
  "fd"
  "fnm"
  "fzf"
  "git"
  "git-delta"
  "ical-buddy"
  "jq"
  "lazygit"
  "mas"
  "neovim"
  "ripgrep"
  "sketchybar"
  "starship"
  "tmux"
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
  "aerospace"
  "arc"
  "brave-browser"
  "discord"
  "docker"
  "figma"
  "font-sf-mono"
  "font-sf-pro"
  "karabiner-elements"
  "keka"
  "raycast"
  "runjs"
  "sf-symbols"
  "slack"
  "spotify"
  "visual-studio-code"
  "vlc"
  "wezterm"
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

# Add sketchybar app font.
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.29/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf

echo "Installing Mac App Store apps..."

mas_apps=(
  "747648890" # Telegram
  "310633997" # WhatsApp Messenger
)

for app in "${mas_apps[@]}"; do
  mas install "$app"
done

# macOS settings
echo "Changing macOS settings..."

# Show all file extensions in Finder.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Set the fastest key repeat rate for quicker typing.
defaults write NSGlobalDomain KeyRepeat -int 1
# Disable automatic spelling correction system-wide.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false
# Disable window animations for faster opening and closing.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# Automatically hide the macOS menu bar.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
# Invert scroll direction to "unnatural" (classic scrolling behavior).
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Show all hidden files in Finder (e.g., files starting with ".").
defaults write com.apple.Finder AppleShowAllFiles -bool true
# Disable the warning prompt when opening apps downloaded from the internet.
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Prevent Time Machine from prompting to use new disks for backups.
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
# Prevent macOS from creating .DS_Store files on network drives.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Automatically hide the Dock when not in use.
defaults write com.apple.dock autohide -bool true
# Disable Finder animations for a faster experience.
defaults write com.apple.finder DisableAllAnimations -bool true
# Set Finder's default search scope to the current folder.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file's extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Set the Finder's default view style to "List View."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Hide external hard drives from the desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
# Hide internal hard drives from the desktop.
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# Hide mounted servers from the desktop.
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
# Hide removable media (e.g., USB drives) from the desktop.
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
# Disable the Finder's status bar for a cleaner look.
defaults write com.apple.finder ShowStatusBar -bool false
# Remove the shadow effect from window screenshots.
defaults write com.apple.screencapture disable-shadow -bool true

# Start services.
echo "Starting services..."

services=(
  "borders"
  "sketchybar"
)

for service in "${services[@]}"; do
  brew services start "$service"
done

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

# Install Dank Mono Nerd Font.
echo "Installing Dank Mono Nerd Font..."
cp ~/dotfiles/fonts/DankMonoNerdFont-Regular.ttf ~/Library/Fonts/
cp ~/dotfiles/fonts/DankMonoNerdFont-Italic.ttf ~/Library/Fonts/

# Configure git username and email.
echo "Enter your git username"
read username

echo "Enter your git email"
read email

git config --global user.name "$username"
git config --global user.email "$email"

# Configure git zsh completion.
echo "Configuring git completions..."
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.zsh/_git
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Set wallpaper
echo "Changing wallpaper..."
osascript -e 'tell application "System Events" to set picture of every desktop to "~/dotfiles/wallpapers/wallpaper-01.jpg"'

echo "Your development environment has been configured"

# Restart the computer to apply all changes.
for ((i=5; i>=1; i--)); do
  echo "Restarting your computer in $i seconds"
  sleep 1
done

sudo shutdown -r now
