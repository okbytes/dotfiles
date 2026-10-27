#!/bin/bash

# A login bash reads only this file, so it loads the other two.
[[ -r "$HOME/.profile" ]] && . "$HOME/.profile"
[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
