# Hub
(( $+commands[hub] )) && function git(){hub "$@"}

# ghq
if (( $+commands[ghq] )); then
	local DIRECTORY
	ghq-browse() {
		DIRECTORY=$(ghq list | $(available $FILTER) | cut -d "/" -f 2,3) && hub browse $DIRECTORY
	}
	ghq-update() {
		ghq list | sed 's|.[^/]*/||' | xargs -n 1 -P 10 ghq get -u
	}
fi
