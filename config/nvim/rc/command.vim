" ChangeUsersDirName {{{
" http://qiita.com/shinespark/items/080a62f7260933ec8400

command! ChangeUsersDirName :%s/\(\/Users\/\)\w\+/\1user_name/g
" }}}
" QfMessages {{{
" http://qiita.com/tmsanrinsha/items/0787352360997c387e84
function! s:qf_messages()
	let str_messages = ''
	redir => str_messages
	silent! messages
	redir END

	let qflist = s:parse_error_messages(str_messages)
	call setqflist(qflist, 'r')
	cwindow
endfunction

function! s:parse_error_messages(messages) abort
	" 戻り値。setqflistの引数に使う配列
	let qflist = []
	" qflistの要素になる辞書
	let qf_info = {}
	" qflistの要素となる辞書の配列。エラー内容がスタックトレースのときに使用
	let qf_info_list = []
	" 読み込んだファイルの内容をキャッシュしておくための辞書
	let files = {}

	if v:lang =~# 'ja_JP'
		let regex_error_detect = '^.\+\ze の処理中にエラーが検出されました:$'
		let regex_line = '^行\s\+\zs\d\+\ze:$'
		let regex_last_set = '最後にセットしたスクリプト: \zs\f\+'
	else
		let regex_error_detect = '^Error detected while processing \zs.\+\ze:$'
		let regex_line = '^line\s\+\zs\d\+\e:$'
		let regex_last_set = 'Last set from \zs\f\+'
	endif

	for line in split(a:messages, "\n")
		if line =~# regex_error_detect
			" ... の処理中にエラーが検出されました:'
			let matched = matchstr(line, regex_error_detect)
			if matched =~# '^function'
				" function <SNR>253_fuga の処理中にエラーが検出されました:
				" function <SNR>253_piyo[1]..<SNR>253_fuga の処理中にエラーが検出されました:
				let matched = matchstr(matched, '^function \zs\S*')
				let stacks = reverse(split(matched, '\.\.'))
				for stack in stacks
					let [func_name, offset] = (stack =~# '\S\+\[\d')
					\ ? matchlist(stack, '\(\S\+\)\[\(\d\+\)\]')[1:2]
					\ : [stack, 0]

					" 辞書関数の数字は{}で囲む
					let func_name = func_name =~# '^\d\+$' ? '{' . func_name . '}' : func_name

					redir => verbose_func
					execute 'silent verbose function ' . func_name
					redir END

					let filename = matchstr(verbose_func, regex_last_set)
					let filename = expand(filename)

					if !has_key(files, filename)
						let files[filename] = readfile(filename)
					endif

					if func_name =~# '{\d\+}'
						let func_lines = split(verbose_func, "\n")
						unlet func_lines[1]
						let max_line = len(func_lines)
						let func_lines[0] = '^\s*fu\%[nction]!\=\s\+\zs\S\+\.\S\+'

						for i in range(1, max_line - 2)
							let func_lines[i] = '^\s*' . matchstr(func_lines[i], '^\d\+\s*\zs.*')
						endfor

						let func_lines[max_line - 1] = '^\s*endf[unction]'

						let lnum = 0
						while 1
							let lnum = match(files[filename], func_lines[0], lnum)

							if lnum < 0
								throw 'No dictionary function'
							endif

							let find_dic_func = 1
							for i in range(1, max_line - 1)
								if files[filename][lnum + i] !~# func_lines[i]
									let lnum = lnum + i
									let find_dic_func = 0
									break
								endif
							endfor

							if find_dic_func
								break
							endif
						endwhile

						let func_name = matchstr(files[filename][lnum], func_lines[0])
						let lnum += 1 + offset
					else
						let func_name  = substitute(func_name, '<SNR>\d\+_', 's:', '')
						let lnum = match(files[filename], '^\s*fu\%[nction]!\=\s\+' . func_name) + 1 + offset
					endif

					call add(qf_info_list, {
					\   'filename': filename,
					\   'lnum': lnum,
					\   'text': func_name,
					\})
				endfor
			else
				" <filename> の処理中にエラーが検出されました:
				let filename = expand(matchstr(line, regex_error_detect))
				let qf_info.filename = expand(filename)
			endif
		elseif line =~# regex_line
			" 行    1:
			let lnum = matchstr(line, regex_line)
			if len(qf_info_list) > 0
				let qf_info_list[0]['lnum'] += lnum
			else
				let qf_info.lnum = lnum
			endif
		elseif line =~# '^E'
			" E492: エディタのコマンドではありません: one
			let [nr, text] = matchlist(line, '^E\(\d\+\): \(.\+\)')[1:2]
			if len(qf_info_list) > 0
				if len(qf_info_list) == 1
					let qf_info_list[0]['nr'] = nr
					let qf_info_list[0]['text'] = 'in ' . qf_info_list[0]['text'] . ' | ' . text
				else
					let i = 0
					for val in qf_info_list
						let val['nr'] = nr
						let val['text'] = '#' . i . ' in ' . val['text'] . (i == 0 ? (' | ' . text) : '')
						let i += 1
					endfor
				endif
				let qflist += qf_info_list
			else
				let qf_info.nr = nr
				let qf_info.text = text
				call add(qflist, qf_info)
			endif

			let qf_info = {}
			let qf_info_list = []
		endif
	endfor

	return qflist
endfunction

command! -nargs=0 QfMessages call s:qf_messages()
" }}}
