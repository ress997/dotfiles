umask 022
bindkey -d
limit coredumpsize 0

# AWS CLI
if (( $+commands[aws] )); then
	export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
	export AWS_CREDENTIAL_FILE="$XDG_CONFIG_HOME/aws/credentials"
fi

# enhancd
export ENHANCD_DIR="$XDG_DATA_HOME/enhancd"

# Homebrew
if (( $+commands[brew] )); then
	export HOMEBREW_NO_ANALYTICS=1
fi

# Tig
if (( $+commands[tig] )); then
	export TIGRC_USER="$XDG_CONFIG_HOME/tig/config"
fi

# nodebrew
[[ -d $NODEBREW_ROOT ]] || curl -L git.io/nodebrew | perl - setup

# npm
if (( $+commands[npm] )); then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
	export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
	export NOM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
fi

# rbenv
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

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
		echo
	fi
fi
# }}}
# zplug {{{
export ZPLUG_THREADS='32'
export ZPLUG_CONFIG_DIR="$XDG_CONFIG_HOME/zplug"
export ZPLUG_LOADFILE="$ZPLUG_CONFIG_DIR/packages.zsh"
export ZPLUG_CACHE_DIR="$XDG_CACHE_HOME/zplug"

[[ -d $ZPLUG_HOME ]] || curl -sL zplug.sh/installer | zsh

if [[ -d $ZPLUG_HOME ]]; then
	source $ZPLUG_HOME/init.zsh
	zplug check || zplug install
	zplug load --verbose
fi
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
