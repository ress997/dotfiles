zplug "zplug/zplug"

# Command
zplug "peco/peco", \
	as:command, \
	from:gh-r

zplug "b4b4r07/peco-tmux.sh", \
	as:command, \
	on:"peco/peco", \
	use:"peco-tmux.sh", \
	rename-to:"peco-tmux"

zplug "junegunn/fzf-bin", \
	as:command, \
	from:gh-r, \
	rename-to:fzf

zplug "junegunn/fzf", \
	as:command, \
	on:"junegunn/fzf-bin", \
	use:"bin/fzf-tmux"

zplug "monochromegane/the_platinum_searcher", \
	as:command, \
	from:gh-r, \
	on:"junegunn/fzf-bin", \
	rename-to:pt

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
	on:"junegunn/fzf-bin", \
	use:"bin/gomi"

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
