" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" dein settings {{{
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
execute 'set runtimepath^=' . s:dein_repo_dir

let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let s:toml = '~/.config/dein/plugins.toml'

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir, [$MYVIMRC, s:toml])
    call dein#load_toml(s:toml)
    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
" }}}
" 設定 {{{

colorscheme hybrid
filetype plugin indent on " ファイル形式の検出
syntax on " 構文ハイライト

if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    " 制御シーケンスの設定
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
    if $TERM_PROGRAM == "iTerm.app"
        let &t_SI = "\e]50;CursorShape=1\x7"    " インサートモード開始時
        let &t_EI = "\e]50;CursorShape=0\x7"    " 挿入または置換モード終了
        let &t_SR = "\e]50;CursorShape=2\x7"    " 置換モードの開始
    endif
endif

if has('unix')
    set fileformat=unix
    set fileformats=unix,dos,mac
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
    set termencoding=
endif

" 表示設定
set background=dark " 背景を黒ベースに
set cmdheight=1     " メッセージ表示欄を1行確保
set cursorcolumn    " カーソル位置のカラムの背景色を変える
set cursorline      " カーソル行の背景色を変える
set laststatus=2    " ステータス行を常に表示
set list            " 不可視文字を表示
set number          " 行番号を表示する
set showmatch       " 対応する括弧を強調表示
set matchtime=1     " 対応する括弧の表示する時間

"" 不可視文字の表示記号指定
set lcs=tab:»-,eol:↲,trail:·,extends:>,precedes:<,nbsp:%

" 折りたたみ機能
set foldcolumn=4
set foldmethod=marker

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" ファイル処理関連の設定
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   " 外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" 検索/置換の設定
set hlsearch   " 検索文字列をハイライトする
set incsearch  " インクリメンタルサーチを行う
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault   " 置換の時 g オプションをデフォルトで有効にする

" タブ/インデントの設定
set softtabstop=4   " Tabキー押下時のカーソル移動幅
set et              " タブ入力を複数の空白入力に置き換えない
set tabstop=4       " 画面上でタブ文字が占める幅
set shiftwidth=4    " 自動インデントでずれる幅
set autoindent      " 改行時に前の行のインデントを継続する

" etc
"" コマンドラインの履歴を10000件保存する
set history=10000

" Clipboard
set clipboard+=unnamedplus

" Help の言語を設定
set helplang=ja,en
" }}}
" キーマッピング {{{

inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

" ウィンドウ移動
nnoremap sp :<C-u>split<CR>     " 水平分割
nnoremap vs :<C-u>vsplit<CR>    " 垂直分割

nnoremap s <Nop>
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L

nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<CR>
nnoremap <silent> tT :<C-u>tabnew<CR>:<C-u>tabprev<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>

cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
cnoremap <C-l> <RIGHT>
cnoremap <C-h> <LEFT>
cnoremap <C-d> <DELETE>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-n> <Up>
inoremap <C-p> <Down>
inoremap <C-m> <CR>

" }}}
