#!/bin/zsh

# Keep one copy of each directory when .profile runs again and prepends its list.
typeset -U path PATH
[[ -r "$HOME/.profile" ]] && . "$HOME/.profile"
