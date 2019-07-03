#!/usr/bin/env zsh

typeset -g -A _dotlist=()
typeset -g    DOTPATH="$HOME/.local/src/github.com/ress997/dotfiles"

# --- func --- {{{
__dot::add() {
	_dotlist+=("$1" "${2:-"$1"}")
}
__dot::add::dir() {
	_dotlist+=("$1" ".config/${2:-"$1"}")
}
# }}}

# zsh {{{
__dot::add ".zshenv"
__dot::add ".zprofile"
__dot::add ".zshrc"

# }}}

# git {{{
if (( $+commands[git] )); then
	__dot::add::dir "git/config"
	__dot::add::dir "git/ignore"
	__dot::add::dir "git/message.txt"

	if (( $+commands[tig] )); then
		__dot::add::dir "tig/config"
	fi
fi
# }}}

# mac {{{
if [[ "${(L)$( uname -s )}" == mac ]]; then
	__dot::add ".bash_profile"

	__dot::add::dir "kitty"

	if (( $+commands[git] )); then
		__dot::add::dir "git/local/mac" "git/local"
	fi

	if (( $+commands[tmux] )); then
		__dot::add::dir "tmux"
	fi

fi
# }}}

# linux {{{
if [[ "${(L)$( uname -s )}" == linux ]]; then

	__dot::add ".xinitrc"
	__dot::add ".bash_profile"

	if (( $+commands[git] )); then
		__dot::add::dir "git/local/linux" "git/local"
	fi

	if (( $+commands[xkeysnail] )); then
		__dot::add::dir "xkeysnail"
	else
		__dot::add ".Xmodmap"
	fi

	if (( $+commands[i3] )); then
		__dot::add::dir "i3/config"
		__dot::add::dir "i3/screenshot.sh"
	fi

	if (( $+commands[polybar] )); then
		__dot::add::dir "polybar/config"
		__dot::add::dir "polybar/launch.sh"
	fi

	if (( $+commands[rofi] )); then
		__dot::add::dir "rofi/config"
		__dot::add::dir "rofi/system.sh"
		__dot::add::dir "rofi/theme.rasi"
	fi

	if (( $+commands[dunst] )); then
		__dot::add::dir "dunst/dunstrc"
	fi
fi
# }}}

{
	for f in ${(k)_dotlist}; do
		if [[ -f "$DOTPATH/$f" ]]; then
			p="$HOME/${_dotlist[$f]}"
			[[ -d "${p:h}" ]] || mkdir -p ${p:h}
			ln -sf "$DOTPATH/$f" "$p"
		fi
	done
}
