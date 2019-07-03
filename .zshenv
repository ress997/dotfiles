unsetopt GLOBAL_RCS

export SHELL='zsh'

# Lang
export LANGUAGE="ja_JP.UTF-8"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"
export LANG="${LANGUAGE}"

# Editor
export EDITOR='vi'

# Pager
export PAGER='less'

# golang
export GOPATH="$HOME/.go"

# PATH
typeset -U path PATH
path=(
	$GOPATH/bin
	/usr/local/bin(N-/)
	$path
)
