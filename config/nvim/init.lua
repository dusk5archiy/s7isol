if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	return
end

local S7ISOL_NVIM_CONFIG_DIR = os.getenv("S7ISOL_NVIM_CONFIG_DIR")

if S7ISOL_NVIM_CONFIG_DIR == nil then
	return
end

package.path = package.path .. ";" .. S7ISOL_NVIM_CONFIG_DIR .. "/lua/?.lua"

require("config.lazy")
