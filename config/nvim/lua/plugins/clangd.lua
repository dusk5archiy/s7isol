return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		local clangd = opts.servers.clangd
		-- Only there when lazyvim.json enables the lang.clangd extra.
		if not clangd then
			return
		end
		-- Flags the LazyVim extra sets and we replace (the rest of its list stays).
		local replaced = { "--fallback-style=", "--compile-commands-dir=", "--query-driver=" }
		clangd.cmd = vim.tbl_map(function(arg)
			-- Bare, this flag takes the next argument as its value (it swallowed --fallback-style=llvm), so give it one.
			return arg == "--function-arg-placeholders" and "--function-arg-placeholders=1" or arg
		end, clangd.cmd)
		clangd.cmd = vim.tbl_filter(function(arg)
			for _, prefix in ipairs(replaced) do
				if vim.startswith(arg, prefix) then
					return false
				end
			end
			return true
		end, clangd.cmd)
		vim.list_extend(clangd.cmd, {
			"--query-driver=/usr/bin/*",
			"--fallback-style=GNU",
			"--compile-commands-dir=build",
		})
	end,
}
