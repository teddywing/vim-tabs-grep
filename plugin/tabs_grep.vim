" function! tabs_grep#TabsGrep(search)
function! TabsGrep(search)
	redir => tabs_output
	silent tabs
	redir END

	let tabs = split(tabs_output, '\n')

	echo tabs
	call filter(tabs, function('s:MatchString', [a:search]))
	echo tabs

	echo s:FilterTabPageElements(tabs)

	" let filtered_tabs = system(
	" 	\ 'echo '
	" 	\ . shellescape(tabs_output)
	" 	\ . " | grep -i "
	" 	\ . shellescape(a:search)
	" \ )
    "
	" echo filtered_tabs
endfunction

function! s:MatchString(search, index, value)
	return match(a:value, a:search) != -1 ||
		\ match(a:value, '\vTab page \d+') != -1
endfunction

function! s:IsTabPageLine(line)
	return match(a:line, '\vTab page \d+') != -1
endfunction

function! s:FilterTabPageElements(list)
	" Has matches:
	" [0, 1, 1, 0, 0]
	"
	" Tab page line indexes:
	" [1, 2, 4, 6, 7, 8]
	"
	" Tab page line indexes with matches:
	" [2, 4]

	let tab_page_indexes = []

	for i in range(len(a:list))
		if s:IsTabPageLine(a:list[i])
			call add(tab_page_indexes, i)
		endif
	endfor

	echo tab_page_indexes

	" loop 1..-1
	" if l[i-1] == l[i] - 1
	" delete l[i-1]
	" if last l == len l - 1
	" delete last l

	let tab_page_indexes_to_remove = []

	for i in range(1, len(tab_page_indexes) - 1)
		if tab_page_indexes[i - 1] == tab_page_indexes[i] - 1
			call add(tab_page_indexes_to_remove, tab_page_indexes[i - 1])
		endif
	endfor

	if tab_page_indexes[-1] == len(a:list) - 1
		call add(tab_page_indexes_to_remove, tab_page_indexes[-1])
	endif

	for i in reverse(tab_page_indexes_to_remove)
		call remove(a:list, i)
	endfor

	return a:list
endfunction

command! -nargs=1 TabsGrep :call TabsGrep(<f-args>)
