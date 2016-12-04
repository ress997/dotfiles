zplug "zplug/zplug"

zplug "$XDG_CONFIG_HOME/zsh", \
	from:local, \
	nice:1, \
	use:"<->_*.zsh"

# Theme

zplug "$XDG_CONFIG_HOME/zsh/prompt", \
	as:theme, \
	from:local

# Command

zplug "monochromegane/the_platinum_searcher", \
	as:command, \
	from:gh-r, \
	rename-to:pt

zplug "BurntSushi/ripgrep", \
	as:command, \
	from:gh-r, \
	rename-to:rg

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
	rename-to:fzf, \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/fzf.zsh"

zplug "junegunn/fzf", \
	as:command, \
	on:"junegunn/fzf-bin", \
	use:"bin/fzf-tmux"

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

zplug "arukasio/cli", \
	as:command, \
	from:gh-r, \
	rename-to:arukas

zplug "Code-Hex/pget", \
	as:command, \
	from:gh-r

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
	as:command, \
	from:gh-r

zplug "minodisk/qiitactl", \
	as:command, \
	from:gh-r

zplug "denysdovhan/gitio-zsh", \
	use:"gitio.zsh"

zplug "andrewbonnington/vox.plugin.zsh"

zplug "ssh0/dot", \
	use:"*.sh", \
	hook-load:"source $ZPLUG_CONFIG_HOME/plugins/dot.zsh"

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
	nice:10, \
	use:"autopair.zsh"

zplug "zsh-users/zsh-syntax-highlighting", \
	nice:15

# vim:ft=zplug:
