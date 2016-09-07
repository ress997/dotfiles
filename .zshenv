# fpath
typeset -gx -U fpath FPATH
fpath=( \
	$HOME/.zsh/completion(N-/) \
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

# XDG Base Directory Specification
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Dev
export DEV_DATA_HOME="$HOME/.dev"
export DOTPATH=$DEV_DATA_HOME/dotfiles
export FILTER='fzf-tmux:fzf:peco-tmux:peco'

# ---

# AWS CLI
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_CREDENTIAL_FILE="$DEV_DATA_HOME/secret/aws"

# enhancd
export ENHANCD_DIR="$XDG_DATA_HOME/enhancd"

# FZF
export FZF_DEFAULT_OPTS="--extended --ansi --multi"

# GitHub
export GITHUB_USER=$(git config --get github.user)

# golamg
export GOPATH="$DEV_DATA_HOME/go"

# Gomi
export GOMI_DIR="$XDG_CACHE_HOME/gomi"

# Hub
export HUB_CONFIG="$XDG_CONFIG_HOME/hub/config"

# Tig
export TIGRC_USER="$XDG_CONFIG_HOME/tig/config"

# ---

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
export HISTSIZE=1000
export SAVEHIST=10000000

# dotfile を コマンドの候補として出さない？
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# 単語の一部とみなしたい非アルファベット文字
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# PATH
typeset -U path PATH
path=( \
	$HOME/.local/bin(N-/)
	$HOME/bin(N-/) \
	$GOPATH/bin(N-/) \
	/usr/local/bin(N-/) \
	$path \
)

[ -f $DEV_DATA_HOME/secret/env ] && source $DEV_DATA_HOME/secret/env
