unsetopt GLOBAL_RCS
export SHELL='zsh'

# PATH
typeset -U path PATH
path=(
	/usr/local/bin(N-/)
	$path
)
