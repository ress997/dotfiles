" dein settings {{{
if &compatible
  set nocompatible
endif

let s:dein_dir = expand('$XDG_CACHE_HOME/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

let s:toml = '~/.config/dein/plugins.toml'
let s:lazy_toml = '~/.config/dein/plugins_lazy.toml'

if dein#load_cache([expand('<sfile>', s:toml, s:lazy_toml)])
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#save_cache()
endif

call dein#end()

if dein#check_install()
    call dein#install()
endif
" }}}
" Plugin Seting {{{

if dein#tap('deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
endif

if dein#tap('emmet-vim')
    let g:user_emmet_leader_key='<C-Z>'
    let g:user_emmet_settings = {
        \   'variables': {
        \       'lang': "ja"
        \   },
        \   'indentation': '  '
        \ }
endif

if dein#tap('unite.vim')
    "インサートモードで開始しない
    let g:unite_enable_start_insert = 0
    noremap <C-P> :Unite buffer<CR>
endif

if dein#tap('vimfiler.vim')
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_expand_or_edit)
    " <F!0> で起動
    nnoremap <F10> :VimFiler<ENTER>
    " <C-K><C-B> でIDE風に起動
    noremap <C-K><C-B> :VimFiler -split -simple -winwidth=35 -no-quit<ENTER>
    " Like Textmate icons.
    let g:vimfiler_tree_leaf_icon = ' '
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
    let g:vimfiler_file_icon = '-'
    let g:vimfiler_marked_file_icon = '*'
endif

if dein#tap('lightline.vim')
    let g:lightline = {
    \   'colorscheme': 'wombat',
    \ }
endif

if dein#tap('vim-markdown')
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_math = 1
endif

" }}}

if has('unix')
    set fileformat=unix
    set fileformats=unix,dos,mac
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
    set termencoding=
endif

if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" Clipboard
set clipboard+=unnamedplus

" 表示設定
syntax enable
syntax on
set background=dark
colorscheme hybrid

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
set list listchars=tab:\¦\
set listchars=eol:↲,extends:❯,precedes:❮

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
