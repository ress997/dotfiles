umask 022
bindkey -d
limit coredumpsize 0

# TMUX Auto new-session
has() {
  type "$1" >/dev/null 2>&1
  return $?
}

is_osx() { [[ $OSTYPE == darwin* ]]; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_runnning() { [ ! -z "$TMUX" ]; }
is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
shell_has_started_interactively() { [ ! -z "$PS1" ]; }
is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

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

# zplug
[[ -d $ZPLUG_HOME ]] || {
  curl -fLo $ZPLUG_HOME/zplug --create-dirs git.io/zplug
  source $ZPLUG_HOME/zplug && zplug update --self
}
source $ZPLUG_HOME/zplug

# Command
zplug "junegunn/fzf", as:command, of:bin/fzf-tmux
zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf
zplug "mrowa44/emojify", as:command
zplug "peco/peco", as:command, from:gh-r, of:"*amd64*"
zplug "stedolan/jq", from:gh-r, as:command

# Plugin
zplug "b4b4r07/emoji-cli"
zplug "b4b4r07/enhancd", of:enhancd.sh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", do:"__zsh_version 4.3"
zplug "zsh-users/zsh-syntax-highlighting", nice:10

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load --verbose

# anyenv
[[ -d $ANYENV_HOME ]] || {
	git clone https://github.com/riywo/anyenv $ANYENV_HOME
	mkdir -p $ANYENV_HOME/plugins
	# anyenv-update
	git clone https://github.com/znz/anyenv-update.git $ANYENV_HOME/plugins/anyenv-update
}
eval "$(anyenv init -)"

# function
available () {
  local x candidates
  candidates="$1:"
  while [ -n "$candidates" ]
  do
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

#  keybinds 
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

# aliases
alias ls='ls -G'
alias la='ls -AF'
alias lc='ls -ltcr'        # Sort by and show change time, most recent last
alias lk='ls -lSr'         # Sort by size, biggest last
alias ll='ls -lF'
alias lla='ls -lAF'
alias lt='ls -ltr'         # Sort by date, most recent last
alias lu='ls -ltur'        # Sort by and show access time, most recent last

alias rm='rm -i'
alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Homebrew
if has brew;then
  alias b='brew'
  alias bl='brew list'
  alias bd='brew doctor'
  alias bup='brew update'
fi

# NeoVim
if has nvim;then
  alias n='nvim'
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

# PROMPT
PROMPT='[%n@%m]${memotxt}
[%#]-> '
PROMPT2='[%#]-> '
RPROMPT='[%F{cyan}%~%f]'
SPROMPT="%{${fg[red]}%}Did you mean?: %R -> %r [nyae]? %{${reset_color}%}"

# setopt
setopt auto_cd
setopt auto_pushd             # cd したら自動的にpushdする
setopt pushd_ignore_dups      # 重複したディレクトリを追加しない
setopt pushd_to_home
setopt correct                # 補完機能
setopt correct_all
setopt brace_ccl              # Deploy {a-c} -> a b c
setopt print_eight_bit        # 日本語ファイル名を表示可能にする
setopt no_beep                # beep を無効にする
setopt equals                 # Expand '=command' as path of command. e.g.) '=ls' -> '/bin/ls's
setopt no_flow_control        # フローコントロールを無効にする

setopt always_last_prompt     # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt auto_menu              # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys        # カッコの対応などを自動的に補完
setopt auto_param_slash       # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_list              # 補完候補を一覧で表示する
setopt complete_in_word       # 語の途中でもカーソル位置で補完
setopt extended_glob          # 高機能なワイルドカード展開を使用する
setopt globdots               # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt hist_ignore_all_dups   # 同じコマンドをヒストリに残さない
setopt hist_ignore_space      # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks     # ヒストリに保存するときに余分なスペースを削除する
setopt ignore_eof             # Ctrl+Dでzshを終了しない
setopt interactive_comments   # コマンドラインでも # 以降をコメントと見なす
setopt list_types             # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt magic_equal_subst      # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt mark_dirs              # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt prompt_subst           # プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt share_history          # 同時に起動したzshの間でヒストリを共有する

# zstyle
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
## ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# autoload
autoload -Uz zmv

# Login Message
echo "\nUsername: $USER\nDate: $(date)\nKernel: $(uname -rs)\nShell: zsh $ZSH_VERSION\n"
