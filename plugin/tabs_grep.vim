if exists('g:loaded_tabs_grep')
	finish
endif
let g:loaded_tabs_grep = 1

command! -nargs=1 TabsGrep :call tabs_grep#TabsGrep(<f-args>)
