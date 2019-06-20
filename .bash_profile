#!/usr/bin/env bash
export LANG=ja_JP.UTF-8

# XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# XDG User Directory
export HISTFILE="$XDG_DATA_HOME/bash/history"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Terminal
export TERMINAL=alacritty

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	# change shell
	export SHELL=zsh

	exec sway
fi
