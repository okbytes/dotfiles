#!/bin/sh
# Copy home/ into ~. Never replace a file that already exists, except an untouched /etc/skel copy.
# Run from a checkout: sh install.sh
set -eu

cd -P "$(dirname "$0")"
if [ ! -d home ]; then
  echo "install.sh: run it from a checkout of this repository" >&2
  exit 1
fi
src=$(CDPATH= cd -P home && pwd)

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
