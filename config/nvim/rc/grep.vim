if executable('rg')
	" Use rg(ripgrep)
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
elseif executable('pt')
	" Use pt(The Platinum Searcher)
	set grepprg=pt\ --nocolor\ --nogroup\ --column
	set grepformat=%f:%l:%c:%m
elseif executable('ag')
	" Use ag(The Silver Searcher)
	set grepprg=ag\ --vimgrep
	set grepformat=%f:%l:%c:%m
elseif executable('ack')
	set grepprg=ack\ -H\ --nocolor\ --nogroup
	set grepformat=%f:%l:%c:%m
endif
