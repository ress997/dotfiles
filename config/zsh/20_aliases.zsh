alias rm='rm -i'

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

if [[ "${(L)$( uname -s )}" == darwin ]]; then
	alias ls='ls -G -F'
fi

alias la='ls -A'
alias ll='la -l'
alias lla='ls -lA'
