#!/usr/bin/env bash

# Install yay if it isn't already installed.
if ! command -v yay &>/dev/null; then
  echo "yay not installed. Installing yay..."
  sudo pacman -Sy --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  cd
  rm -rf ~/yay
else
  echo "yay is already installed"
fi

# Update system packages.
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

echo "Removing existing dotfiles"
# Remove files if they already exist.
rm -rf ~/.gitconfig ~/.Xmodmap ~/.zshrc ~/.config/bat ~/.config/i3 ~/.config/nvim ~/.config/picom ~/.config/polybar ~/.config/rofi ~/.config/starship ~/.config/tmux ~/.config/wezterm ~/.zshrc ~/.gitconfig 2>/dev/null

echo "Creating symlinks"
# Create necessary folders.
mkdir -p ~/.config/bat/themes/ ~/.config/i3 ~/.config/nvim ~/.config/picom ~/.config/polybar ~/.config/rofi ~/.config/starship ~/.config/tmux ~/.config/wezterm

# Symlinking files.
ln -s ~/dotfiles/bat-theme/kanagawa.tmTheme ~/.config/bat/themes/kanagawa.tmTheme
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/i3/config ~/.config/i3/config
ln -s ~/dotfiles/nvim/* ~/.config/nvim/
ln -s ~/dotfiles/picom/picom ~/.config/picom
ln -s ~/dotfiles/polybar/* ~/.config/polybar/
ln -s ~/dotfiles/rofi/* ~/.config/rofi/
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship/starship.toml
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -s ~/dotfiles/xmodmap/Xmodmap ~/.Xmodmap
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc

# Define an array of packages to install using pacman.
packages=(
  "bat"
  "eza"
  "fd"
  "fzf"
  "git",
  "git-delta"
  "i3"
  "lazygit"
  "neovim"
  "ripgrep"
  "starship"
  "tmux"
  "xclip"
  "xorg"
  "zoxide"
  "zsh"
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
  if pacman -Qq | grep -q "^$package\$"; then
    echo "$package is already installed. Skipping..."
  else
    echo "Installing $package..."
    sudo pacman -S --noconfirm "$package"
  fi
done

# Define an array of applications to install using AUR yay.
apps=(
  "brave"
  "discord"
  "feh"
  "fnm"
  "picom"
  "polybar"
  "rofi"
  "spotify"
  "visual-studio-code"
  "wezterm"
)

# Loop over the array to install each application.
for app in "${apps[@]}"; do
  if yay -Qq | grep -q "^$app\$"; then
    echo "$app is already installed. Skipping..."
  else
    echo "Installing $app..."
    yay -S --noconfirm "$app"
  fi
done

echo "Setting zsh as your default terminal"
chsh -s "$(which zsh)"

sed -i '/# zsh-autosuggestions/a source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' ~/.zshrc
sed -i '/# zsh-syntax-highlighting/a source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc

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
mkdir -p ~/.local/share/fonts
cp -r ~/dotfiles/fonts/DankMonoNerdFont-Regular.ttf ~/.local/share/fonts
cp -r ~/dotfiles/fonts/DankMonoNerdFont-Italic.ttf ~/.local/share/fonts

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

shutdown -r now
