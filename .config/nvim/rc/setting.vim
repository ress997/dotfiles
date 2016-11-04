set encoding=utf-8
scriptencoding utf-8

set fileformat=unix
" 改行コードの自動判別 (左側が優先される)
set fileformats=unix,dos,mac
" 保存時の文字コード
set fileencoding=utf-8
" 読み込み時の文字コードの自動判別 (左側が優先される)
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp

" カーソル {{{

" カーソル位置のカラムの背景色を変える
set cursorcolumn

" カーソル行の背景色を変える
set cursorline

" バックスペースキーの有効化
set backspace=indent,eol,start

" 行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

" カーソルの形状を変える
if exists('$ITERM_SESSION_ID')
	if empty('$TMUX')
		let &t_SI = "\e]50;CursorShape=1\x7"
		let &t_EI = "\e]50;CursorShape=0\x7"
		let &t_SR = "\e]50;CursorShape=2\x7"
	else
		let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
		let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
		let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
	endif
endif

" }}}
" ファイル処理関連 {{{

" 保存されていないファイルがあるときは終了前に保存確認
set confirm

" 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set hidden

" 外部でファイルに変更がされた場合は読みなおす
set autoread

" ファイル保存時にバックアップファイルを作らない
set nobackup

" ファイル編集中にスワップファイルを作らない
set noswapfile

" }}}
" 検索/置換 {{{

" 検索文字列をハイライトする
set hlsearch

" インクリメンタルサーチを行う
set incsearch

" 大文字と小文字を区別しない
set ignorecase

" 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set smartcase

" 最後尾まで検索を終えたら次の検索で先頭に移る
set wrapscan

" 置換の時 g オプションをデフォルトで有効にする
set gdefault

" }}}
" タブ/インデント {{{

" Tabキー押下時のカーソル移動幅
set softtabstop=4

" タブ入力を複数の空白入力に置き換えない
set noexpandtab

" 画面上でタブ文字が占める幅
set tabstop=4

" smartindentでずれる幅
set shiftwidth=4

" 改行時に前の行のインデントを継続する
set autoindent

" 改行時に前の行の構文をチェックし次の行のインデントを増減する
set smartindent

" }}}

" 補完の表示オプション
set completeopt=menu,menuone,noinsert,noselect

" エディタの分割方向を設定する
set splitbelow
set splitright

" 折りたたみ機能
set foldcolumn=4
set foldmethod=marker

" コマンドラインの履歴を10000件保存する
set history=10000

" Clipboard
set clipboard+=unnamedplus
