" NeoVim Settings

" True Color 有効化
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
" カラースチームの有効化
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" reset augroup
augroup MyAutoCmd
	autocmd!
augroup END

" env
let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" dein {{{

let s:dein_cache_dir = g:cache_home . '/dein'
let s:dein_config_dir = g:config_home . '/dein'
let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
	" Auto Download
	if !isdirectory(s:dein_repo_dir)
		call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
	endif

	" dein.vim をプラグインとして読み込む
	execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" dein.vim settings
let g:dein#install_max_processes = 16
let g:dein#install_message_type = 'none'
let g:dein#install_progress_type = 'title'
let g:dein#enable_name_conversion = 1
let g:dein#enable_notification = 1

if dein#load_state(s:dein_cache_dir)
	let s:toml = s:dein_config_dir . '/plugins.toml'
	let s:toml_lang = s:dein_config_dir . '/lang.toml'
	let s:toml_nvim = s:dein_config_dir . '/neovim.toml'

	call dein#begin(s:dein_cache_dir, [$MYVIMRC, s:toml, s:toml_lang, s:toml_nvim])

	call dein#load_toml(s:toml)
	call dein#load_toml(s:toml_lang)
	" if has('nvim')
		call dein#load_toml(s:toml_nvim)
		if has('mac')
			call dein#load_toml(s:dein_config_dir . '/mac.toml')
		endif
	" endif

	call dein#end()
	call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
	call dein#install()
endif

filetype plugin indent on

" }}}

syntax enable
colorscheme hybrid

" Load Settings File

let s:rc_dir = g:config_home . '/nvim' . '/rc'
function s:load_rc(file)
	execute 'source ' . s:rc_dir . '/' . a:file . '.vim'
endfunction

call s:load_rc('view')
call s:load_rc('setting')
call s:load_rc('grep')
call s:load_rc('keymap')
call s:load_rc('command')

" ファイル文末の改行を勝手に変更しない?
if exists('+fixeol')
	set nofixendofline
endif

" emoji (絵文字は全角とみなす)
if exists('+emo')
	set emoji
endif
