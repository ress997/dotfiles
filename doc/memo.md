# Memo

```zsh:/etc/zshenv
unsetopt GLOBAL_RCS
```

```zsh:~/.zlogin
printf "\nTERM:\t${TERM}\nUser:\t${USER}\nGitHub:\t$(git config --get github.user)\nTerm:\t${TERM_PROGRAM} ${TERM_PROGRAM_VERSION}\n\n"
```
