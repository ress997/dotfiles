# printf "protocol=https\nhost=github.com\n" | git credential-$(git config --get credential.helper) get | awk 'BEGIN { FS = "=" }; $1 ~ /password/ { print $2 }'
export GITHUB_TOKEN=""
export HOMEBREW_GITHUB_API_TOKEN=$GITHUB_TOKEN
