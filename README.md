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

On Linux, a new account's `~/.bashrc` and `~/.profile` are copies of the distribution's `/etc/skel` files. The installer replaces a file that still matches its `/etc/skel` copy and keeps one you've edited.

Agent instructions and skills come from [okbytes/skills](https://github.com/okbytes/skills), which has its own installer.

## Shells

The same files serve zsh and bash, on macOS and Linux:

- `.profile` sets the environment and `PATH` in POSIX sh. Login shells read it, and zsh also loads it from `.zshenv` and `.zprofile`.
- `.shrc` holds the aliases, functions, and prompt, written for both bash and zsh and for both GNU and BSD tools.
- `.zshrc` and `.bashrc` load `.shrc`, then set up that shell's history and completion. `.bash_profile` loads `.profile` and `.bashrc` for a login bash.

## Local configuration

Git includes `~/.gitconfig.local` for settings that belong to one machine, such as your name and email. Create it yourself; this repository doesn't supply it.
