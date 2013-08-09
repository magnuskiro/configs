set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ 17
"set guifont=Nimbus\ Mono\ L\ 18
colorscheme delek
highlight Comment cterm=italic
set tabstop=4
let g:neocomplcache_enable_at_startup = 1
"setlocal spell spelllang=nb
filetype plugin on
syntax on
nnoremap <silent> <F8> :TlistToggle<CR>

"autocmd BufNewFile *.tex set tw=80
"autocmd BufRead *.tex set tw=80

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
