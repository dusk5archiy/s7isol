if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	return
end

require("config.lazy")

local dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])") or "./"
dofile(dir .. "local/clangd.lua")
