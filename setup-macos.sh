#!/usr/bin/env bash

# Install Homebrew if it isn't already installed.
if ! command -v brew &>/dev/null; then
  echo "Homebrew not installed. Installing Homebrew."
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


# Update Homebrew and Upgrade any already-installed formula.
brew update
brew upgrade
brew upgrade --cask
brew cleanup

echo "Removing existing dotfiles"
# Remove files if they already exist.
rm -rf ~/.gitconfig ~/.zshrc ~/.config/bat ~/.config/karabiner ~/.config/nvim ~/.config/starship ~/.config/tmux ~/.config/wezterm 2>/dev/null

echo "Creating symlinks"
# Create necessary folders.
mkdir -p ~/.config/bat/themes/ ~/.config/karabiner ~/.config/nvim ~/.config/starship ~/.config/tmux ~/.config/wezterm

# Symlinking files
ln -s ~/dotfiles/bat-theme/kanagawa.tmTheme ~/.config/bat/themes/kanagawa.tmTheme
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc

# Define an array of packages to install using Homebrew.
packages=(
  "bat"
  "eza"
  "fnm"
  "fzf"
  "git",
  "git-delta"
  "lazygit"
  "neovim"
  "ripgrep"
  "starship"
  "tmux"
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
echo "Changing default shell to Homebrew zsh"
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells >/dev/null
# Set the Homebrew zsh as default shell.
chsh -s "$(brew --prefix)/bin/zsh"

# Define an array of applications to install using Homebrew Cask.
apps=(
  "arc"
  "discord"
  "karabiner-elements"
  "raycast"
  "spotify"
  "visual-studio-code"
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

# Update and clean up again for safe measure.
brew update
brew upgrade
brew upgrade --cask
brew cleanup

sed -i '/# zsh-autosuggestions/a source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ~/.zshrc
sed -i '/# zsh-syntax-highlighting/a source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc

# Install tmux tpm.
echo "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Enable bat theme.
echo "Enabling bat theme"
bat cache --build

# Install node lts.
echo "Installing Node LTS"
fnm install --lts

# Install Dank Mono Nerd Font.
echo "Installing Dank Mono Nerd Font"
cp -r ~/dotfiles/fonts/DankMonoNerdFont-Regular.ttf ~/Library/Fonts/
cp -r ~/dotfiles/fonts/DankMonoNerdFont-Italic.ttf ~/Library/Fonts/

# Configure git username and email.
echo "Enter your git username"
read username

echo "Enter your git email"
read email

git config --global user.name "$username"
git config --global user.email "$email"

# Configure git zsh completion.
echo "Configuring git completions"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.zsh/_git
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

echo "Your development environment has been configured"

# Restart the computer to apply all changes.
for ((i=5; i>=1; i--)); do
  echo "Restarting your computer in $i seconds"
  sleep 1
done

sudo shutdown -r now
