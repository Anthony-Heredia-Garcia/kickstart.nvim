-- GNU Make recipes must start with a real tab character.
-- vim-sleuth guesses indent from the current file and reapplies those
-- guesses on FileType, which would override Neovim's make ftplugin when a
-- Makefile is already space-indented.
vim.g.sleuth_make_heuristics = 0
vim.b.sleuth_heuristics = 0

vim.bo.expandtab = false
vim.bo.tabstop = 8
vim.bo.shiftwidth = 8
vim.bo.softtabstop = 0
