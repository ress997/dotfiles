 "-------------------------------------------------------------------------------
 " コマンド       ノーマルモード 挿入モード コマンドラインモード ビジュアルモード
 " map/noremap           @            -              -                  @
 " nmap/nnoremap         @            -              -                  -
 " imap/inoremap         -            @              -                  -
 " cmap/cnoremap         -            -              @                  -
 " vmap/vnoremap         -            -              -                  @
 " map!/noremap!         -            @              @                  -
 "---------------------------------------------------------------------------

" 無効化
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

" ; と : を入れ替え
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

" ウィンドウ移動
nnoremap sp :<C-u>split<CR>     " 水平分割
nnoremap vs :<C-u>vsplit<CR>    " 垂直分割

" TAB Page
nnoremap t <Nop>
nnoremap <silent> tn :<C-u>tabnew<CR>
nnoremap <silent> tN :<C-u>tabnew<CR>:<C-u>tabprev<CR>
nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> to :<C-u>tabonly<CR>

" <Esc><Esc>: ハイライトの切り替え
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch!<CR>

" jj: エスケープ
imap jj <Esc>

" <Y>: 行末までヤンク
nnoremap Y y$

" + と - で数字を変化させる?
nnoremap + <C-a>
nnoremap - <C-x>
