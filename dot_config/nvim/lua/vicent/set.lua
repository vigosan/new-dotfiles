vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Cursor
vim.opt.guicursor = ""
vim.opt.cursorline = true

-- Line numbers
vim.opt.number = true

-- Tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.textwidth = 80

-- Line wrapping
vim.opt.wrap = false

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.syntax = "on"

-- Backups & undo
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Better completion
vim.opt.completeopt = "menu,menuone,noselect"
