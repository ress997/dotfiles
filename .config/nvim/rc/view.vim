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
