""""""""""""""""""" foldmethod
set foldmethod=syntax
set nofoldenable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""" move window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
inoremap <C-h> <ESC><C-w>h
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""" save and load
nnoremap <silent> <leader>ss :call Save_all()<cr>
nnoremap <silent> <leader>sl :call Load_all()<cr>

function Save_all()
	NERDTreeClose
	wa
	mksession! .session.vim
	NERDTree
endfunction

function Load_all()
	NERDTreeClose
	if filereadable(".session.vim")
		source .session.vim
	endif
	NERDTree
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""" edit vimrc
command Conf :tabnew ~/.vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shell=s
nnoremap <silent> <leader>sh :shell<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

