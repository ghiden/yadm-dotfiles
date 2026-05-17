set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

set clipboard=unnamed

if exists('g:vscode')
  echo "in vscode"
else
  echo "ordinary neovim"
  lua require('lspconfig')
  lua require('utils')
endif

function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'

" fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" TidalCycles
Plug 'tidalcycles/vim-tidal'

" for neovim
Plug 'numToStr/Comment.nvim'

" lsp config
Plug 'neovim/nvim-lspconfig'

call plug#end()

lua require('Comment').setup()

let mapleader = ","

" tidal
let maplocalleader = "@"

" default indentation: 2 spaces
set ts=2 sts=2 sw=2 expandtab

" search
set incsearch
set ignorecase			" ignore case
set smartcase			" if start with cap, search cap

" remove highlight CTRL-L
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" cursor line
set cursorline
"gui
" highlight CursorLine guibg=lightblue
"terminal
" highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" highlight the 80th, 100th, 120th columns only when not in vscode
if !exists('g:vscode')
 :set colorcolumn=80,100,120
endif

" status line
set showcmd
set laststatus=2
" FileName [FileType][FileEncoding:FileFormat][ReadOnly][Modified]   Col:Lin/Total
set statusline=%t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L

" fzf
nnoremap <silent> <Leader><C-p> :Files<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>f :Rg<CR>

" Custom command
" - Reload vimrc
command! -bang Reload source $MYVIMRC
