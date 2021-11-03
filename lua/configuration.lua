vim.g.mapleader = " "

-- Disabled defaults
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

vim.o.splitright = true -- new window comes right
vim.o.splitbelow = true -- new window comes below

vim.o.completeopt = "menuone,noselect"

-- Syntax and Indent
vim.o.showmatch = true -- show matching braces when selector is inside one of them
vim.o.background= "dark"
vim.o.encoding= "UTF-8"
vim.o.smartindent = true -- auto indent lines if the previous line was indented

-- Basic Editing Config
vim.o.visualbell = true
vim.o.cursorline = true --show cursor below line
vim.o.number = true --set number of lines
vim.o.rnu = true --set relative number of lines
--vim.o.cc = "80" --create a vertical line at 80 character
vim.o.scrolloff = 8 -- The number of screen lines to keep above and below the cursor.
vim.o.sidescrolloff = 5 -- The number of screen columns to keep to the left and right of the cursor.
vim.o.termguicolors = true -- Add true colors support
vim.o.conceallevel = 2 -- Conceal items

-- Tabulation
vim.o.expandtab = true --tabs are spaces (thanks python)
vim.o.tabstop=4 --number of visual spaces per TAB
vim.o.shiftwidth=4
vim.o.softtabstop=4 --number of spaces in tab when editing

-- Searching
vim.o.incsearch = true --show search as characters entered

-- Undo/Redo
vim.o.undofile = true   -- Maintain undo history between sessions
vim.o.undodir = "/Users/danielmathiot/.vim/undodir"  -- Undo directory (to create if not created)

vim.o.shortmess = "I" -- Do not show the intro message
vim.o.lazyredraw = true -- Do not redraw screen while processing macros
