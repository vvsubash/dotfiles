-- options.lua: General Neovim settings

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.exrc = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- tsrx (.tsrx) files are TSX; treat them as typescriptreact for LSP/treesitter/oxc tooling.
vim.filetype.add({ extension = { tsrx = "typescriptreact" } })
