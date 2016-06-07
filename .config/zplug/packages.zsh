zplug 'zplug/zplug'

# Command
zplug 'monochromegane/the_platinum_searcher', \
    from:gh-r, \
    as:command, \
    rename-to:pt

zplug 'junegunn/fzf-bin', \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    on:'monochromegane/the_platinum_searcher', \
    hook-load:"export FZF_DEFAULT_OPTS='--extended --ansi --multi'"

zplug 'junegunn/fzf', \
    as:command, \
    use:'bin/fzf-tmux', \
    on:'junegunn/fzf-bin'

zplug 'stedolan/jq', \
    from:gh-r, \
    as:command

zplug 'motemen/ghq', \
    from:gh-r, \
    as:command

zplug 'github/hub', \
    from:gh-r, \
    as:command

zplug 'mrowa44/emojify', \
    as:command, \
    hook-load:"alias -g E='| emojify'"

zplug 'b4b4r07/zsh-gomi', \
    as:command, \
    use:'bin/gomi', \
    on:'junegunn/fzf-bin'

zplug 'arukasio/cli', \
    from:gh-r, \
    as:command, \
    rename-to:arukas

# Plugin
zplug 'b4b4r07/emoji-cli', \
    on:'stedolan/jq', \
    hook-load:"export EMOJI_CLI_FILTER=$FILTER"

zplug 'b4b4r07/enhancd', \
    use:'init.sh', \
    hook-load:"export ENHANCD_FILTER=$FILTER"

zplug 'zsh-users/zsh-completions'

zplug 'zsh-users/zsh-syntax-highlighting', \
    nice:15
