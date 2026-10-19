# dotfiles

A starter kit for a new Mac, not a sync. `home/` is copied into `~` once; after that each machine's files drift freely and nothing syncs back. Back-port a change here only when it has earned a place on the next machine.

## Bootstrap

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/okbytes/dotfiles/main/seed.sh)"
```

`seed.sh` installs Homebrew and `gh` if missing, signs in to GitHub, copies `home/` into `~`, asks for a git email on the first run and keeps it in `~/.gitconfig.local` (which the copied gitconfig includes, so the address stays out of this repo), clones [okbytes/skills](https://github.com/okbytes/skills) and [okbytes/pi](https://github.com/okbytes/pi) into `~/code`, and symlinks the agent skills, Pi extensions and Pi themes into place. An existing real directory at any of those paths is kept under `~/.seed.bak`. It is safe to rerun.

## Pi settings

`~/.pi/agent/settings.json` comes from `settings.json` in the pi repo, copied only when the file does not already exist. Pi rewrites it at runtime, so it is a copy rather than a symlink and local changes stay local.
