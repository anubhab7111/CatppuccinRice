require "nvchad.options"
-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

-- Performance and speed optimizations
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.lazyredraw = true

-- Line numbers and display
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Search improvements
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Faster file operations
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
