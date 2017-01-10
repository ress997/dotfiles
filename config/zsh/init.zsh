# fpath
typeset -gx -U fpath FPATH
fpath=( \
	$HOME/.zsh/completion(N-/) \
	/usr/local/share/zsh/site-functions(N-/)
	$fpath \
)

# autoload
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz compinit && compinit -C
autoload -Uz is-at-least
autoload -Uz run-help

# Language
export LANGUAGE="ja_JP.UTF-8"
export LANG=$LANGUAGE

# Editor
export EDITOR=nvim
export GIT_EDITOR=$EDITOR

# Pager
export PAGER='less'

# Less
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS の 色の設定？
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'       # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[00;44;37m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[01;32m'       # begin underline

# Ls
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LSCOLORS=exfxcxdxbxegedabagacad

# History
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=1000000000

# dotfile を コマンドの候補として出さない？
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# 単語の一部とみなしたい非アルファベット文字
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# ---

# Dev
export DEV_DATA_HOME="$HOME/.dev"
export DEV_PROGRAM_HOME="$HOME/.opt"
export DOTPATH=$DEV_DATA_HOME/dotfiles

# golamg
export GOPATH="$DEV_DATA_HOME/go"
export GOBIN="$GOPATH/bin"

# Nodebrew
export NODEBREW_ROOT="$DEV_PROGRAM_HOME/nodebrew"

# rbnev
# export RBENV_ROOT="$DEV_PROGRAM_HOME/rbenv"
export RBENV_ROOT="/usr/local/var/rbenv"

# zplug
export ZPLUG_REPOS="$DEV_PROGRAM_HOME/zplug/src"
export ZPLUG_HOME="$ZPLUG_REPOS/zplug/zplug"

# ---

# PATH
typeset -U path PATH
path=( \
	$HOME/.local/bin
	$GOBIN(N-/) \
	$ZPLUG_HOME/bin \
	$NODEBREW_ROOT/current/bin(N-/) \
	/usr/local/bin(N-/) \
	$path \
)

[ -f $DEV_DATA_HOME/secret/env ] && source $DEV_DATA_HOME/secret/env
