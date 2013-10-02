set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ 17
"set guifont=Nimbus\ Mono\ L\ 18

"Color schemes can be found in .vim/colors or /usr/share/vim/vim73/colors/ 
" 'custom' is a modified delek
colorscheme custom

highlight Comment cterm=italic
set tabstop=4
let g:neocomplcache_enable_at_startup = 1

" Spell check. Creates red background on the word that is wrong.
" no/en/en_gb or other will also work. 
setlocal spell spelllang=en_gb

filetype plugin on
syntax on
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
