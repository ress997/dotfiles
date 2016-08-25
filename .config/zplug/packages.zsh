zplug "zplug/zplug"

# Command
zplug "monochromegane/the_platinum_searcher", \
	from:gh-r, \
	as:command, \
	rename-to:pt

zplug "junegunn/fzf-bin", \
	from:gh-r, \
	as:command, \
	on:"monochromegane/the_platinum_searcher", \
	rename-to:fzf, \
	hook-load:"export FZF_DEFAULT_OPTS='--extended --ansi --multi'"

zplug "junegunn/fzf", \
	as:command, \
	use:"bin/fzf-tmux", \
	on:"junegunn/fzf-bin"

zplug "stedolan/jq", \
	from:gh-r, \
	as:command

zplug "motemen/ghq", \
	from:gh-r, \
	as:command

zplug "github/hub", \
	from:gh-r, \
	as:command

zplug "mrowa44/emojify", \
	as:command

zplug "b4b4r07/zsh-gomi", \
	as:command, \
	use:"bin/gomi", \
	on:"junegunn/fzf-bin", \
	hook-load:"export GOMI_DIR=$XDG_CACHE_HOME/gomi"

zplug "arukasio/cli", \
	from:gh-r, \
	as:command, \
	rename-to:arukas

zplug "Code-Hex/pget", \
	from:gh-r, \
	as:command

zplug "shinofara/stand", \
	from:gh-r, \
	as:command


# Plugin
zplug "b4b4r07/emoji-cli", \
	on:"stedolan/jq"

zplug "b4b4r07/enhancd", \
	use:"init.sh"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
	nice:15
