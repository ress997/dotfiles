#!/usr/bin/env zsh

# printf "protocol=https\nhost=github.com\n" | git credential-osxkeychain get | awk 'BEGIN { FS = "=" }; $1 ~ /password/ { print $2 }'
export GITHUB_TOKEN=""
