if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	return
end

require("config.lazy")
