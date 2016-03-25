zplug 'b4b4r07/zplug'

# Command
zplug 'b4b4r07/zsh-gomi', as:command, use:bin/gomi
zplug 'junegunn/fzf', as:command, use:bin/fzf-tmux
zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename_to:fzf
zplug 'mrowa44/emojify', as:command
zplug 'peco/peco', as:command, from:gh-r, use:"*${(L)$(uname -s)}*amd64*"
zplug 'stedolan/jq', as:command, from:gh-r, use:"*osx*", hook-build:'chmod +x ./jq-osx-amd64', rename_to:jq

# 実験
zplug 'motemen/ghq', as:command, from:gh-r, use:"*${(L)$(uname -s)}*amd64*"
zplug 'github/hub', as:command, from:gh-r
# zplug 'riywo/anyenv', as:command, use:libexec/anyenv
# zplug 'znz/anyenv-update', as:command, use:bin/anyenv-update
# zplug 'ggreer/the_silver_searcher', as:command, if:'(( $+commands[aclocal] )) && (( $+commands[autoconf] )) && (( $+commands[autoheader] )) && (( $+commandsautomake ))', hook-build:"./build.sh", use:ag
# zplug 'tkengo/highway', as:command, if:'(( $+commands[pprof] )) && (( $+commands[autoconf] )) && (( $+commands[automake] ))', hook-build:"./tools/build.sh", use:hw

# Plugin
zplug 'b4b4r07/emoji-cli', if:'(( $+commands[jq] ))', on:'junegunn/fzf-bin'
zplug 'b4b4r07/enhancd', use:enhancd.sh
# zplug 'glidenote/hub-zsh-completion', on:'github/hub'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting', nice:15
