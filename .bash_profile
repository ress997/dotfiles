#!/usr/bin/env bash

# XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# XDG User Directory
export HISTFILE="$XDG_DATA_HOME/bash/history"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Terminal
export TERMINAL=alacritty

# Dev
export DEV_TMP=${DEV_TMP:-`mktemp -d`}
export DEV_DOT="$HOME/.local/src/github.com/ress997/dotfiles"

# change shell
export SHELL=zsh
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi
