" Dein List {{{
" http://koturn.hatenablog.com/entry/2016/09/01/050000
function! s:dein_list() abort
	echomsg '[dein] #: not sourced, X: not installed'
	for pair in items(dein#get())
		echomsg (!isdirectory(pair[1].path) ? 'X'
			\ : pair[1].sourced ? ' '
			\ : '#') pair[0]
	endfor
endfunction
command! DeinList call s:dein_list()
" }}}
