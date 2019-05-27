set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Sirver/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'godlygeek/tabular'
Plugin 'junegunn/fzf'
Plugin 'rakr/vim-one'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()
filetype plugin indent on


set autoindent
set backspace=indent,eol,start
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
set foldmethod=syntax
set foldnestmax=1
set grepprg=grep\ -nH\ $*
set hidden
set history=100
set hlsearch
set incsearch
set laststatus=2
set linebreak
set mouse=a
set mousemodel=popup_setpos
set nomodeline
set nostartofline
set nrformats=alpha
set path+=src
set shortmess=flmnxoOtTI
set showcmd
set showtabline=1
set smartindent
set smarttab
set splitright
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.aux,.log,.dvi,.bbl,.out,.o,.lo,.d,.class,.pyc
set switchbuf=useopen
set tabstop=4
set softtabstop=4
set shiftwidth=4
set termencoding=utf-8
set viminfo='20,\"500,%
set virtualedit=block
set wildignore+=*/*.bak,*/*~,*/*.o,*/*.sw*,*/*.sw*.obj,*/*.aux,*/*.dvi,*/*.bbl,*/*.out,*/*.o,*/*.lo,*/*.d,*/*.class,*/*.pyc
set wildmenu 
set window=61
syntax on

"
nmap ; :

" Colors & Theming
hi Normal 	ctermfg=252 ctermbg=232
hi LineNr 	ctermbg=0 ctermfg=12
hi NonText 	ctermbg=0 ctermfg=12
hi ColorColumn 	ctermbg=0
hi Search 	term=reverse ctermbg=8
hi Visual 	term=reverse ctermbg=8
hi Comment 	term=bold ctermfg=8 ctermbg=none
colorscheme one
set background=dark
set t_Co=256
set termguicolors
let &colorcolumn="80"
let g:NERDTreeDirArrows=1
let g:NERDTreeMinimalUI=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_powerline_fonts=0
let g:airline_theme='one'
let g:airline#extensions#whitespace#checks = ['trailing']
set number
set relativenumber

let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<Right>"
let g:UltiSnipsJumpBackwardTrigger="<Left>"
