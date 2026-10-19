path=(
  $GOBIN
  $HOME/.local/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  $path
)
# Bun's bin goes last so ~/.local/bin/pi, which runs Pi with Bun, wins over Bun's node-shebang link.
path+=($BUN_INSTALL/bin)
typeset -aU path
export PATH
