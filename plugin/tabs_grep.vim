" function! tabs_grep#TabsGrep(search)
function! TabsGrep(search)
	redir => tabs_output
	silent tabs
	redir END

	let tabs = split(tabs_output, '\n')

	call filter(tabs, function('s:MatchString', [a:search]))

	let tabs = s:FilterTabPageElements(tabs)
	for line in tabs
		echo line
	endfor
endfunction

function! s:MatchString(search, index, value)
	return match(a:value, a:search) != -1 ||
		\ s:IsTabPageLine(a:value)
endfunction

function! s:IsTabPageLine(line)
	return match(a:line, '\vTab page \d+') != -1
endfunction

function! s:FilterTabPageElements(list)
	let tab_page_indexes = []

	" Get a list of the indexes of "Tab page X" elements.
	for i in range(len(a:list))
		if s:IsTabPageLine(a:list[i])
			call add(tab_page_indexes, i)
		endif
	endfor

	let tab_page_indexes_to_remove = []

	" For indexes in the middle of the list, if `2` is just before `3`, it
	" means that `2` didn't have any files under it (otherwise `3` would
	" instead be `4` or higher).
	for i in range(1, len(tab_page_indexes) - 1)
		if tab_page_indexes[i - 1] == tab_page_indexes[i] - 1
			call add(tab_page_indexes_to_remove, tab_page_indexes[i - 1])
		endif
	endfor

	" For the last index in the list, if it's equal to the last possible
	" index in `a:list`, it's a tab page without children. The last tab page
	" index should never be at the end.
	if tab_page_indexes[-1] == len(a:list) - 1
		call add(tab_page_indexes_to_remove, tab_page_indexes[-1])
	endif

	" Remove empty "Tab page X" elements from the `:tabs` list. Reverse the
	" list of indexes to delete from right to left, ensuring we always use
	" valid indexes.
	for i in reverse(tab_page_indexes_to_remove)
		call remove(a:list, i)
	endfor

	return a:list
endfunction

command! -nargs=1 TabsGrep :call TabsGrep(<f-args>)
