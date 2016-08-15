set nocompatible              " be iMproved, required
filetype off                  " required
set encoding=utf-8

" Leader
let mapleader = "\<Space>"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/ultisnips_rep
"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" color schmes for vim
Plugin 'https://github.com/MaxSt/FlatColor.git'
Plugin 'itchyny/lightline.vim'
Plugin 'https://github.com/tpope/vim-fugitive.git'
" Plugin 'flazz/vim-colorschemes'
" snippet stuff
" Track the engine.
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
" Match Tags
Plugin 'Valloric/MatchTagAlways'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" Add auto-pairs to parentheses and things
Plugin 'jiangmiao/auto-pairs'
" Vim and Tmux integration
Plugin 'christoomey/vim-tmux-navigator'

" required
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" you complete me python config
let g:ycm_path_to_python_interpreter = "/usr/local/bin/python"
" prevent ycm and ultisnip tab collision
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]


" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" o opens a new file
nnoremap <Leader>o :CtrlP<CR>
" space + w writes a file
nnoremap <Leader>w :w<CR>
" copy and paste with leader + y and leader + p
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

if exists('$TMUX')
   function! TmuxOrSplitSwitch(wincmd, tmuxdir)
     let previous_winnr = winnr()
     silent! execute "wincmd " . a:wincmd
     if previous_winnr == winnr()
       call system("tmux select-pane -" . a:tmuxdir)
       redraw!
     endif
   endfunction
 
   let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
   let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
   let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

   noremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
   noremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
   noremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
   noremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
 else
   map <C-j> <C-W>j
   map <C-k> <C-W>k
   map <C-h> <C-W>h
   map <C-l> <C-W>l
   " noremap <C-h> <C-W>h
   " noremap <C-j> <C-W>j
   " noremap <C-k> <C-W>k
   " noremap <C-l> <C-W>l
endif


" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
