#!/bin/zsh

setopt NO_NOMATCH
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

alias ..="cd ../"
alias ~="cd $HOME"
alias c="clear"
alias ll="ls -FGhA"
alias ls="ls -FGh"

alias s="git status -sb"
alias cm="git commit -m"
alias ga="git add ."
alias gm="git commit --amend --no-edit"
alias mm="git switch main"

alias py="python3"

lg() {
  local fmt='%C(auto)%h%C(auto)%d %s %C(cyan)%an %C(green)%ar%Creset'
  local count=5
  if [[ ${1-} == <-> ]]; then
    count=$1
    shift
  fi
  git log --pretty=format:"$fmt" -n "$count" "$@"
}
co() {
  local b
  if (( $# > 0 )); then
    git switch "$@"
    return $?
  fi
  b=$(git branch --sort=-committerdate --format='%(if)%(HEAD)%(then)%(else)%(refname:short)%(end)' | sed '/^$/d' | fzb) || return $?
  [[ -n "$b" ]] && git switch "$b"
}
sy() {
  local c b n o branches prs
  c=$(git branch --show-current) || return $?
  if [[ -z "$c" ]]; then
    print -u2 -- 'sy: switch to a branch before syncing'
    return 1
  fi
  git fetch origin || return $?
  if [[ "$c" == main ]]; then
    git pull --rebase || return $?
  else
    git branch -f main origin/main || return $?
    git rebase origin/main || return $?
  fi
  branches=$(git branch --format='%(refname:short)') || return $?
  while IFS= read -r b; do
    case "$b" in main|"$c") continue;; esac
    # A reused branch with an open PR must survive an older closed PR.
    prs=$(gh pr list --head "$b" --state all --limit 100 \
      --json number,headRefOid,isCrossRepository,state \
      -q 'if any(.[]; .state == "OPEN" and (.isCrossRepository | not)) then empty else .[] | select(.isCrossRepository | not) | [.number, .headRefOid] | @tsv end' </dev/null) || return $?
    while IFS=$'\t' read -r n o; do
      [[ -n "$n" && -n "$o" ]] || continue
      if ! git cat-file -e "$o^{commit}" 2>/dev/null; then
        git fetch -q origin "pull/$n/head" </dev/null || return $?
        git cat-file -e "$o^{commit}" 2>/dev/null || continue
      fi
      # Keep local commits that were never part of the closed PR.
      if git merge-base --is-ancestor "refs/heads/$b" "$o"; then
        git branch -D -- "$b" >/dev/null || return $?
        print -r -- "● Deleted $b (PR #$n closed)"
        break
      fi
    done <<< "$prs"
  done <<< "$branches"
}
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
