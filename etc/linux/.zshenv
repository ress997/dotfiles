unsetopt GLOBAL_RCS
export SHELL='zsh'

# Lang
export LANGUAGE="ja_JP.UTF-8"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"
export LANG="${LANGUAGE}"

# PATH
typeset -U path PATH
path=(
	/usr/local/bin(N-/)
	$path
)
