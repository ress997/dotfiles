# Global Alias
abbrev-alias -g CP="| pbcopy"
abbrev-alias -g E="| emojify"
abbrev-alias -g J="| jq ."

# Docker
if (( $+commands[docker] )); then
	abbrev-alias d="docker"
	abbrev-alias da="docker attach"
	abbrev-alias di="docker images"
	abbrev-alias dl="docker ps -l -q"
	abbrev-alias dp="docker ps"
	abbrev-alias dpa="docker ps -a"
	abbrev-alias dr="docker run"
	abbrev-alias drm="docker rm"
	abbrev-alias drmi="docker rmi"
	abbrev-alias ds="docker start"
fi

# Git系
abbrev-alias ga="git add"
abbrev-alias gb="git branch"
abbrev-alias gbd="git branch -d"
abbrev-alias gcm="git commit"
abbrev-alias gcmm="git commit -m"
abbrev-alias gco="git checkout"
abbrev-alias gcob="git checkout -b"
abbrev-alias gcobd="git checkout -b develop master"
abbrev-alias gd="git diff"
abbrev-alias gp="git push"
abbrev-alias gpo="git push origin"
abbrev-alias gpom="git push origin master"
abbrev-alias gs="git status"
abbrev-alias gst="git status --short --branch"
if (( $+commands[ghq] )); then
	abbrev-alias gg="ghq get"
	abbrev-alias gl="ghq list"
fi
if (( $+commands[hub] )); then
	abbrev-alias g="hub"
fi
if (( $+commands[tig] )); then
	abbrev-alias ts="tig status"
fi

# Homebrew
if (( $+commands[brew] )); then
	abbrev-alias bc="brew cleanup"
	abbrev-alias bd="brew doctor"
	abbrev-alias bi="brew install"
	abbrev-alias bl="brew list"
	abbrev-alias bs="brew search"
	abbrev-alias bu="brew update"
	abbrev-alias bug="brew upgrade"
fi

# エディタ
if (( $+commands[nvim] )); then
	abbrev-alias vim="nvim"
fi

# miss
abbrev-alias e="exit"
abbrev-alias sk="ssh-keygen -t ed25519 -C 'email@example.com'"