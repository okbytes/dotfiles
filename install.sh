#!/bin/sh
# Seed ~ with this repository's home/ files, never replacing one that already exists. Safe to rerun.
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/okbytes/dotfiles/main/install.sh)"
set -eu

if [ -f "$0" ] && [ -d "$(dirname "$0")/home" ]; then
  src=$(CDPATH= cd -P "$(dirname "$0")/home" && pwd)
else
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  trap 'exit 1' HUP INT TERM
  curl -fsSL https://github.com/okbytes/dotfiles/archive/refs/heads/main.tar.gz -o "$tmp/dotfiles.tar.gz"
  tar -xzf "$tmp/dotfiles.tar.gz" -C "$tmp"
  src=$tmp/dotfiles-main/home
fi

find "$src" -type f ! -name .DS_Store | sort | while IFS= read -r file; do
  rel=${file#"$src"/}
  dest=$HOME/$rel
  # A new Linux account starts with copies of /etc/skel, such as .bashrc; an untouched one holds nothing of yours.
  if [ -f "$dest" ] && [ ! -L "$dest" ] && [ -f "/etc/skel/$rel" ] && cmp -s "$dest" "/etc/skel/$rel"; then
    cp "$file" "$dest"
    echo "replaced $dest (unchanged from /etc/skel)"
  elif [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "kept $dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
    echo "added $dest"
  fi
done
