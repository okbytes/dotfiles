#!/bin/zsh

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ASK=1
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

[[ -r "$HOME/.path.zsh" ]] && . "$HOME/.path.zsh"
