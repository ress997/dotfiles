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

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent> <esc><esc> :<C-u>set nohlsearch!<CR>

" 不明
