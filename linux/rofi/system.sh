#!/usr/bin/env zsh

local -A list=(
	'Suspend' 'systemctl suspend'
	'Reboot' 'systemctl reboot'
	'Shutdown' 'systemctl poweroff'
)

if [[ -f ~/.config/systemd/user/lock-now.service ]]; then
	list+=(
		'Lock' 'systemctl --user start lock-now.service'
	)
fi

if (( $+commands[swaymsg] )); then
	list+=(
		'Logout' 'swaymsg exit'
	)
elif (( $+commands[i3-msg] )); then
	list+=(
		'Logout' 'i3-msg exit'
	)
fi

if [[ -n ${1} ]]; then
	eval ${list[$1]}
else
	echo ${(ko)list} | sed 's/ /\n/g'
fi
