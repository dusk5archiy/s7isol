-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.has("win32") == 1 then
	vim.o.shellslash = false
end
vim.opt.colorcolumn = "80"
vim.opt.columns = 80
vim.opt.conceallevel = 2
vim.opt.cursorline = false
vim.opt.fileformats = "unix,dos"
vim.opt.linebreak = false
vim.opt.shellcmdflag = "-c"
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
