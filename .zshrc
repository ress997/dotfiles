umask 022
limit coredumpsize 0
zmodload zsh/files

typeset -gx -U fpath FPATH
fpath=(
	/usr/local/share/zsh/site-functions(N-/)
	/usr/share/zsh/site-functions(N-/)
	$fpath
)

autoload -Uz colors && colors
autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zcompdump
autoload -Uz zmv

# Homebrew
if (( $+commands[brew] )); then
	# Analytics: off
	export HOMEBREW_NO_ANALYTICS=1

	# upgrade: 実行時 cleanup
	export HOMEBREW_UPGRADE_CLEANUP=1
fi

# Editor
export EDITOR='nvim'
export GIT_EDITOR=$EDITOR

# ls color
export LS_COLORS='di=32:ln=36:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# --- history ---
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

# --- key ---
bindkey -v

# edit command line {{{
# <C-x>e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^xe' edit-command-line
bindkey -M vicmd '^xe' edit-command-line
# }}}

# quote previous word in single or double quote {{{
# <ESC>s: 前の単語を ' で囲む {{{
autoload -Uz modify-current-argument
_quote-previous-word-in-single() {
	modify-current-argument '${(qq)${(Q)ARG}}'
	zle vi-forward-blank-word
}
# }}}
# <ESC>d: 前の単語を " で囲む {{{
zle -N _quote-previous-word-in-single
bindkey '^[s' _quote-previous-word-in-single

_quote-previous-word-in-double() {
	modify-current-argument '${(qqq)${(Q)ARG}}'
	zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[d' _quote-previous-word-in-double
# }}}
# }}}

# <C-]>: 一つ前のコマンドの最後の単語を挿入 {{{
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
	'*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey '^]' insert-last-word
# }}}

# iab {{{

typeset -g -A _abbreviations=()

# Global Alias
_abbreviations+=(
	"P" "| $PAGER"
	"C" "| wc -l"
)

## Copy to clipboard
if (( $+commands[wl-copy] )); then
	_abbreviations+=("CP" "| wl-copy")
elif (( $+commands[xclip] )); then
	_abbreviations+=("CP" "| xclip -in -selection clipboard")
elif (( $+commands[xsel] )); then
	_abbreviations+=("CP" "| xsel --input --clipboard")
elif (( $+commands[pbcopy] )); then
	_abbreviations+=("CP" "| pbcopy")
fi

# Editor
_abbreviations+=("e" "$EDITOR")
if [[ "$EDITOR" == "nvim" ]]; then
	_abbreviations+=(
	"vi" "nvim"
	"vim" "nvim"
	)
fi

# Package Manager
## Homebrew
if (( $+commands[brew] )); then
_abbreviations+=(
	"bc" "brew cleanup"
	"bd" "brew doctor"
	"bi" "brew install"
	"bl" "brew list"
	"bs" "brew search"
	"bug" "brew upgrade"
	"bup" "brew update"
	# 依存パッケージ 確認用
	"bdt" "brew deps --tree --installed"
	"bll" "brew leaves"
)
fi

# Git
if (( $+commands[git] )); then
_abbreviations+=(
	"ga"  "git add"
	"gb" "git branch"
	"gap" "git add -p"
	"gcm" "git commit"
	"gco" "git checkout"
	"gcob" "git checkout -b"
	"gcobdm" "git checkout -b develop master"
	"gcobp" "git checkout -b patch"
	"gd" "git diff"
	"gf" "git fetch"
	"gfu" "git fetch upstream"
	"gp" "git push"
	"gpd" "git push dev"
	"gpo" "git push origin"
	"gpom" "git push origin master"
	"gr" "git remote"
	"gra" "git remote add"
	"grad" "git remote add dev"
	"grau" "git remote add upstream"
	"gs" "git status"
	"gst" "git status --short --branch"
)

	if (( $+commands[git-br] )); then
		_abbreviations+=("gbr" "git br")
	fi

	if (( $+commands[ghq] )); then
		_abbreviations+=(
		"gg" "ghq get"
		"gl" "ghq list"
		)
		if (( $+commands[tree] )); then
			_abbreviations+=("gt" "tree -L 2 ~/.local/src/github.com")
		fi
	fi
fi

# Docker
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
)

	if (( $+commands[docker-compose] )); then
		_abbreviations+=(
		"dcb" "docker-compose build"
		"dcp" "docker-compose ps"
		"dcu" "docker-compose up -d"
		)
	fi
fi

# Miss
_abbreviations+=(
	"sk" "ssh-keygen -t ed25519 -C '$(git config --get user.email)'"
	"q" "exit"
	# LS
	"la" "ls -A"
	"ll" "ls -l"
	"lla" "ls -lA"
)

# iab setup
setopt extended_glob

__iab::magic-abbrev-expand() {
	local MATCH

	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${_abbreviations[$MATCH]:-$MATCH}

	zle self-insert
}
zle -N __iab::magic-abbrev-expand
bindkey -M viins " " __iab::magic-abbrev-expand

__iab::no-magic-abbrev-expand() {
	LBUFFER+=' '
}
zle -N __iab::no-magic-abbrev-expand
bindkey -M viins "^x " __iab::no-magic-abbrev-expand
# }}}
# --- alias ---

alias ls='ls -F --color=auto'

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

alias rename='noglob zmv -W'

alias q='exit'

## suffix alias
if (( $+commands[unar] )); then
	alias -s {gz,zip,7z}='unar'
fi

# --- complete ---
# TODO: 整理

## 単語の区切りを調整
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

## キャッシュを使う
zstyle ':completion:*' use-cache true

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
if [[ -n $LS_COLORS ]]; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

### kill 候補を色付け
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

## スペルミス修正
setopt correct
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# --- misc ---
# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# --- functions ---

available() {
	local x candidates
	candidates="$1:"
	while [ -n "$candidates" ]; do
		x=${candidates%%:*}
		candidates=${candidates#*:}
		if type "$x" >/dev/null 2>&1; then
			echo "$x"
			return 0
		else
			continue
		fi
	done
	return 1
}

showopt() {
	set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}

g() {
	local repo=$(ghq list --full-path|$(available fzy fzf peco))
	[[ -n "$repo" ]] && cd "$repo"
}

# ------

path=(
	~/.local/bin
	~/.yarn/bin(N-/)
	$path
)

# --- plugin ---
plugin() {
	local dir="$HOME/.local/src"
	local repo="$1"
	local file="$2"

	p="$dir/$repo/$file"
	[[ -f $p ]] && source $p
}

plugin "github.com/ress997/zsh-ayame" ayame.zsh-theme

export ENHANCD_DIR="${XDG_DATA_HOME}/enhancd"
ENHANCD_DISABLE_HOME=1
ENHANCD_DOT_SHOW_FULLPATH=1
ENHANCD_USE_FUZZY_MATCH=0
plugin "github.com/b4b4r07/enhancd" init.sh

plugin "github.com/zsh-users/zsh-history-substring-search" zsh-history-substring-search.zsh
plugin "github.com/zdharma/history-search-multi-word" history-search-multi-word.plugin.zsh
plugin "github.com/zdharma/fast-syntax-highlighting" fast-syntax-highlighting.plugin.zsh

# ------

if [[ "~/.zshrc" -nt "~/.zshrc.zwc" || ! -f "~/.zshrc.zwc"  ]]; then
	zcompile ~/.zshrc
fi
