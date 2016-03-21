umask 022
bindkey -d
limit coredumpsize 0

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# TMUX Auto new-session {{{
has() {
    type "$1" >/dev/null 2>&1
    return $?
}
is_osx() {
    [[ $OSTYPE == darwin* ]]
}
is_screen_running() {
    [ ! -z "$STY" ]
}
is_tmux_runnning() {
    [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
    [ ! -z "$PS1" ]
}
is_ssh_running() {
    [ ! -z "$SSH_CONECTION" ]
}
tmux_automatically_attach_session() {
    if is_screen_or_tmux_running; then
        ! has 'tmux' && return 1
        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! has 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi
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
            if is_osx && has 'reattach-to-user-namespace'; then
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session
# }}}
# zplug {{{
[[ -d $ZPLUG_HOME ]] || {
    curl -fLo $ZPLUG_HOME/zplug --create-dirs git.io/zplug
    source $ZPLUG_HOME/zplug && zplug update --self
}
source $ZPLUG_HOME/zplug

# Command
zplug "b4b4r07/zsh-gomi", as:command, of:bin/gomi
zplug "junegunn/fzf", as:command, of:bin/fzf-tmux
zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf
zplug "mrowa44/emojify", as:command
zplug "peco/peco", as:command, from:gh-r, of:"*amd64*"
zplug "stedolan/jq", as:command, from:gh-r

# 実験
zplug "motemen/ghq", as:command, from:gh-r, of:"*${(L)$(uname -s)}*amd64*" # => なぜか失敗する
# zplug "motemen/ghq", as:command, if:"type go", do:"make build", of:ghq # => ちゃんとビルドすると成功する

# zplug "github/hub", as:command, from:gh-r
# zplug "mattn/jvgrep", as:command, from:gh-r # => highwayの方をなるべく使いたい
# zplug "tkengo/highway", as:command, do:"./tools/build.sh", of:hw # => 必要な物さえあれば成功

# Plugin
zplug "b4b4r07/emoji-cli"
zplug "b4b4r07/enhancd", of:enhancd.sh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", nice:19

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose
# }}}
# anyenv
[[ -d $ANYENV_HOME ]] || {
    git clone https://github.com/riywo/anyenv $ANYENV_HOME
    mkdir -p $ANYENV_HOME/plugins
    # anyenv-update
    git clone https://github.com/znz/anyenv-update.git $ANYENV_HOME/plugins/anyenv-update
}
[ -x $ANYENV_HOME/bin/anyenv ] && eval "$($ANYENV_HOME/bin/anyenv init -)"

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

# keybinds {{{
bindkey -v

## Ctrl-R
_fzf-select-history() {
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
zle -N _fzf-select-history
bindkey '^r' _fzf-select-history

# }}}
# aliases {{{
alias ls='ls -G'
alias la='ls -AF'
alias lc='ls -ltcr'     # Sort by and show change time, most recent last
alias lk='ls -lSr'      # Sort by size, biggest last
alias ll='ls -lF'
alias lla='ls -lAF'
alias lt='ls -ltr'      # Sort by date, most recent last
alias lu='ls -ltur'     # Sort by and show access time, most recent last

alias rm='rm -i'
alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
alias zmv='noglob zmv -W'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Homebrew
if has brew; then
    alias b='brew'
    alias bl='brew list'
    alias bd='brew doctor'
    alias bup='brew update'
fi

# NeoVim
if has nvim; then
    alias n='nvim'
    alias vi='nvim'
    alias vim='nvim'
fi

# Global Alias
alias -g L='| less'
alias -g G='| grep'

if has "emojify"; then
    alias -g E='| emojify'
fi

if is_osx; then
    alias -g CP='| pbcopy'
fi

# }}}
# autoload {{{

# zmv - 複数ファイルのmv
autoload -Uz zmv

# TODO : 後で機能を調べる
autoload -Uz modify-current-argument
autoload -Uz smart-insert-last-word
autoload -Uz terminfo
autoload -Uz zcalc

# }}}
# setopt {{{

# ヒストリ
setopt hist_ignore_all_dups     # 同じコマンドをヒストリに残さない
setopt hist_ignore_space        # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks       # ヒストリに保存するときに余分なスペースを削除する
setopt share_history            # 同時に起動したzshの間でヒストリを共有する

# 無効
setopt no_beep              # beep を無効にする
setopt no_flow_control      # フローコントロールを無効にする

# 未整理
setopt always_last_prompt       # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt auto_menu                # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys          # カッコの対応などを自動的に補完
setopt auto_param_slash         # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_list                # 補完候補を一覧で表示する
setopt complete_in_word         # 語の途中でもカーソル位置で補完
setopt extended_glob            # 高機能なワイルドカード展開を使用する
setopt globdots                 # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt ignore_eof               # Ctrl+Dでzshを終了しない
setopt interactive_comments     # コマンドラインでも # 以降をコメントと見なす
setopt list_types               # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt magic_equal_subst        # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt mark_dirs                # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt prompt_subst             # プロンプトが表示されるたびにプロンプト文字列を評価、置換する

# その他
setopt auto_cd
setopt auto_pushd               # cd したら自動的にpushdする
setopt pushd_ignore_dups        # 重複したディレクトリを追加しない
setopt pushd_to_home
setopt correct                  # 補完機能
setopt correct_all
setopt brace_ccl                # Deploy {a-c} -> a b c
setopt print_eight_bit          # 日本語ファイル名を表示可能にする
setopt equals                   # Expand '=command' as path of command. e.g.) '=ls' -> '/bin/ls's

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

# kill 候補を色付け
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# 補完候補をカーソルで選ぶ。
zstyle ':completion:*:default' menu select=1

# 補完時にこれらのディレクトリは除外する。
zstyle ':completion:*:cd:*' ignored-patterns '*CVS|*.git|*lost+found'

# 補完メッセージを読みやすくする
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# }}}
# PROMPT {{{

PROMPT='[%n@%m] [%F{cyan}%~%f]
[%#]-> '
PROMPT2='[%#]-> '
SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"
# RPROMPT="[%F{cyan}%~%f]"

# }}}
# vcs_info {{{

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# 以下の3つのメッセージをエクスポートする
# - $vcs_info_msg_0_ : 通常メッセージ用 (緑)
# - $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
# - $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

# フォーマット
zstyle ':vcs_info:git:*' formats '[%b]' '%c%u %m'
zstyle ':vcs_info:git:*' actionformats '[%b]' '%c%u %m' '<!%a>'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列


# formats '[%b]' '%c%u %m' , actionformats '[%b]' '%c%u %m' '<!%a>' のメッセージを設定する直前のフック関数今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので各関数が最大3回呼び出される。
zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-untracked git-push-status git-nomerge-branch git-stash-count

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
        # master ブランチでない場合は何もしない
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

# マージしていない件数表示
# master 以外のブランチにいる場合に、現在のブランチ上でまだ master にマージしていないコミットの件数を (mN) という形式で misc (%m) に表示
+vi-git-nomerge-branch() {
    # zstyle formats, actionformats の2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
        return 0
    fi

    if [[ "${hook_com[branch]}" == "master" ]]; then
        # master ブランチの場合は何もしない
        return 0
    fi

    local nomerged
    nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$nomerged" -gt 0 ]] ; then
        # misc (%m) に追加
        hook_com[misc]+="(m${nomerged})"
    fi
}

# stash 件数表示
# stash している場合は :SN という形式で misc (%m) に表示
+vi-git-stash-count() {
    # zstyle formats, actionformats の2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
        return 0
    fi

    local stash
    stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [[ "${stash}" -gt 0 ]]; then
        # misc (%m) に追加
        hook_com[misc]+=":S${stash}"
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

# }}}
