-- ==========================================================================
-- Basic Setup & Vimscript Compatibility
-- ==========================================================================
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.o.runtimepath

-- Set leaders early so plugins bind correctly
vim.g.mapleader = ","
vim.g.maplocalleader = "@" -- tidal

vim.opt.clipboard = "unnamed"

-- VSCode Neovim Extension Checks
if vim.g.vscode then
  print("in vscode")
else
  print("ordinary neovim")
  require('lspconfig')
  require('utils')
end

-- ==========================================================================
-- Plugins (Using vim-plug via vim.cmd)
-- ==========================================================================
-- Since vim-plug is a Vimscript plugin, the cleanest way to keep using it 
-- in init.lua without switching to a Lua package manager is wrapping it.
vim.cmd([[
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

  " lsp config
  Plug 'neovim/nvim-lspconfig'

  call plug#end()
]])

-- ==========================================================================
-- Editor Options
-- ==========================================================================
-- Default indentation: 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Search
vim.opt.incsearch = true
vim.opt.ignorecase = true  -- ignore case
vim.opt.smartcase = true   -- if start with cap, search cap

-- UI
vim.opt.cursorline = true

if not vim.g.vscode then
  vim.opt.colorcolumn = "80,100,120"
end

-- Use the same symbols as TextMate for tabstops and EOLs
vim.opt.listchars = "tab:▸\\ ,eol:¬"
vim.opt.list = true

-- Status Line
vim.opt.showcmd = true
vim.opt.laststatus = 2
-- Note: Lua requires escaping the backslash in the string
-- FileName [FileType][FileEncoding:FileFormat][ReadOnly][Modified]   Col:Lin/Total
vim.opt.statusline = "%t %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L"

-- ==========================================================================
-- Keymaps & Commands
-- ==========================================================================
-- Remove highlight with CTRL-L
vim.keymap.set('n', '<C-l>', ':nohlsearch<CR><C-l>', { silent = true })

-- fzf
vim.keymap.set('n', '<Leader><C-p>', ':Files<CR>', { silent = true })
vim.keymap.set('n', '<C-p>', ':GFiles<CR>', { silent = true })
vim.keymap.set('n', '<Leader>f', ':Rg<CR>', { silent = true })

-- Custom command: Reload vimrc
vim.api.nvim_create_user_command('Reload', 'source $MYVIMRC', { bang = true })

