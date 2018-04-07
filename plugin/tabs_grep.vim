" function! tabs_grep#TabsGrep(search)
function! TabsGrep(search)
	redir => tabs_output
	silent tabs
	redir END

	let tabs = split(tabs_output, '\n')

	echo tabs
	call filter(tabs, function('s:MatchString', [a:search]))
	echo tabs

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
	" let matched = match(a:value, a:search) != -1 ||
	" 	\ match(a:value, '\vTab page \d+') != -1
	" let matched = 0
	" 	\ || 1
	" return matched
	" return (
	" 	\ 
	" 	\ match(a:value, '\vTab page \d+') != -1
	" \ )
	" return match(a:value, a:search) != -1 ||
	" 	\ match(a:value, '\vTab page \d+') != -1
	echo 'test'
	echo a:search
	return 0 ||
		\ 1
endfunction

command! -nargs=1 TabsGrep :call TabsGrep(<f-args>)
