".vimrc

" yaml fix
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/syntastic'
Plug 'valloric/youcompleteme'
call plug#end()

