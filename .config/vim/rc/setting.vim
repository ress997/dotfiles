" TODO: 見やすいように整理
" 表示設定
set background=dark " 背景を黒ベースに
set cmdheight=1     " メッセージ表示欄を1行確保
set cursorcolumn    " カーソル位置のカラムの背景色を変える
set cursorline      " カーソル行の背景色を変える
set laststatus=2    " ステータス行を常に表示
set list            " 不可視文字を表示
set matchtime=1     " 対応する括弧の表示する時間
set number          " 行番号を表示する
set showmatch       " 対応する括弧を強調表示

" GUI Colors
if has('termguicolors')
	set termguicolors
elseif has('guicolors')
	set guicolors
endif

" 不可視文字の表示記号指定
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
set noexpandtab     " タブ入力を複数の空白入力に置き換えない
set tabstop=4       " 画面上でタブ文字が占める幅
set shiftwidth=4    " 自動インデントでずれる幅

" インデント
" TODO: 詳しく調べる
set autoindent
set smartindent

" コマンドラインの履歴を10000件保存する
set history=10000

" Clipboard
set clipboard+=unnamedplus
