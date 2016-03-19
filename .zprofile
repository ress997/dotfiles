is_exists() {
    type "$1" >/dev/null 2>&1
    return $?
}

# hub
if is_exists hub; then
    git() {
        hub "$@"
    }
fi

# ghq
if is_exists ghq; then
    g() {
        cd $(ghq root)/$(ghq list | $(available $FILTER))
    }
    gh() {
        hub browse $(ghq list | $(available $FILTER) | cut -d "/" -f 2,3)
    }
    ghq-update() {
        ghq list | sed 's|.[^/]*/||' | xargs -n 1 -P 10 ghq get -u
    }
fi

# http://qiita.com/ress997/items/1c3fdce27ac60fb66b4e
update () {
    local command
    for command in $1; do
        if has $command; then
            if has $command'-update'; then
                $command'-update'
            else
                $command update
            fi
        else
            echo "Error: $command update"
        fi
    done
}

# mkdirとcdを同時実行
mkcd() {
    if [[ -d $1 ]]; then
        echo "$1 already exists!"
        cd $1
    else
        mkdir -p $1 && cd $1
    fi
}

open_browser() {
    if has open; then
        open $1
    else
        echo "open: not found" 1>&2
        exit 1
    fi
}
wiki() {
    if [ -n "$1" ]; then
        local URL="http://ja.wikipedia.org/wiki/$1"
        open_browser $URL
    else
        echo "usage: $0 word"
    fi
}
google() {
    if [ -n "$1" ]; then
        local URL="https://www.google.co.jp/search?hl=ja&ie=utf-8&oe=utf-8&q=$1"
        open_browser $URL
    else
        echo "usage: $0 word"
    fi
}
qiita() {
    if [ -n "$1" ]; then
        local URL="http://qiita.com/search?utf8=%E2%9C%93&sort=rel&q=$1"
        open_browser $URL
    else
        echo "usage: $0 word"
    fi
}
