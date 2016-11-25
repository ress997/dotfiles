# TODO: zsh-theme 化したい

PROMPT_CHAR="❯"
ON_COLOR="%{$fg[green]%}"
OFF_COLOR="%{$reset_color%}"
ERR_COLOR="%{$fg[red]%}"

__prompt::user()
{
    echo "%(!.$ON_COLOR.$OFF_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__prompt::job()
{
    echo "%(1j.$ON_COLOR.$OFF_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

__prompt::status()
{
    echo "%(0?.$ON_COLOR.$ERR_COLOR)$PROMPT_CHAR%{$reset_color%}"
}

pathshorten() {
	setopt localoptions noksharrays extendedglob
	local MATCH MBEGIN MEND
	local -a match mbegin mend
	"${2:-echo}" "${1//(#m)[^\/]##\//${MATCH/(#b)([^.])*/$match[1]}/}"
}
__prompt::path()
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
PROMPT+='$(__prompt::path)'
PROMPT+="
"
PROMPT+='$(__prompt::user)'
PROMPT+='$(__prompt::job)'
PROMPT+='$(__prompt::status)'
PROMPT+=' '

PROMPT2=""
PROMPT2+='$(__prompt::user)'
PROMPT2+='$(__prompt::job)'
PROMPT2+='$(__prompt::status)'
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
