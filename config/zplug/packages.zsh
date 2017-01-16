zplug "zplug/zplug"

zplug "$XDG_CONFIG_HOME/zsh/functions", \
	from:local, \
	defer:1, \
	use:"*.zsh"

# Theme

zplug "$XDG_CONFIG_HOME/zsh/prompt", \
	from:local, \
	as:theme

# Command

zplug "Code-Hex/battery", \
	from:gh-r, \
	as:command

zplug "39e/c125d28ac6a70850e896968551a5ad81",\
	from:gist, \
	as:command, \
	use:"diff-highlight"

zplug "BurntSushi/ripgrep", \
	from:gh-r, \
	as:command, \
	rename-to:rg

zplug "monochromegane/the_platinum_searcher", \
	from:gh-r, \
	as:command, \
	rename-to:pt

zplug "jhawthorn/fzy", \
	as:command, \
	hook-build:'make', \
	use:fzy

zplug "junegunn/fzf-bin", \
	from:gh-r, \
	as:command, \
	rename-to:fzf, \
	hook-load:"source $ZPLUG_CONFIG_DIR/plugins/fzf.zsh"

zplug "39e/2cd87b179166cfc6000532d854de27b4", \
	from:gist, \
	as:command, \
	on:"junegunn/fzf-bin", \
	use:"fzf-tmux"

zplug "ssh0/dot", \
	use:"*.sh", \
	hook-load:"source $ZPLUG_CONFIG_DIR/plugins/dot.zsh"

zplug "motemen/ghq", \
	from:gh-r, \
	as:command

zplug "github/hub", \
	from:gh-r, \
	as:command

zplug "stedolan/jq", \
	from:gh-r, \
	as:command

zplug "mrowa44/emojify", \
	as:command

# arukas.io
zplug "arukasio/cli", \
	from:gh-r, \
	as:command, \
	rename-to:arukas

# 分割ダウンロード
zplug "Code-Hex/pget", \
	from:gh-r, \
	as:command

zplug "b4b4r07/httpstat", \
	as:command, \
	use:'(*).sh', \
	rename-to:'$1'

# git.io
zplug "denysdovhan/gitio-zsh", \
	use:"gitio.zsh"

# Git - branch
zplug "b4b4r07/git-br", \
	as:command, \
	use:'git-br'

# Git - browse
zplug "rhysd/git-brws", \
	from:gh-r, \
	as:command

# 拡張

zplug "b4b4r07/enhancd", \
	use:"init.sh", \
	hook-load:"source $ZPLUG_CONFIG_DIR/plugins/enhancd.zsh"

zplug "39e/zsh-completions"

zplug "momo-lab/zsh-abbrev-alias", \
	hook-load:"source $ZPLUG_CONFIG_DIR/plugins/abbrev-alias.zsh"

zplug "hlissner/zsh-autopair", \
	defer:2, \
	use:"autopair.zsh"

zplug "zsh-users/zsh-syntax-highlighting", \
	defer:2

# vim:ft=zplug:
