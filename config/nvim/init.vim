" 標準のシェルをZSHに変更
set sh=zsh
" True Color 有効化
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
" カラースチームの有効化
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
" <ESC> でterminalモードからコマンドモードに変更
tnoremap <silent> <ESC> <C-\><C-n>

augroup MyAutoCmd
	autocmd!
augroup END

" env
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" dein {{{
let g:dein#install_max_processes = 16
let g:dein#install_message_type = 'none'
let g:dein#enable_name_conversion = 1
let g:dein#enable_notification = 1
let s:dein_cache_dir = g:cache_home . '/dein'

if &runtimepath !~# '/dein.vim'
	let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

	" Auto Download
	if !isdirectory(s:dein_repo_dir)
		call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
	endif

	" dein.vim をプラグインとして読み込む
	execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_cache_dir)
	call dein#begin(s:dein_cache_dir)

	let s:toml_dir = g:config_home . '/dein'
	let s:toml_list = [s:toml_dir . '/plugins.toml', s:toml_dir . '/lang.toml', s:toml_dir . '/neovim.toml']
	if has('mac')
		call add(s:toml_list, s:toml_dir . '/mac.toml')
	endif

	for toml in s:toml_list
		if filereadable(toml)
			call dein#load_toml(toml)
		endif
	endfor

	call dein#end()
	call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
	call dein#install()
endif

filetype plugin indent on
" }}}

colorscheme hybrid

" Load Settings File
function s:load_rc(file)
	let s:rc_dir = g:config_home . '/nvim' . '/rc'
	let s:rc_file = s:rc_dir . '/' . a:file . '.vim'

	if filereadable(s:rc_file)
		execute 'source ' . s:rc_file
	endif
endfunction

call s:load_rc('view')
call s:load_rc('setting')
call s:load_rc('grep')
call s:load_rc('keymap')
call s:load_rc('command')

let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
