# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme - choose one you like
# Popular options: robbyrussell (default), agnoster, powerlevel10k/powerlevel10k, jonathan, af-magic
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  docker-compose
  node
  npm
  python
  colored-man-pages
  extract
  sudo
  web-search
  copypath
  copyfile
  history
)

# Oh My Zsh configuration
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# Uncomment if you want case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment for hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# Uncomment to disable auto-setting terminal title
# DISABLE_AUTO_TITLE="true"

# Uncomment to enable command auto-correction
# ENABLE_CORRECTION="true"

# Completion dots
COMPLETION_WAITING_DOTS="true"

# Timestamp format in history command
HIST_STAMPS="yyyy-mm-dd"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Additional aliases
alias v='nvim'
alias vim='nvim'
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias reload='source ~/.zshrc'

# Better ls
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts (oh-my-zsh git plugin provides many, these are extras)
alias glog='git log --oneline --graph --decorate --all'
alias gwip='git add -A && git commit -m "WIP"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

# System
alias c='clear'
alias h='history'

# Functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Quick find
ff() {
  find . -type f -name "*$1*"
}

fd() {
  find . -type d -name "*$1*"
}

# PATH additions
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Node Version Manager (if you use it)
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust cargo
# export PATH="$HOME/.cargo/bin:$PATH"

# Go
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOPATH/bin

# Python
# export PATH="$HOME/.local/bin:$PATH"

# Homebrew (macOS)
# if [[ "$(uname)" == "Darwin" ]]; then
#   eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

# Custom local configurations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local



# For NG Elliot Agent
export GITLAB_PYPI_TOKEN=""
export PIP_EXTRA_INDEX_URL="https://__token__:${GITLAB_PYPI_TOKEN}@gitlab.bosonit.com/api/v4/groups/1946/-/packages/pypi/simple"

# Syntax highlighting and autosuggestions styling
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
