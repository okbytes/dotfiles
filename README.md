# dotfiles

A seed for a new machine, not a sync. `home/` supplies starting files; each machine's copies then drift freely. Back-port a change here only when it has earned a place on the next machine.

## Install

From a checkout:

```sh
sh install.sh
```

The installer copies each file in `home/` into `~` unless that file already exists, so rerunning it only fills in what is missing. To take a newer version, delete your copy and rerun. It installs no packages.

On Linux, a new account's `~/.bashrc` and `~/.profile` are copies of `/etc/skel`. The installer replaces a file that still matches its `/etc/skel` copy and keeps one you have edited. Leave the copied `~/.bash_profile` in place: login bash reads it instead of `~/.profile`.

The Linux account stays bash. These files do not need zsh.

Agent instructions and skills come from [okbytes/skills](https://github.com/okbytes/skills), which has its own installer.

## Shells

Edit `.profile` and `.shrc`. The other shell files are hooks the shells require by name.

- `.profile` sets the environment and `PATH`, in POSIX sh.
- `.shrc` holds the aliases, functions, and prompt, for bash and zsh and for GNU and BSD tools.

On the Macs, zsh is the login shell. `~/.zprofile` sources `.profile` after macOS `path_helper` has reordered `PATH`. `~/.zshrc` loads `.shrc`, then sets up history and completion. Rex and Tinycast start a login zsh, so they see `PATH`. Zed takes its environment from a login zsh. A non-login `zsh -c` does not.

On the Linux box, bash is the login shell. `~/.bash_profile` loads `.profile` and `~/.bashrc`. `~/.bashrc` returns unless the shell is interactive, then loads `.shrc`. A Rex pane gets the aliases. `rex run` gets `PATH` and not the aliases. `ssh host some-command` gets neither, and a service does not either.

Copy the same files to every machine. Bash does not read the zsh hooks. Zsh does not read the bash hooks.

## Local configuration

Git includes `~/.gitconfig.local` for settings that belong to one machine, such as your name and email. Create it yourself; this repository does not supply it.
