"------  Visual Options  ------"

syntax enable                       " enable syntax highlighting
set number                          " enable line numbers
set nowrap                          " disable word wrap
set vb                              " visual bell
set showmatch                       " show matching bracket

set laststatus=2                    " always use a status line

"------  Behavior  ------"

set backspace=indent,eol,start      " normal backspace behavior
set history=1000                    " 1000 item history
set undolevels=1000                 " 1000 item undo buffer
let mapleader=","                   " set leader to ,
let maplocalleader=','              " set leader harder
set title                           " update the terminals title
set tabstop=4                       " tab = 4 spaces
set shiftwidth=4                    " indent to 4 spaces
set softtabstop=4                   " Number of spaces that a <Tab> counts for
set expandtab                       " use spaces instead of tabs
set autoindent                      " auto indent
set smartindent                     " use vim smart indenting
set backupcopy=yes                  " always write out a new file and then copy it over the original on save

" Ignore these files when completing names
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo
set wildignore+=*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
set wildignore+=*/tmp/*,*.zip,*.pyc

set iskeyword+=_,$,@,%,#

set wildmode=longest,list:longest   " Shell style tab completion

filetype indent on
filetype plugin on

set encoding=utf-8

"------  Searching  ------"

set incsearch                       " Search while typing
set ignorecase                      " Case insensitive searching
set smartcase                       " lowercase = case insensitive, any uppercase = case sensitive
set hlsearch                        " highlight all search results

" following line clears the search highlights when pressing <Leader>s
nnoremap <Leader>s :nohlsearch<CR>

set grepprg=grep\ -nH\ $*           " set grep to always display a file name

"------  Buffers  ------"

" switch between unsaved buffers w/o needing to save
set hidden

"------  Windows  ------"

" Move easily between windows
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" Keybindings for splitting windows
noremap <Leader>v :split<CR>
noremap <Leader>V :vsplit<CR>

"------  Text Width Stuff  ------"

set tw=80
set fo-=c
set fo-=t
set modeline
set modelines=3
set sr
set whichwrap=h,l,~,[,]

"------  Helpful keybindings  ------"

" ,T = Delete all Trailing space in file
map <Leader>T :%s/\s\+$//<CR>

" Sometimes you just need to teach vim whose boss
noremap <Leader>r :redraw!<CR>

" I make the mistake of typing W and Q instead of w and q
nmap :W :w
nmap :Q :q

" Kill the evil EX mode
nmap Q <Nop>

"------  Set custom colorscheme stuff  ------"

set background=dark
colorscheme solarized

"------  Vim Config Stuff  ------"

" Set swp files to go to a central location
set backupdir=$HOME/.config/nvim/swp//,/tmp//,.
set directory=$HOME/.config/nvim/swp//,/tmp//,.

" Share clipboard
set clipboard+=unnamedplus

" Better tab-completion
set wildmenu

"------  Safe crontab  ------"
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

"------  Filetype tweaks  ------"
autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType cpp nmap <buffer> <silent> <Leader>d <C-]>

au BufWritePost *.re silent! ReasonPrettyPrint

"------  Python Stuff  ------"
let g:python_highlight_all=1

"------  Whitespace  ------"

" Show trailing whitespace
set list

" But only interesting whitespace
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

au Filetype go setlocal nolist

"------  Visual Mode related  ------"

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>

"------  Persistent undo  ------"

set undodir=$HOME/.config/nvim/undo/
set undoreload=10000
set undofile

"------  Tab management  ------"
nnoremap <silent> \[ :tabp<CR>
nnoremap <silent> \] :tabn<CR>

nnoremap <silent> tn :tabnew<CR>
nnoremap <silent> td :tabclose<CR>
nnoremap <silent> tt :tabedit %<CR>

"------  Terminal Mode  ------"
let g:terminal_scrollback_buffer_size = 100000

autocmd WinEnter term://* startinsert

tnoremap <Esc><Esc> <C-\><C-n>

tnoremap <C-J> <C-\><C-n><C-W>j
tnoremap <C-K> <C-\><C-n><C-W>k
tnoremap <C-H> <C-\><C-n><C-W>h
tnoremap <C-L> <C-\><C-n><C-W>l

nnoremap <leader>z :split \| terminal <CR>
nnoremap <leader>Z :vsplit \| terminal <CR>

"====================================="
"======  PLUGINS CONFIGURATION ======="
"====================================="

"------  Deoplete ------"

set completeopt-=preview
set completeopt+=noinsert
set completeopt+=noselect
set completeopt+=menuone
set completeopt+=longest

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#jedi#python_path = g:python3_host_prog

let deoplete#tag#cache_limit_size = 5000000

imap <silent><expr><Tab> pumvisible() ? "\<C-n>"
    \ : (<SID>is_whitespace() ? "\<Tab>"
    \ : deoplete#mappings#manual_complete())

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:is_whitespace()
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~? '\s'
endfunction

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return deoplete#mappings#close_popup() . "\<CR>"
endfunction

"------  Jedi ------"

let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = "0"

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = ""
let g:jedi#completions_command = ""
let g:jedi#rename_command = ""

let g:jedi#force_py_version = 3

"------  Vim Airline ------"
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled = 0
let g:airline_theme = 'solarized'

"------  NERDTree Options  ------"

let NERDTreeIgnore=['\.git$', '\.pyc$', '__pycache__']

" following line finds the current file in NERDTree when pressing <Leader>a
noremap <leader>a :NERDTreeFind<C-M>

" quit vim if NERDTree is last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"------  TagBar Options  ------"
"
noremap <leader>A :TagbarToggle<CR>

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:headings',
        \ 'l:links',
        \ 'i:images'
    \ ],
    \ "sort" : 0
\ }

"------  EasyTags Options  ------"
set cpoptions+=d
set tags=./.tags
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1
let g:easytags_suppress_report = 1
let g:easytags_async = 1

let g:easytags_languages = {
\   'go': {
\     'cmd': 'gotags',
\     'args': ['-sort -silent']
\   }
\}

"------  Ctrl-p  ------"
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_extensions = ["tag"]
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_case_sensitive = 0
let g:ctrlp_use_caching = 0

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_match_func = {'match' : 'cpsm#CtrlPMatch' }

nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>B :CtrlPTag<CR>

"------  GitGutter  ------"
highlight clear SignColumn

"------  ALE  ------"
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\   'scss': ['prettier'],
\}

let g:ale_linters = {
\   'javascript': [
\       'eslint',
\       'flow',
\   ],
\   'go': [
\       'gometalinter',
\       'go build',
\   ],
\}

let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
let g:ale_javascript_flow_use_global = 1
let g:ale_javascript_eslint_use_global = 1

"------  Vim-Javascript  ------"

let g:javascript_plugin_flow = 1

"------  Grepper  ------"
let g:grepper               = {}
let g:grepper.tools         = ['git', 'sift']
let g:grepper.jump          = 1
let g:grepper.next_tool     = '<leader>g'
let g:grepper.simple_prompt = 1

nmap <leader>g :Grepper -tool git -nojump -open -switch<CR>
nmap <leader>G :Grepper -tool git -nojump -open -switch -cword -noprompt<CR>

"------  JSX  ------"
let g:jsx_ext_required = 0

"------ Go ------"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

au FileType go nmap gb <Plug>(go-doc-browser)
au FileType go nmap gi <Plug>(go-info)
au FileType go nmap <Leader>d <Plug>(go-def)

"------  Undo Tree  ------"

nnoremap <silent> <leader>u :UndotreeToggle<CR>

let g:undotree_SetFocusWhenToggle = 1

"------  Multiple Cursors  ------"

function! Multiple_cursors_before()
    let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
    let b:deoplete_disable_auto_complete = 0
endfunction

"------  vimoutliner  ------"

autocmd FileType votl setlocal nolist

"------  vim-rooter   ------"
let g:rooter_patterns = ['.vim-rooter', '.git', '.git/']
