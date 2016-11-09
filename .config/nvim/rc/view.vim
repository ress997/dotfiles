" 表示設定

" 背景を黒ベースに
set background=dark

" 行番号を表示する
set number

" 2バイト文字をちゃんと描画する
set ambiwidth=double

" メッセージ表示欄を1行確保
set cmdheight=1

" ステータス行を常に表示
set laststatus=2

" タブページを常に表示
set showtabline=2

" 対応する括弧を強調表示
set showmatch
" 対応する括弧の表示する時間
set matchtime=1

" 不可視文字を表示
set list listchars=tab:»-,eol:↲,trail:･,extends:>,precedes:<,nbsp:%

" GUI Colors
if has('termguicolors')
	set termguicolors
endif

" emoji (絵文字は全角とみなす)
if exists('+emo')
	set emoji
endif

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
