if [[ "${(L)$( uname -s )}" == darwin ]]; then
	alias ls='ls -G -F'
fi

alias la='ls -A'
alias ll='la -l'
alias lla='ls -lA'

autoload -Uz zmv
alias rename='noglob zmv -W'
