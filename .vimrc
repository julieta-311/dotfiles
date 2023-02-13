call plug#begin()
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go'
Plug 'junegunn/vim-easy-align'
Plug 'webastien/vim-ctags'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()

let mapleader=","

set background=dark

command! W  write

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

let g:gitgutter_highlight_linenrs = 1
highlight! link SignColumn LineNr
highlight link GitGutterChangeLine DiffTest

let g:gitgutter_set_sign_background = 1
let g:gitgutter_highlight_liners = 1

syntax on
set number
" set cursorline
" set cursorcolumn

set spell
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
hi clear SpellBad
hi SpellBad guisp=red gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline
hi SpellCap guisp=yellow gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline
hi SpellRare guisp=blue gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline
hi SpellLocal guisp=orange gui=undercurl guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline

set autochdir
set tags+=./tags;

set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
set clipboard=unnamedplus

" Change how vim represents characters on the screen
set encoding=utf-8

" Set the encoding of files written
set fileencoding=utf-8

autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4

" Control all other files
set shiftwidth=4

filetype plugin indent on

" Copy paste from the clipboard
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v>p c<ESC>"+p
imap <C-v> <C-r><C-o>+

" Press F4 to toggle highlighting on/off, and show current value.
noremap <F4> :set hlsearch! hlsearch?<CR>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Used by vim-tmux-navigation
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l

" highlight last inserted text
nnoremap gV `[v`]

" NERDTree plugin specific commands

nnoremap <leader>z :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader><Up>    <C-w>+
nnoremap <leader><Down>  <C-w>-
nnoremap <leader><Left>  <C-w><
nnoremap <leader><Right> <C-w>>

" Toggle side window with `CTRL+z`.
map <C-z> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:airline_powerline_fonts = 1

" t-mux specific commands

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <S-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <S-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <S-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <S-Right> :TmuxNavigateRight<cr>
nnoremap <silent> <S-leader> :TmuxNavigatePrevious<cr>

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" vim-go specific commands

let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

au filetype go inoremap <buffer> . .<C-x><C-o>

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

" Map keys for most used commands.
" Ex: `\b` for building, `\r` for running and `\b` for running test.
" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

let g:go_fmt_command = "gopls"
let g:go_imports_autosave = 1
let g:go_imports_mode = 'gopls'

" Auto formatting and importing
let g:go_fmt_autosave = 1

" Automatically get signature/type info for object under
let g:go_auto_type_info = 1

let g:go_diagnostics_enabled = 1
let g:go_metalinter_enabled = ['bodyclose', 'dogsled', 'errcheck', 'gofumpt', 'gosimple', 'govet', 'ineffasign', 'staticcheck', 'typecheck', 'unused']
let g:go_metalinter_autosave_enabled = ['bodyclose', 'dogsled', 'errcheck', 'gofumpt', 'gosimple', 'govet', 'ineffasign', 'staticcheck', 'typecheck', 'unused']

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0

autocmd Filetype go nmap <leader>b :GoBuild
autocmd Filetype go nmap <leader>r :GoRun
autocmd Filetype go nmap <leader>s :GoTestFunc
autocmd Filetype go nmap <leader>t :GoTest
autocmd Filetype go nmap <leader>f :GoFillStruct
autocmd Filetype go nmap <leader>l :GoMetaLinter
autocmd Filetype go nmap <leader>m :GoReferrers
autocmd Filetype go nmap <leader>c :GoCallers
