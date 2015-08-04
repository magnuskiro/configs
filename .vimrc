set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ 17
"set guifont=Nimbus\ Mono\ L\ 18

"Color schemes can be found in .vim/colors or /usr/share/vim/vim73/colors/ 
" 'custom' is a modified delek
colorscheme custom
"colorscheme delek

set shell=/bin/bash

highlight Comment cterm=italic
let g:neocomplcache_enable_at_startup = 1

filetype plugin on

" Syntax highlighting 
syntax on

" Set tabs at 4 spaces
retab " change all existing tabs to 4 spaces.
set tabstop=4 " defines how many spaces should be inserted instead of tab.
set shiftwidth=4 " indentation space definition. 
set expandtab " insert space when tab is pressed. 

" Set matching [] and {}
set showmatch

nnoremap <silent> <F8> :TlistToggle<CR>

autocmd BufNewFile *.* set tw=80
autocmd BufRead *.* set tw=80

set nocompatible
set ruler
set pastetoggle=<F12>
set showmatch
set ignorecase
set incsearch
" Remap ctags C-] for Norsk tastatur
nnoremap <C-\> <C-]>

" Spell check. Creates red background on the word that is wrong.
" no/en/en_gb or other will also work. 
setlocal spell spelllang=en_gb

" Spelling
" todo fix highlighting of spelling mistakes. 
