unsetopt GLOBAL_RCS
export SHELL='zsh'

# Apple
export SHELL_SESSIONS_DISABLE=1

# XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
#export XDG_CACHE_HOME="$HOME/Library/Caches"
#export XDG_CONFIG_HOME="$HOME/Library/Preferences"
#export XDG_DATA_HOME="$HOME/Library/Application Support"

# PATH
typeset -U path PATH
path=(
	/usr/local/bin(N-/)
	/usr/bin
	/bin
	/usr/sbin
	/sbin
)
