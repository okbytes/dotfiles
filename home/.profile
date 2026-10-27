#!/bin/sh

# Environment for every shell, in POSIX sh. Login shells read it directly or through
# .bash_profile, and zsh sources it from .zshenv and .zprofile.

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ASK=1
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

export GOBIN="$HOME/go/bin"
export BUN_INSTALL="$HOME/.bun"

PATH="$GOBIN:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/go/bin:$PATH"
# Bun's bin goes last so ~/.local/bin/pi, which runs Pi with Bun, wins over Bun's node-shebang link.
PATH="$PATH:$BUN_INSTALL/bin"
export PATH

if command -v zed >/dev/null 2>&1; then
  export EDITOR="zed --wait"
  export VISUAL="zed"
fi
