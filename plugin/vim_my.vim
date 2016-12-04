let mapleader=","

filetype on

filetype plugin on

" move window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
inoremap <C-h> <ESC><C-w>h
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k

set nocompatible

set background=dark

set cursorline

set number

syntax enable

syntax on

filetype indent on

set tabstop=8
set shiftwidth=8

colorscheme default

" foldmethod
set foldmethod=syntax
set nofoldenable

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
