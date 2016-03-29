" dein settings {{{
if &compatible
    set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

let s:dein_dir = expand('$XDG_CACHE_HOME/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim.git' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let s:toml = '~/.config/dein/plugins.toml'
    let s:lazy_toml = '~/.config/dein/plugins_lazy.toml'

    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
" }}}

if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if has('unix')
    set fileformat=unix
    set fileformats=unix,dos,mac
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
    set termencoding=
endif

" Clipboard
set clipboard+=unnamedplus

" 表示設定
syntax on
filetype plugin indent on
set background=dark
colorscheme hybrid_reverse

set cmdheight=2     " メッセージ表示欄を2行確保
set cursorcolumn    " カーソル位置のカラムの背景色を変える
set cursorline      " カーソル行の背景色を変える
set laststatus=2    " ステータス行を常に表示
set list            " 不可視文字を表示
set number          " 行番号を表示する
set showmatch       " 対応する括弧を強調表示
set matchtime=1     " 対応する括弧の表示する時間

" タブ/インデントの設定
set softtabstop=4   " Tabキー押下時のカーソル移動幅
set expandtab       " タブ入力を複数の空白入力に置き換える
set tabstop=4       " 画面上でタブ文字が占める幅
set shiftwidth=4    " 自動インデントでずれる幅
set autoindent      " 改行時に前の行のインデントを継続する

" 不可視文字の表示記号指定
set list
set listchars=tab:»-,eol:↲,nbsp:%

" 折りたたみ機能
set foldcolumn=4
set foldmethod=marker

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" キーマッピング {{{

inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

" ウィンドウ移動
nnoremap sp :<C-u>split<CR>
nnoremap vs :<C-u>vsplit<CR>

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
