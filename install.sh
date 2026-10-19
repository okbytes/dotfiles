#!/bin/sh
# Bootstrap a Mac from okbytes/dotfiles, okbytes/skills and okbytes/pi. Safe to rerun.
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/okbytes/dotfiles/main/install.sh)"
set -eu

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
command -v gh >/dev/null 2>&1 || brew install gh
gh auth status >/dev/null 2>&1 || gh auth login

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://github.com/okbytes/dotfiles/archive/refs/heads/main.tar.gz | tar -xzf - -C "$tmp"
cp -R "$tmp/dotfiles-main/home/." "$HOME/"
echo "dotfiles: copied home/ into ~"

if [ ! -e "$HOME/.gitconfig.local" ]; then
  printf 'git email: '
  read -r email </dev/tty
  printf '[user]\n  email = %s\n' "$email" >"$HOME/.gitconfig.local"
  echo "git: wrote ~/.gitconfig.local"
fi

mkdir -p "$HOME/code"
for repo in skills pi; do
  [ -d "$HOME/code/$repo" ] || gh repo clone "okbytes/$repo" "$HOME/code/$repo"
done

mkdir -p "$HOME/.pi/agent"
if [ ! -e "$HOME/.pi/agent/settings.json" ]; then
  cp "$HOME/code/pi/settings.json" "$HOME/.pi/agent/settings.json"
  echo "pi: seeded settings.json"
fi

# link TARGET SOURCE: make TARGET a symlink to SOURCE. A real directory there moves under ~/.dotfiles.bak,
# outside the skills and extensions folders so nothing keeps loading it.
link() {
  if [ -L "$1" ]; then
    [ "$(readlink "$1")" = "$2" ] && return
    rm "$1"
  elif [ -e "$1" ]; then
    bak="$HOME/.dotfiles.bak${1#"$HOME"}"
    mkdir -p "$(dirname "$bak")" && mv "$1" "$bak"
    echo "moved $1 to $bak"
  fi
  mkdir -p "$(dirname "$1")"
  ln -s "$2" "$1"
  echo "linked $1 -> $2"
}
for skill in "$HOME"/code/skills/*/; do
  skill=${skill%/}
  link "$HOME/.claude/skills/${skill##*/}" "$skill"
  link "$HOME/.agents/skills/${skill##*/}" "$skill"
done
link "$HOME/.pi/agent/extensions" "$HOME/code/pi/extensions"
link "$HOME/.pi/agent/themes" "$HOME/code/pi/themes"
echo "done"
