augroup MyAutoCmd
	autocmd!
augroup END

let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let s:dein_cache_dir = $HOME . '/.vim' . '/dein'
if &runtimepath !~# '/dein.vim'
	let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
	endif
	execute 'set runtimepath^=' . s:dein_repo_dir
endif
if dein#load_state(s:dein_cache_dir)
	call dein#begin(s:dein_cache_dir)
	let s:toml_dir = g:config_home . '/dein'
	let s:toml_list = [s:toml_dir . '/plugins.toml', s:toml_dir . '/lang.toml']
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
syntax enable
colorscheme hybrid

scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
set fileformat=unix
set fileformats=unix,dos,mac

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
