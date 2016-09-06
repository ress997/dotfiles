zplug "zplug/zplug"

# Command
zplug "peco/peco", \
	as:command, \
	from:gh-r

zplug "junegunn/fzf-bin", \
	as:command, \
	from:gh-r, \
	rename-to:fzf

zplug "junegunn/fzf", \
	as:command, \
	use:"bin/fzf-tmux", \
	on:"junegunn/fzf-bin"

zplug "monochromegane/the_platinum_searcher", \
	as:command, \
	from:gh-r, \
	rename-to:pt, \
	on:"junegunn/fzf-bin"

zplug "stedolan/jq", \
	as:command, \
	from:gh-r

zplug "motemen/ghq", \
	as:command, \
	from:gh-r

zplug "github/hub", \
	as:command, \
	from:gh-r

zplug "mrowa44/emojify", \
	as:command

zplug "b4b4r07/zsh-gomi", \
	as:command, \
	use:"bin/gomi", \
	on:"junegunn/fzf-bin"

zplug "arukasio/cli", \
	as:command, \
	from:gh-r, \
	rename-to:arukas

zplug "Code-Hex/pget", \
	as:command, \
	from:gh-r

# Plugin
zplug "b4b4r07/emoji-cli", \
	on:"stedolan/jq"

zplug "b4b4r07/enhancd", \
	use:"init.sh"

zplug "39e/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
	nice:15

# vim:ft=zplug:
