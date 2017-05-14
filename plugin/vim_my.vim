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
set shell=bash
nnoremap <silent> <leader>sh :!s<CR><CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <TAB> :nohl<cr>
let s:output_opened = 0

function Execute_command(command)
	silent !echo > .OUTPUT
	execute "!( ".a:command." ) 2>&1 | tee .OUTPUT"
endfunction

function Process_command_args(...)
	let cmd_args = []
	for arg in a:000
		call add(cmd_args, shellescape(arg))
	endfor
	return cmd_args
endfunction

function Execute_command_with_args(...)
	let args = call (function('Process_command_args'), a:000)
	call Execute_command(join(args))
endfunction

function Close_output_window()
	if filereadable('.OUTPUT')
		sp .OUTPUT
		call AnsiEse_off()
		bd
		let s:output_opened = 0
	endif
endfunction

function Open_output_window()
	if filereadable('.OUTPUT')
		sp .OUTPUT
		set buftype=nofile
		call AnsiEse_on()
		let s:output_opened = 1
	endif
endfunction

function Toggle_output_window()
	if s:output_opened
		call Close_output_window()
	else
		call Open_output_window()
	endif
	call Reset_color_settings()
endfunction

nnoremap <silent> <leader>ov :call Toggle_output_window()<cr>
command -nargs=* Shell call Execute_command_with_args(<f-args>)


" TEST/APP RUNNER
let g:test_current_ut = []
let g:test_current_at = []
let g:test_all_test = []
let g:test_last_test = []
let g:test_app = []

function Run_ut(...)
	let g:test_current_ut = a:000
	call Run_current_ut()
endfunction

function Run_current_ut()
	let g:test_last_test = g:test_current_ut
	call Run_last_test()
endfunction

function Run_at(...)
	let g:test_current_at = a:000
	call Run_current_at()
endfunction

function Run_current_at()
	let g:test_last_test = g:test_current_at
	call Run_last_test()
endfunction

function Run_t(...)
	let g:test_all_test = a:000
	call Run_all_t()
endfunction

function Run_all_t()
	let g:test_last_test = g:test_all_test
	call Run_last_test()
endfunction

function Run_last_test()
	if len(g:test_last_test)
		wa
		call call(function('Execute_command_with_args'), g:test_last_test)
	endif
endfunction

function Run_app(...)
	let g:test_app = a:000
	call Run_current_app()
endfunction

function Run_current_app()
	if len(g:test_app)
		wa
		call Execute_command(join(g:test_app))
	endif
endfunction

function Run_test_file()
	let file=@%
	if file =~ '.feature$'
		let g:test_last_test = g:test_bdd_features + [file]
	elseif file =~ 'spec/.*.rb$'
		let g:test_last_test = ['rspec', file]
	elseif file =~ '.py$'
		let file = substitute(file, '/', '.', 'g')
		let file = substitute(file, '.py$', '', '')
		let g:test_last_test = ['python', '-m', 'unittest', file]
	else
		let g:test_last_test = eval('g:test_file_'.expand('%:e')) + [file]
	endif
	call Run_last_test()
endfunction

function Run_test_file_at()
	let file=@%
	if file =~ '.feature$'
		let g:test_last_test = g:test_bdd_features + [file.':'.line('.')]
	elseif file =~ 'spec/.*.rb$'
		let g:test_last_test = ['rspec', file.':'.line('.')]
	elseif file =~ '.py$'
		let file = substitute(file, '/', '.', 'g')
		let file = substitute(file, '.py$', '', '')
		let g:test_last_test = ['python', file]
	else
		let g:test_last_test = eval('g:test_file_'.expand('%:e').'_at') + [file.':'.line('.')]
	endif
	call Run_last_test()
endfunction

command -nargs=* RunUT call Run_ut(<f-args>)
command -nargs=* RunAT call Run_at(<f-args>)
command -nargs=* RunT call Run_t(<f-args>)
command -nargs=* RunAPP call Run_app(<f-args>)

nnoremap <silent> <leader>ru :echo 'Run Unit Tests...'<cr>:call Run_current_ut()<cr>
nnoremap <silent> <leader>ra :echo 'Run Acceptance Test...'<cr>:call Run_current_at()<cr>
nnoremap <silent> <leader>rt :echo 'Run All Test...'<cr>:call Run_all_t()<cr>
nnoremap <silent> <leader>rr :echo 'Rerun test...'<cr>:call Run_last_test()<cr>
nnoremap <silent> <leader>rp :echo 'Run App...'<cr>:call Run_current_app()<cr>
nnoremap <silent> <leader>rf :echo "Run Test in \'".@%."\'..."<cr>:call Run_test_file()<cr>
nnoremap <silent> <leader>rl :echo "Run Test in \'".@%.':'.line('.')"\'..."<cr>:call Run_test_file_at()<cr>
execute "set <M-r>=\er"
inoremap <silent> <M-r> <Esc> :echo 'Rerun test...'<cr>:call Run_last_test()<cr>
nnoremap <silent> <M-r> :echo 'Rerun test...'<cr>:call Run_last_test()<cr>

if filereadable(expand('%:p:h')."/.dev")
	autocmd BufWritePost * silent exe ':!rtouch '.expand('<afile>')
endif
