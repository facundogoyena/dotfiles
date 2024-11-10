" Plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()
    Plug 'ayu-theme/ayu-vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'mattn/emmet-vim'
    Plug 'scrooloose/syntastic'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()

" General settings
set encoding=UTF-8
filetype plugin indent on
syntax on
set autoread
"set number "line numbers
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set ic "ignore case
set laststatus=2
set cmdheight=1
set wildmenu
set backspace=indent,eol,start "make sure backspace works
"set noruler "hide info on statusbar for cursor position in file
set confirm
set autoindent
set smartindent
set hls is
set cursorline

" trailing whitespace and tabs
exec "set listchars=tab:\uBB\uBB,trail:\uB7"
set list

" Yaml fix
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Themes
set termguicolors
let ayucolor="dark"
colorscheme ayu
let g:airline_theme='base16'

" Key mappings
set pastetoggle=<F2>
"nnoremap <C-s> :source $MYVIMRC<CR>
" ^ not working on windows for some reason :(

