augroup MyAutoCmd
	autocmd!
augroup END

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let s:dein_dir = expand('$HOME/.vim') . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
execute 'set runtimepath^=' . s:dein_repo_dir
if dein#load_state(s:dein_dir)
	let s:toml_dir = g:config_home . '/dein'
	let s:toml = s:toml_dir . '/plugins.toml'
	let s:toml_lang = s:toml_dir . '/lang.toml'
	call dein#begin(s:dein_dir, [$MYVIMRC, s:toml, s:toml_lang])
	call dein#load_toml(s:toml)
	call dein#load_toml(s:toml_lang)
	call dein#end()
	call dein#save_state()
endif
if has('vim_starting') && dein#check_install()
	call dein#install()
endif

set encoding=utf-8
scriptencoding utf-8
set fileformat=unix
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp

filetype plugin indent on
syntax enable
colorscheme hybrid

let s:rc_dir = g:config_home . '/nvim' . '/rc'
function s:load_rc(file)
	execute 'source ' . s:rc_dir . '/' . a:file . '.vim'
endfunction
call s:load_rc('setting')
call s:load_rc('grep')
call s:load_rc('keymap')
call s:load_rc('command')
