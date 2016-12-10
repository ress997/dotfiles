zplug "zplug/zplug"

zplug "$XDG_CONFIG_HOME/zsh", \
	from:local, \
	defer:1, \
	use:"<->_*.zsh"

zplug "$XDG_CONFIG_HOME/zsh/functions", \
	from:local, \
	defer:1, \
	use:"*.zsh"

# Theme

zplug "$XDG_CONFIG_HOME/zsh/prompt", \
	from:local, \
	as:theme

# Command

zplug "monochromegane/the_platinum_searcher", \
	from:gh-r, \
	as:command, \
	rename-to:pt

zplug "BurntSushi/ripgrep", \
	from:gh-r, \
	as:command, \
	rename-to:rg

zplug "peco/peco", \
	from:gh-r, \
	as:command

zplug "b4b4r07/peco-tmux.sh", \
	as:command, \
	on:"peco/peco", \
	use:"peco-tmux.sh", \
	rename-to:"peco-tmux"

zplug "junegunn/fzf-bin", \
	from:gh-r, \
	as:command, \
	rename-to:fzf, \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/fzf.zsh"

zplug "junegunn/fzf", \
	as:command, \
	on:"junegunn/fzf-bin", \
	use:"bin/fzf-tmux"

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

zplug "arukasio/cli", \
	from:gh-r, \
	as:command, \
	rename-to:arukas

zplug "Code-Hex/pget", \
	from:gh-r, \
	as:command

zplug "b4b4r07/httpstat", \
	as:command, \
	use:"httpstat.sh", \
	rename-to:httpstat

zplug "39e/go-notify", \
	as:command, \
	if:"(( $+commands[go] ))", \
	hook-build:"go build", \
	use:"go-notify", \
	rename-to:"line"

zplug "Code-Hex/battery", \
	from:gh-r, \
	as:command

zplug "minodisk/qiitactl", \
	from:gh-r, \
	as:command

zplug "denysdovhan/gitio-zsh", \
	use:"gitio.zsh"

zplug "andrewbonnington/vox.plugin.zsh"

zplug "ssh0/dot", \
	use:"*.sh", \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/dot.zsh"

zplug "39e/c125d28ac6a70850e896968551a5ad81",\
	from:gist, \
	as:command, \
	use:"diff-highlight"

# 拡張

zplug "b4b4r07/emoji-cli", \
	on:"stedolan/jq"

zplug "b4b4r07/enhancd", \
	use:"init.sh", \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/enhancd.zsh"

zplug "39e/zsh-completions"

zplug "momo-lab/zsh-abbrev-alias", \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/abbrev-alias.zsh"

zplug "hlissner/zsh-autopair", \
	defer:2, \
	use:"autopair.zsh"

zplug "zsh-users/zsh-syntax-highlighting", \
	defer:2

# vim:ft=zplug:
