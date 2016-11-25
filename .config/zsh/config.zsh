umask 022
bindkey -d
limit coredumpsize 0

if (( $+commands[rbenv] )); then
	eval "$(rbenv init -)"
fi

# ENV {{{

# AWS CLI
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_CREDENTIAL_FILE="$DEV_DATA_HOME/secret/aws"

# Homebrew
if (( $+commands[brew] )); then
	export HOMEBREW_NO_ANALYTICS=1
fi

# enhancd
export ENHANCD_DIR="$XDG_DATA_HOME/enhancd"
export ENHANCD_DISABLE_HOME=1

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS="--extended --ansi --multi"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NOM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"

# Gomi
export GOMI_DIR="$XDG_CACHE_HOME/gomi"

# Hub
export HUB_CONFIG="$XDG_CONFIG_HOME/hub/config.yaml"

# Tig
export TIGRC_USER="$XDG_CONFIG_HOME/tig/config"

# zplug
export ZPLUG_LOADFILE=$XDG_CONFIG_HOME/zplug/packages.zsh
export ZPLUG_CACHE_DIR="$XDG_CACHE_HOME/zplug"
export ZPLUG_CACHE_FILE="$ZPLUG_CACHE_DIR/cache"
export ZPLUG_REPOS="$ZPLUG_CACHE_DIR/repos"
export ZPLUG_FILTER=$FILTER
export ZPLUG_THREADS='32'

# }}}
# Auto Download {{{

# TMP
if (( $+commands[tmux] )) && [ ! -d $XDG_CACHE_HOME/tmux/tpm ]; then
	if (( $+commands[git] )); then
		git clone https://github.com/tmux-plugins/tpm $XDG_CACHE_HOME/tmux/tpm
	fi
	$XDG_CACHE_HOME/tmux/tpm/bin/install_plugins
fi

# nodebrew
[[ -d $NODEBREW_ROOT ]] || curl -L git.io/nodebrew | perl - setup

# zplug
[[ -d $ZPLUG_HOME ]] || curl -sL zplug.sh/installer | zsh

# }}}
# Tmux Auto new-session {{{
if (( $+commands[tmux] )); then
	if [ -z "$TMUX" ]; then
		if [ ! -z "$PS1" ] && [ -z "$SSH_CONECTION" ]; then
			if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
				tmux list-sessions
				echo -n "Tmux: attach? (y/N/num) "
				read
				if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
					tmux attach-session
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
					tmux attach -t "$REPLY"
					if [ $? -eq 0 ]; then
						echo "$(tmux -V) attached session"
						return 0
					fi
				fi
			fi
			if [[ "${(L)$( uname -s )}" == darwin ]] && (( $+commands[reattach-to-user-namespace] )); then
				tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
				tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported macOS"
			else
				tmux new-session && echo "tmux created new session"
			fi
		fi
	else
		echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
		echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
		echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
		echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
		echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
	fi
fi
# }}}
# zplug {{{

if [[ -d $ZPLUG_HOME ]]; then
	source $ZPLUG_HOME/init.zsh
	zplug check || zplug install
	zplug load --verbose
fi

# }}}
# function {{{

# available
available () {
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

# ghq
if (( $+commands[ghq] )); then
	local DIRECTORY
	ghq-browse() {
		DIRECTORY=$(ghq list | $(available $FILTER) | cut -d "/" -f 2,3) && hub browse $DIRECTORY
	}
	ghq-update() {
		ghq list | sed 's|.[^/]*/||' | xargs -n 1 -P 10 ghq get -u
	}
fi

# Concurrency the mkdir and cd
mkcd() {
	if [[ -d $1 ]]; then
		echo "$1 already exists!"
		cd $1
	else
		mkdir -p $1 && cd $1
	fi
}


# Hub
(( $+commands[hub] )) && function git(){hub "$@"}

showoptions() {
	set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}

# }}}
# autoload {{{

# TODO: 後で機能を調べる
autoload -Uz modify-current-argument
autoload -Uz smart-insert-last-word
autoload -Uz terminfo
autoload -Uz zcalc

# }}}
# setopt {{{

# ヒストリ
setopt hist_ignore_all_dups		# 同じコマンドをヒストリに残さない
setopt hist_ignore_space		# スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks		# ヒストリに保存するときに余分なスペースを削除する
setopt share_history			# 同時に起動したzshの間でヒストリを共有する

# 無効
setopt no_beep					# beep を無効にする
setopt no_flow_control			# フローコントロールを無効にする

# 未整理
setopt always_last_prompt		# カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt auto_menu				# 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys			# カッコの対応などを自動的に補完
setopt auto_param_slash			# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_list				# 補完候補を一覧で表示する
setopt complete_in_word			# 語の途中でもカーソル位置で補完
setopt extended_glob			# 高機能なワイルドカード展開を使用する
setopt globdots					# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt ignore_eof				# Ctrl+Dでzshを終了しない
setopt interactive_comments		# コマンドラインでも # 以降をコメントと見なす
setopt list_types				# 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt magic_equal_subst		# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt mark_dirs				# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt prompt_subst				# プロンプトが表示されるたびにプロンプト文字列を評価、置換する

# その他
setopt auto_cd
setopt auto_pushd				# cd したら自動的にpushdする
setopt pushd_ignore_dups		# 重複したディレクトリを追加しない
setopt pushd_to_home
setopt correct					# 補完機能
setopt correct_all
setopt brace_ccl				# Deploy {a-c} -> a b c
setopt print_eight_bit			# 日本語ファイル名を表示可能にする
setopt equals					# Expand '=command' as path of command. e.g.) '=ls' -> '/bin/ls's

# }}}
# zstyle {{{

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# これらのファイルは補完候補にしない。でも rm では候補にする。
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o|*?.d|*?.aux|*?~|*\#'

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# 候補に色付け?
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# kill 候補を色付け
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# 補完候補をカーソルで選ぶ。
zstyle ':completion:*:default' menu select=2

# 補完時にこれらのディレクトリは除外する。
zstyle ':completion:*:cd:*' ignored-patterns '*CVS|*.git|*lost+found'

# 補完メッセージを読みやすくする
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# キャッシュを使う?
zstyle ':completion:*' use-cache true

# 不明 (補完関係)
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'

# }}}
# aliases {{{

alias rm='rm -i'

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

if [[ "${(L)$( uname -s )}" == darwin ]]; then
	alias ls='ls -G -F'
fi

alias la='ls -A'
alias ll='la -l'
alias lla='ls -lA'

# }}}
# 略語展開(iab) {{{
typeset -A abbreviations
abbreviations=(
	# Global Alias
	"CP" "| pbcopy"
	"E" "| emojify"
	"J" "| jq ."
	# Docker
	"d" "docker"
	"da" "docker attach"
	"di" "docker images"
	"dl" "docker ps -l -q"
	"dp" "docker ps"
	"dpa" "docker ps -a"
	"dr" "docker run"
	"drm" "docker rm"
	"drmi" "docker rmi"
	"ds" "docker start"
	"djekyll" "docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll -it -p 80:4000 jekyll/jekyll:pages jekyll serve --watch --force_polling"
	# Git系
	"ga"  "git add"
	"gb" "git branch"
	"gbd" "git branch -d"
	"gcm" "git commit"
	"gcmm" "git commit -m"
	"gco" "git checkout"
	"gcob" "git checkout -b"
	"gcobd" "git checkout -b develop master"
	"gd" "git diff"
	"gp" "git push"
	"gpo" "git push origin"
	"gpom" "git push origin master"
	"gs" "git status"
	"gst" "git status --short --branch"
	"gg" "ghq get"
	"gl" "ghq list"
	"ts" "tig status"
	# Homebrew
	"bc" "brew cleanup"
	"bd" "brew doctor"
	"bi" "brew install"
	"bl" "brew list"
	"bs" "brew search"
	"bu" "brew update"
	"bug" "brew upgrade"
	# エディタ
	"vim" "nvim"
	# miss
	"e" "exit"
	"sk" "ssh-keygen -t ed25519 -C 'email@example.com'"
	"t" "type"
)

magic-abbrev-expand() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	zle self-insert

}

no-magic-abbrev-expand() {
	LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
# }}}
# keybinds {{{
bindkey -v

## Ctrl-R
__fzf-select-history() {
	if true; then
		BUFFER="$(
		history 1 \
		 | sort -k1,1nr \
		 | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' \
		 | $(available "fzf-tmux:fzf") --query "$LBUFFER" )"

		CURSOR=$#BUFFER
		zle reset-prompt
	fi
}
zle -N __fzf-select-history
bindkey '^r' __fzf-select-history
# }}}
# PROMPT {{{

pathshorten() {
    setopt localoptions noksharrays extendedglob
    local MATCH MBEGIN MEND
    local -a match mbegin mend
    "${2:-echo}" "${1//(#m)[^\/]##\//${MATCH/(#b)([^.])*/$match[1]}/}"
}

PROMPT_CHAR="❯"

ON_COLOR="%{$fg[green]%}"
OFF_COLOR="%{$reset_color%}"
ERR_COLOR="%{$fg[red]%}"

__ultimate::prompt::user()
{
    echo "%(!.$ON_COLOR.$OFF_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__ultimate::prompt::job()
{
    echo "%(1j.$ON_COLOR.$OFF_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__ultimate::prompt::status()
{
    echo "%(0?.$ON_COLOR.$ERR_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__ultimate::prompt::path()
{
	local path_color="%{[38;5;244m%}%}"
	local rsc="%{$reset_color%}"
	local sep="$rsc/$path_color"
	local _path_="$(pathshorten "${PWD/$HOME/~}")"
	echo "$path_color$_path_$rsc"
}

PROMPT=""
PROMPT+='%{${fg[cyan]}%}%m%{${reset_color}%}'
PROMPT+=' :: '
PROMPT+='%{${fg[yellow]}%}%n%{${reset_color}%}'
PROMPT+=' :: '
PROMPT+='$(__ultimate::prompt::path)'
PROMPT+="
"
PROMPT+='$(__ultimate::prompt::user)'
PROMPT+='$(__ultimate::prompt::job)'
PROMPT+='$(__ultimate::prompt::status)'
PROMPT+=' '

PROMPT2=""
PROMPT2+='$(__ultimate::prompt::user)'
PROMPT2+='$(__ultimate::prompt::job)'
PROMPT2+='$(__ultimate::prompt::status)'
PROMPT2+=' '

SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"

## vcs_info {{{

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# 以下の3つのメッセージをエクスポートする
# - $vcs_info_msg_0_ : 通常メッセージ用 (緑)
# - $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
# - $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

# フォーマット
zstyle ':vcs_info:git:*' formats '%b' '%c%u %m'
zstyle ':vcs_info:git:*' actionformats '%b' '%c%u %m' '<!%a>'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列


# formats '[%b]' '%c%u %m' , actionformats '[%b]' '%c%u %m' '<!%a>' のメッセージを設定する直前のフック関数
zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-untracked git-push-status

# フックの最初の関数
# git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする (.git ディレクトリ内にいるときは呼び出さない) .git ディレクトリ内では git status --porcelain などがエラーになるため
+vi-git-hook-begin() {
	if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
		# 0以外を返すとそれ以降のフック関数は呼び出されない
		return 1
	fi

	return 0
}

# untracked ファイル表示
# untracked ファイル(バージョン管理されていないファイル)がある場合は unstaged (%u) に ? を表示
+vi-git-untracked() {
	# zstyle formats, actionformats の2番目のメッセージのみ対象にする
	if [[ "$1" != "1" ]]; then
		return 0
	fi

	if command git status --porcelain 2> /dev/null \
		| awk '{print $1}' \
		| command grep -F '??' > /dev/null 2>&1 ; then

		# unstaged (%u) に追加
		hook_com[unstaged]+='?'
	fi
}

# push していないコミットの件数表示
# リモートリポジトリに push していないコミットの件数を pN という形式で misc (%m) に表示する
+vi-git-push-status() {
	# zstyle formats, actionformats の2番目のメッセージのみ対象にする
	if [[ "$1" != "1" ]]; then
		return 0
	fi

	if [[ "${hook_com[branch]}" != "master" ]]; then
		return 0
	fi

	# push していないコミット数を取得する
	local ahead
	ahead=$(command git rev-list origin/master..master 2>/dev/null \
		| wc -l \
		| tr -d ' ')

	if [[ "$ahead" -gt 0 ]]; then
		# misc (%m) に追加
		hook_com[misc]+="(p${ahead})"
	fi
}

_update_vcs_info_msg() {
	local -a messages
	local prompt

	LANG=en_US.UTF-8 vcs_info

	if [[ -z ${vcs_info_msg_0_} ]]; then
		# vcs_info で何も取得していない場合はプロンプトを表示しない
		prompt=""
	else
		# vcs_info で情報を取得した場合 $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ をそれぞれ緑、黄色、赤で表示する
		[[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
		[[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
		[[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

		# 間にスペースを入れて連結する
		prompt="${(j: :)messages}"
	fi

	RPROMPT="$prompt"

}

add-zsh-hook precmd _update_vcs_info_msg

## }}}
# }}}
