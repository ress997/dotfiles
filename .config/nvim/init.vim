set fileformat=unix
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp

" reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

" ENV {{{

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" }}}
" dein {{{

let s:dein_dir = g:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Auto Download {{{
if !isdirectory(s:dein_repo_dir)
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
" }}}

" dein.vim をプラグインとして読み込む
execute 'set runtimepath^=' . s:dein_repo_dir

" dein.vim settings {{{
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1
" }}}

if dein#load_state(s:dein_dir)

	let s:toml_dir = '~/.config/dein'
	let s:toml = s:toml_dir . '/plugins.toml'
	let s:toml_neovim = s:toml_dir . '/neovim.toml'
	let s:toml_mac = s:toml_dir . '/mac.toml'

	call dein#begin(s:dein_dir, [$MYVIMRC, s:toml, s:toml_neovim, s:toml_mac])

	call dein#load_toml(s:toml)

	if has('nvim')
		call dein#load_toml(s:toml_neovim)
		if has('mac')
			call dein#load_toml(s:toml_mac)
		endif
	endif

	call dein#end()
	call dein#save_state()

endif

if has('vim_starting') && dein#check_install()
	call dein#install()
endif

filetype plugin indent on

" }}}

colorscheme hybrid
syntax on

" NeoVim Settings {{{

" 制御シーケンスの設定
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
" カラースチームの有効化
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

if $TERM_PROGRAM == "iTerm.app"
	let &t_SI = "\e]50;CursorShape=1\x7"	" インサートモード開始時
	let &t_EI = "\e]50;CursorShape=0\x7"	" 挿入または置換モード終了
	let &t_SR = "\e]50;CursorShape=2\x7"	" 置換モードの開始
endif

" }}}
" Load Setting File {{{

let s:rc_dir = g:config_home . '/vim' . '/rc'

function s:load_rc(file)
	execute 'source ' . s:rc_dir . '/' . a:file . '.vim'
endfunction

call s:load_rc('setting')
call s:load_rc('grep')
call s:load_rc('keymap')

" }}}
