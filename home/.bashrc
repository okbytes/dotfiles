#!/bin/bash

case $- in *i*) ;; *) return ;; esac

HISTCONTROL=ignoredups:erasedups
HISTSIZE=2000
HISTFILESIZE=2000
shopt -s histappend

[[ -r "$HOME/.shrc" ]] && . "$HOME/.shrc"

sz() {
  [[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
}

# Load completions unless the system already has; Debian and Ubuntu leave it to ~/.bashrc.
if [[ -z ${BASH_COMPLETION_VERSINFO-} && -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi
