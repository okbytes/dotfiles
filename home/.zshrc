#!/bin/zsh

setopt NO_NOMATCH
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
PROMPT_EOL_MARK=''

[[ -r "$HOME/.shrc" ]] && . "$HOME/.shrc"

sz() {
  [[ -r "$HOME/.zshrc" ]] && . "$HOME/.zshrc"
}

# Run the full compinit check once per day; otherwise trust the existing dump.
autoload -Uz compinit
local zcd=$HOME/.zcompdump
local zcd_stamp=$HOME/.zcompdump-check-date
local zcd_today=$(date +%Y-%m-%d)
if [[ ! -f "$zcd" || ! -f "$zcd_stamp" || $(<"$zcd_stamp") != "$zcd_today" ]]; then
  if compinit -d "$zcd"; then
    print -r -- "$zcd_today" >| "$zcd_stamp"
  fi
else
  compinit -C -d "$zcd"
fi

[[ -r "$BUN_INSTALL/_bun" ]] && . "$BUN_INSTALL/_bun"
