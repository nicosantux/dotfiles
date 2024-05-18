# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=5000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# vi mode
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fnm
eval "$(fnm env --use-on-cd)"

# User configuration

alias bye="rm -rf"
alias cat="bat"
alias cd="z"
alias ga="git add"
alias gaa="git add ."
alias gb="git branch"
alias gbb="git bb"
alias gco="git checkout"
alias gct="git commit"
alias gfo="git fetch origin --prune"
alias gl="git log"
alias gll="git log --oneline --decorate --graph"
alias gph="git push"
alias gpl="git pull"
alias gst="git status -u"
alias gsw="git switch"
alias lg="lazygit"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias pn="pnpm"
alias px="pnpx"
alias tm="tmux"
alias tma="tmux attach"
alias vim="nvim"


# bun completions
[ -s "/Users/nicosantux/.bun/_bun" ] && source "/Users/nicosantux/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/nicosantux/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# FZF

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Use fd instead of fzf

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# The first argument to the function ($1) is the base path to start traversal
# See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# The first argument to the function is the name of the command.
# You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Bat

export BAT_THEME=kanagawa

# Zoxide
eval "$(zoxide init zsh)"
