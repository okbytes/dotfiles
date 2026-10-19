# dotfiles

A seed for a new machine, not a sync. `home/` supplies starting files; each machine's copies then drift freely. Back-port a change here only when it has earned a place on the next machine.

## Install

From a checkout:

```sh
sh install.sh
```

Or without cloning:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/okbytes/dotfiles/main/install.sh)"
```

The installer copies each file in `home/` into `~` unless a file already exists there, so rerunning it only fills in what's missing. To take a newer version of a file, delete your copy and rerun. It installs no packages and clones no repositories.

Agent instructions and skills come from [okbytes/skills](https://github.com/okbytes/skills), which has its own installer.

## Local configuration

Git includes `~/.gitconfig.local` for settings that belong to one machine, such as your name and email. Create it yourself; this repository doesn't supply it.
