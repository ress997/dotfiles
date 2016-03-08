function wiki() {
  if [ -n "$1" ]; then
    if ! has open; then
      echo "open: not found" 1>&2
      exit 1
    fi
    local URL="http://ja.wikipedia.org/wiki/$1"
    open $URL
  else
    echo "usage: $0 word"
  fi
}
function google() {
  if [ -n "$1" ]; then
    if ! has open; then
      echo "open: not found" 1>&2
      exit 1
    fi
    local URL="https://www.google.co.jp/search?hl=ja&ie=utf-8&oe=utf-8&q=$1"
    open $URL
  else
    echo "usage: $0 word"
  fi
}
function qiita() {
  if [ -n "$1" ]; then
    if ! has open; then
      echo "open: not found" 1>&2
      exit 1
    fi
    local URL="http://qiita.com/search?utf8=%E2%9C%93&sort=rel&q=$1"
    open $URL
  else
    echo "usage: $0 word"
  fi
}

# hub
if which hub >/dev/null 2>&1; then
  function git() {
    hub "$@"
  }
fi

# http://qiita.com/yasuto777/items/f3bd6cffd418f3830b75
function memo() {
  if [ $# -eq 0 ]; then
    unset memotxt
    return
  fi
  for str in $@; do
    memotxt="${memotxt} ${str}"
  done
}

# http://blog.b4b4r07.com/entry/2015/11/08/013526
function mru() {
  local -a f
  f=(
  $HOME/.vim_mru_files(N)
  $HOME/.unite/file_mru(N)
  $XDG_CACHE_HOME/ctrlp/mru/cache.txt(N)
  $HOME/.frill(N)
  )
  if [[ $#f -eq 0 ]]; then
    echo "There is no available MRU Vim plugins" >&2
    return 1
  fi

  local cmd q k res
  local line ok make_dir i arr
  local get_styles styles style
  while : ${make_dir:=0}; ok=("${ok[@]:-dummy_$RANDOM}"); cmd="$(
    cat <$f \
      | while read line; do [ -e "$line" ] && echo "$line"; done \
      | while read line; do [ "$make_dir" -eq 1 ] && echo "${line:h}/" || echo "$line"; done \
      | awk '!a[$0]++' \
      | perl -pe 's/^(\/.*\/)(.*)$/\033[34m$1\033[m$2/' \
      | fzf --ansi --multi --query="$q" \
      --no-sort --exit-0 --prompt="MRU> " \
      --print-query --expect=ctrl-v,ctrl-x,ctrl-l,ctrl-q,ctrl-r,"?"
      )"; do
    q="$(head -1 <<< "$cmd")"
    k="$(head -2 <<< "$cmd" | tail -1)"
    res="$(sed '1,2d;/^$/d' <<< "$cmd")"
    [ -z "$res" ] && continue
    case "$k" in
      "?")
        cat <<HELP > /dev/tty
usage: vim_mru_files
  list up most recently files
keybind:
  ctrl-q  output files and quit
  ctrl-l  less files under the cursor
  ctrl-v  vim files under the cursor
  ctrl-r  change view type
  ctrl-x  remove files (two-step)
HELP
        return 1
        ;;
      ctrl-r)
        if [ $make_dir -eq 1 ]; then
          make_dir=0
        else
          make_dir=1
        fi
        continue
        ;;
      ctrl-l)
        export LESS='-R -f -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
        arr=("${(@f)res}")
        if [[ -d ${arr[1]} ]]; then
          ls -l "${(@f)res}" < /dev/tty | less > /dev/tty
        else
          if has "pygmentize"; then
            get_styles="from pygments.styles import get_all_styles
            styles = list(get_all_styles())
            print('\n'.join(styles))"
            styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )
            style=${${(M)styles:#solarized}:-default}
            export LESSOPEN="| pygmentize -O style=$style -f console256 -g %s"
          fi
          less "${(@f)res}" < /dev/tty > /dev/tty
        fi
        ;;
      ctrl-x)
        if [[ ${(j: :)ok} == ${(j: :)${(@f)res}} ]]; then
          eval '${${${(M)${+commands[gomi]}#1}:+gomi}:-rm} "${(@f)res}" 2>/dev/null'
          ok=()
        else
          ok=("${(@f)res}")
        fi
        ;;
      ctrl-v)
        vim -p "${(@f)res}" < /dev/tty > /dev/tty
        ;;
      ctrl-q)
        echo "$res" < /dev/tty > /dev/tty
        return $status
        ;;
      *)
        echo "${(@f)res}"
        break
        ;;
    esac
  done
}
