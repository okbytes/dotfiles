#!/bin/zsh

setopt NO_NOMATCH
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

alias ..="cd ../"
alias ~="cd $HOME"
alias c="clear"
if [[ $OSTYPE == darwin* ]]; then
  alias ll="ls -FGhA"
  alias ls="ls -FGh"
else
  alias ll="ls -FhA --color=auto"
  alias ls="ls -Fh --color=auto"
fi
# git
alias s="git status -sb"
alias ga="git add ."
alias gsy="git sy"
alias gco="git co"
alias gcm="git cm"
alias lgg="git log --pretty=format:'%C(auto)%h%C(auto)%d %s %C(cyan)%an %C(green)%ar%Creset'"
alias lg="lgg -n 5"
alias mm="git switch main"

alias py="python3"

quik() {
  local msg="${1:-WIP: $(date '+%a %b %-d, %Y %-I:%M %p')}"
  git stash push --staged -m "$msg"
}
brewd() {
  { brew leaves; brew list --cask; } |
    xargs brew deps --installed --for-each 2>/dev/null |
    sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"
}

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

# Prompt: git operation, virtualenv marker, arrow.
setopt PROMPT_SUBST
PROMPT_EOL_MARK=''
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Name the git operation in progress by reading .git directly; vcs_info forks git for the same answer.
prompt_precmd() {
  local dir=$PWD gitdir
  prompt_git_action=
  until [[ -e $dir/.git ]]; do
    [[ $dir == / ]] && return
    dir=${dir:h}
  done
  gitdir=$dir/.git
  if [[ -f $gitdir ]]; then
    gitdir=${"$(<$gitdir)"#gitdir: }
    [[ $gitdir == /* ]] || gitdir=$dir/$gitdir
  fi
  if [[ -d $gitdir/rebase-merge || -d $gitdir/rebase-apply ]]; then prompt_git_action=rebase
  elif [[ -f $gitdir/MERGE_HEAD ]]; then prompt_git_action=merge
  elif [[ -f $gitdir/CHERRY_PICK_HEAD ]]; then prompt_git_action=cherry-pick
  elif [[ -f $gitdir/REVERT_HEAD ]]; then prompt_git_action=revert
  elif [[ -f $gitdir/BISECT_LOG ]]; then prompt_git_action=bisect
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_precmd

# Plain ASCII when the locale can't count the arrow's width (ssh without a UTF-8 locale).
zmodload zsh/langinfo
[[ $langinfo[CODESET] == UTF-8 ]] && prompt_arrow='❱' || prompt_arrow='>'
prompt_arrow_color='#ffd866'
[[ -n $SSH_CONNECTION ]] && prompt_arrow_color=magenta

PROMPT='%F{yellow}${prompt_git_action:+$prompt_git_action }%F{green}${VIRTUAL_ENV:+$prompt_arrow}%F{$prompt_arrow_color}$prompt_arrow%f '

[[ -r "$BUN_INSTALL/_bun" ]] && . "$BUN_INSTALL/_bun"
