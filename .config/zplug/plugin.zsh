zplug 'b4b4r07/zplug'

# Command
zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename_to:fzf
zplug 'junegunn/fzf', as:command, use:'bin/fzf-tmux'
zplug 'peco/peco', as:command, from:gh-r
zplug 'stedolan/jq', as:command, from:gh-r, use:"*osx*", rename_to:jq # 次回修正予定?
zplug 'riywo/anyenv', as:command, use:'libexec/anyenv'
zplug 'znz/anyenv-update', as:command, use:'bin/anyenv-update', on:'riywo/anyenv'
zplug 'motemen/ghq', as:command, from:gh-r
zplug 'github/hub', as:command, from:gh-r
zplug 'mrowa44/emojify', as:command
zplug 'b4b4r07/zsh-gomi', as:command, use:'bin/gomi'
zplug 'monochromegane/the_platinum_searcher', as:command, from:gh-r, rename_to:pt

# Plugin
# zplug 'b4b4r07/emoji-cli', if:'(( $+commands[jq] ))', on:'junegunn/fzf-bin'
zplug 'b4b4r07/emoji-cli', on:'junegunn/fzf-bin'
zplug 'b4b4r07/enhancd', use:enhancd.sh
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting', nice:15
