# vim:ft=zsh:foldmethod=marker:foldlevel=0:
umask 022

typeset -U fpath
fpath=(
	/opt/homebrew/share/zsh/site-functions(N-/)
	/usr/local/share/zsh/site-functions(N-/)
	/usr/share/zsh/site-functions(N-/)
	$fpath
)

autoload -Uz colors && colors
autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zcompdump -C

# ENV {{{
export EDITOR='nvim'
export PAGER='less'

# Less
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSHISTFILE=-

# LS
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# Man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ---

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
path=($CARGO_HOME/bin(N-/) $path)

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GO111MODULE=on
path=($GOPATH/bin(N-/) $path)

# ---

# FZF
if (( $+commands[fzf] )); then
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
	export FZF_DEFAULT_OPTS="--no-sort --exact --cycle --multi --ansi --reverse --border --sync --bind='ctrl-t:toggle,ctrl-k:kill-line,?:toggle-preview,down:preview-down,up:preview-up'"
fi

# GHQ
export GHQ_ROOT="$HOME/.local/src"

# Homebrew
if (( $+commands[brew] )); then
	# Analytics: off
	export HOMEBREW_NO_ANALYTICS=1

	# auto cleanup
	export HOMEBREW_INSTALL_CLEANUP=1
fi

# Nextword
if [[ -d "$XDG_DATA_HOME/nextword/data" ]]; then
	export NEXTWORD_DATA_PATH="$XDG_DATA_HOME/nextword/data"
fi

# ---

path=(~/.local/bin(N-/) $path)
# }}}
# Alias {{{
# LS
if [[ "${(L)$( uname -s )}" == darwin ]]; then
	alias ls='ls -F -G'
else
	alias ls='ls -F --color=auto'
fi
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

# 高機能 mv
autoload -Uz zmv
alias rename='noglob zmv -W'

## Suffix Alias
if (( $+commands[unar] )); then
	alias -s {gz,zip,7z}='unar'
fi
# }}}
# Complete {{{
# TODO: 整理

## 単語の区切りを調整
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

## キャッシュを使う
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zcompdumps"

## compctl を使用しない
zstyle ':completion:*' use-compctl false

## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

## 補完候補をカーソルで選ぶ
zstyle ':completion:*:default' menu select=2

## remove trailing spaces after completion if needed
## 自動補完される余分なカンマなどを適宜削除してスムーズに入力できるようにする
## https://qiita.com/t_uda/items/eb2e6bd25d99f64d78df
setopt auto_param_keys

## ディレクトリ名補完とき / 付与
setopt auto_param_slash

## 補完のときプロンプトの位置を変えない
setopt always_last_prompt

## 語の途中でもカーソル位置で補完
setopt complete_in_word

## コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

## コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

## ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

## 補完メッセージを読みやすくする
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'

## 補完候補を一覧で表示する
setopt auto_list

## 補完候補一覧でファイルの種別を識別マーク表示 (ls -F の記号)
setopt list_types

## 日本語ファイル名を表示可能にする
setopt print_eight_bit

## 補完キー連打で順に補完候補を自動で補完
setopt auto_menu

## 高機能なワイルドカード展開を使用する
setopt extended_glob

## Deploy {a-c} -> a b c
setopt brace_ccl

## Expand '=command' as path of command.
## e.g.) '=ls' -> '/bin/ls's
setopt equals

## 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots

## ignore
### rm を除く設定
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o|*?.d|*?.aux|*?~|*\#'

### cd
zstyle ':completion:*:cd:*' ignored-patterns '*CVS|*.git|*lost+found'

### ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

## color
### 候補のfileに色付け
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

### kill 候補を色付け
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

## スペルミス修正
setopt correct
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'
# }}}
# Functions {{{
showopt() {
	set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}

# Fuzzy {{{
## Editor
# TODO: fzf+bat でプレビューしながらファイルを開く
#e() {}

## GHQ
# TODO: fzf+bat でREADME.mdをプレビューしながらディレクトリを選択
g() {
	local repo=$(ghq list | fzy)
	[[ -n "$repo" ]] && cd $(ghq list --full-path --exact "$repo")
}
# }}}
# Apple Silicon {{{
if [[ "${(L)$( uname -s )}" == darwin ]] && (( $+commands[arch] )); then
	[[ -x /usr/local/bin/brew ]] && alias brew="arch -arch x86_64 /usr/local/bin/brew"
	alias x64='exec arch -arch x86_64 "$SHELL"'
	alias a64='exec arch -arch arm64e "$SHELL"'
	switch-arch() {
		if  [[ "$(uname -m)" == arm64 ]]; then
			arch=x86_64
		elif [[ "$(uname -m)" == x86_64 ]]; then
			arch=arm64e
		fi
		exec arch -arch $arch "$SHELL"
	}
fi
# }}}
# }}}
# History {{{
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=1000000000
if [ $UID = 0 ]; then
	unset HISTFILE
	SAVEHIST=0
fi

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# }}}
# Keybind {{{
bindkey -v

# <C-x>e: edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^xe' edit-command-line
bindkey -M vicmd '^xe' edit-command-line

# <C-]>: 一つ前のコマンドの最後の単語を挿入
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
	'*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word
# }}}
# Abbrev {{{
typeset -g -A _abbreviations=(
	"e" "$EDITOR"
	"q" "exit"
	"sk" "ssh-keygen -t ed25519 -C '$(git config --get user.email)'"
	# git: get branch name
	"B" "\$(git symbolic-ref --short HEAD)"
	# PIPE
	"C" "| wc -l"
	"P" "| $PAGER"
)

## Copy to clipboard
if (( $+commands[wl-copy] )); then
	_abbreviations+=("CP" "| wl-copy")
elif (( $+commands[pbcopy] )); then
	_abbreviations+=("CP" "| pbcopy")
elif (( $+commands[xclip] )); then
	_abbreviations+=("CP" "| xclip -in -selection clipboard")
elif (( $+commands[xsel] )); then
	_abbreviations+=("CP" "| xsel --input --clipboard")
fi

## LS
if (( $+commands[exa] )); then
	_abbreviations+=(
		"la" "exa -a"
		"ll" "exa -l"
		"lla" "exa -la"
		"lg" "exa --git"
	)

	if (( $+commands[tree] - 1 )); then
		_abbreviations+=(
			"tree" "exa --tree --git-ignore"
		)
	fi
else
	_abbreviations+=(
		"la" "ls -A"
		"ll" "ls -l"
		"lla" "ls -lA"
	)
fi
# Package Manager {{{
## Homebrew
if (( $+commands[brew] )); then
_abbreviations+=(
	"pi" "brew install"
	"pl" "brew list"
	"pll" "brew leaves"
	"ps" "brew search"
	"pu" "brew upgrade"
	# misc
	"pc" "brew cleanup"
	"pd" "brew doctor"
	"pdt" "brew deps --tree --installed"
)
fi

## yay
if (( $+commnads[yay] )); then
_abbreviations+=(
	"pi" "yay -S"
	"pl" "comm -23 <(pacman -Qqe|sort) <(pacman -Qqg base-devel|sort)"
	"pll" "comm -23 <(pacman -Qqtt|sort) <(pacman -Qqg base-devel|sort)"
	"ps" "yay -Ss"
	"pu" "yay -Syyu"
	# misc
	"pc" "yay -Yc"
	"pd" "yay -Ps"
)
fi
# }}}
# Git {{{
if (( $+commands[git] )); then
_abbreviations+=(
	"ga"  "git add"
	"gb" "git branch"
	"gap" "git add -p"
	"gcm" "git commit"
	"gco" "git checkout"
	"gcob" "git checkout -b"
	"gcobp" "git checkout -b patch"
	"gd" "git diff"
	"gf" "git fetch"
	"gfu" "git fetch upstream"
	"gp" "git push"
	"gpd" "git push dev"
	"gpo" "git push origin"
	"gr" "git remote"
	"gra" "git remote add"
	"grad" "git remote add dev"
	"grau" "git remote add upstream"
	"gs" "git status"
	"gst" "git status --short --branch"
	# GHQ
	"gg" "ghq get"
	"gl" "ghq list | sort"
	"gt" "exa --tree -L 2 $GHQ_ROOT/github.com"
)
fi
# }}}
# Docker {{{
if (( $+commands[docker] )); then
_abbreviations+=(
	"di" "docker images"
	"dl" "docker ps -l -q"
	"dp" "docker ps"
	"dpa" "docker ps -a"
	"dr" "docker run"
	"drm" "docker rm"
	"drmi" "docker rmi"
	"ds" "docker start"
	"dd" "docker system prune -f"
	# Compose
	"dcb" "docker-compose build"
	"dcp" "docker-compose ps"
	"dcu" "docker-compose up -d"
)
fi
# }}}
setopt extended_glob

__magic-abbrev-expand() {
	local MATCH

	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${_abbreviations[$MATCH]:-$MATCH}

	zle self-insert
}
zle -N __magic-abbrev-expand
bindkey -M viins " " __magic-abbrev-expand

__no-magic-abbrev-expand() {
	LBUFFER+=' '
}
zle -N __no-magic-abbrev-expand
bindkey -M viins "^x " __no-magic-abbrev-expand
# }}}
# Misc {{{
# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# Correctly display UTF-8 with combining characters.
if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
    setopt COMBINING_CHARS
fi

# Disable the log builtin, so we don't conflict with /usr/bin/log
disable log
# }}}
# Plugin {{{
# plugin "repo" "local file" "server (Default: github.com)"
typeset -g -a __plugins=()
typeset -g -a __plugins_file=()
plugin() {
	local repo="$1"
	local file="$2"
	local site="github.com"

	__plugins+=("$repo")

	p="$GHQ_ROOT/$site/$repo/$file"
	[[ -f $p ]] && __plugins_file+=("$p")
}

plugin-update() {
	foreach repo (${__plugins})
		ghq get -u "$repo"
	end

	foreach file (${__plugins_file})
		if [[ "$file" -nt "$file.zwc" || ! -f "$file.zwc"  ]]; then
			zcompile $file
		fi
	end
}

plugin "b4b4r07/enhancd" init.sh
export ENHANCD_DIR="${XDG_CACHE_HOME}/enhancd"
ENHANCD_DISABLE_HOME=1
ENHANCD_DOT_SHOW_FULLPATH=1
ENHANCD_USE_FUZZY_MATCH=0

plugin "zdharma/history-search-multi-word" history-search-multi-word.plugin.zsh

plugin "zdharma/fast-syntax-highlighting" fast-syntax-highlighting.plugin.zsh

foreach file (${__plugins_file})
	source "$file"
end
# }}}
# Prompt {{{
local COLOR_OFF="%{$reset_color%}"
local COLOR_PATH=$'%{\e[38;5;244m%}%}'

local COLOR_0="%{$fg[black]%}"
local COLOR_1="%{$fg[red]%}"
local COLOR_2="%{$fg[green]%}"
local COLOR_3="%{$fg[yellow]%}"
local COLOR_4="%{$fg[blue]%}"
local COLOR_5="%{$fg[magenta]%}"
local COLOR_6="%{$fg[cyan]%}"
local COLOR_7="%{$fg[white]%}"

local PROMPT_CHAR="❯"

# プロンプトで関数を使用できるように
setopt PROMPT_SUBST

PROMPT=$'\n'
PROMPT+='%(0?.${COLOR_2}.${COLOR_1})${PROMPT_CHAR}${COLOR_OFF} '

# Hide old prompt
setopt TRANSIENT_RPROMPT

__pathshorten() {
	setopt localoptions noksharrays extendedglob
	local MATCH MBEGIN MEND
	local -a match mbegin mend
	echo "${1//(#m)[^\/]##\//${MATCH/(#b)([^.])*/$match[1]}/}"
}

RPROMPT=''
RPROMPT+='${COLOR_6}%n${COLOR_OFF}'
RPROMPT+='${COLOR_7}@${COLOR_OFF}'
RPROMPT+='${COLOR_5}%m${COLOR_OFF}'
RPROMPT+='${COLOR_7}:${COLOR_OFF}'
RPROMPT+='${COLOR_PATH}$(__pathshorten "${PWD/$HOME/~}")${COLOR_OFF}'
# }}}

if [[ "~/.zshrc" -nt "~/.zshrc.zwc" || ! -f "~/.zshrc.zwc"  ]]; then
	zcompile ~/.zshrc
fi
