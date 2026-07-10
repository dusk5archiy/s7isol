if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	return
end

local S7ISOL_NVIM_CONFIG_DIR = os.getenv("S7ISOL_NVIM_CONFIG_DIR")
package.path = package.path .. ";" .. S7ISOL_NVIM_CONFIG_DIR .. "/lua/?.lua"

require("config.lazy")
