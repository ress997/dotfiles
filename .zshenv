# fpath
typeset -gx -U fpath
fpath=( \
  $HOME/.zsh/completion(N-/) \
  /usr/local/share/zsh-completions(N-/) \
  /usr/local/share/zsh/functions(N-/) \
  $fpath \
  )

# autoload
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz compinit && compinit -u
autoload -Uz is-at-least
autoload -Uz run-help

# XDG Base Directory Specification
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Dev
export DEV_DATA_HOME="$HOME/.dev"

# Filter
export FILTER='fzf-tmux:fzf:peco'

# anyenv
export ANYENV_HOME="$HOME/.anyenv"

# emoji-cli
export EMOJI_CLI_FILTER=$FILTER

# enhancd
export ENHANCD_DIR="$XDG_DATA_HOME/enhancd"
export ENHANCD_FILTER=$FILTER

# fzf
export FZF_DEFAULT_OPTS="--extended --ansi --multi --exit-0 --select-1"

# golamg
export GOPATH="$DEV_DATA_HOME/go"

# zplug
export ZPLUG_CACHE_FILE="$XDG_CACHE_HOME/zplug"
export ZPLUG_FILTER=$FILTER
export ZPLUG_HOME="$DEV_DATA_HOME/zplug"

# Language
export LANGUAGE="ja_JP.UTF-8"
export LANG=$LANGUAGE
export LESSCHARSET='utf-8'

# Editor
export EDITOR=nvim
export GIT_EDITOR=$EDITOR

# Pager
export PAGER='less'
# status line
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'

# LESS の 色の設定？
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'       # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[00;44;37m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[01;32m'       # begin underline

# lsした時のカラー
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# PATH
typeset -U path PATH
path=( \
  $HOME/bin(N-/) \
  $GOPATH/bin(N-/) \
  $ANYENV_HOME/bin(N-/) \
  /usr/local/bin(N-/) \
  $path \
  )

# History
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HISTSIZE=1000000
export SAVEHIST=1000000
export LISTMAX=50
# Do not add in root
if [[ $UID == 0 ]]; then
  unset HISTFILE
  export SAVEHIST=0
fi

# dotfile を コマンドの候補として出さない？
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# 単語の一部とみなしたい非アルファベット文字
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

[ -f $HOME/.secret ] && source $HOME/.secret
