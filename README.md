# Dotfiles

My configuration files for macOS.

<img width="1920" height="1080" alt="file-d64e9ea5bc86ee33bd71e0e23590d961" src="https://github.com/user-attachments/assets/0416382e-693c-45e0-a427-8891085e8fc9" />

- [Aerospace](https://github.com/nikitabobko/AeroSpace)
- [Claude Code](https://claude.com/claude-code)
- [Ghostty](https://ghostty.org/)
- [Git](https://git-scm.com) + [Delta](https://github.com/dandavison/delta)
- [Herdr](https://herdr.dev)
- [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- [Karabiner Elements](https://karabiner-elements.pqrs.org)
- [Neovim](https://neovim.io)
- [Opencode](https://opencode.ai/)
- [Raycast](https://www.raycast.com)
- [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- [Starship](https://starship.rs)
- [Tmux](https://github.com/tmux/tmux)
- [WezTerm](https://wezfurlong.org/wezterm)
- [Yazi](https://yazi-rs.github.io/)
- [Zsh](https://www.zsh.org)

## Installation

Download the repository in your home directory.

```sh
git clone https://github.com/nicosantux/dotfiles.git ~/dotfiles
```

`cd` into the folder and then run the `install` script.

```sh
cd ~/dotfiles
sh install.sh
```

The script runs every step in [`scripts/`](scripts):

| Script         | What it does                                                                 |
| -------------- | ---------------------------------------------------------------------------- |
| `homebrew.sh`  | Installs Homebrew and disables analytics.                                    |
| `symlinks.sh`  | Symlinks the configs into `~/.config`, `~/.claude` and `~/.zshrc`.           |
| `packages.sh`  | Installs formulae, casks and Mac App Store apps, and sets Homebrew zsh as the default shell. |
| `fonts.sh`     | Installs Dank Mono Nerd Font.                                                |
| `macos.sh`     | Applies macOS system defaults.                                               |
| `services.sh`  | Starts `borders` and `sketchybar`, and authorizes the SketchyBar Wi-Fi helper. |
| `tools.sh`     | Installs tmux plugins, bat theme, rtk, herdr plugins, Node LTS and agent skills. |
| `git.sh`       | Copies the git config to `~/.gitconfig` and asks for your name and email.    |
| `wallpaper.sh` | Sets the wallpaper.                                                          |

> [!NOTE]
> The installer asks for your `sudo` password, your git name and email, and location access for the Wi-Fi helper (needed to read the SSID). The computer restarts when it finishes.
