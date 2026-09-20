return {
	"snacks.nvim",
	opts = {
		-- picker ------------------------------------------------------------------
		picker = {
			sources = {
				explorer = {
					hidden = true,
					ignored = true,
				},
			},
		},
		-- dashboard ---------------------------------------------------------------
		dashboard = {
			formats = {
				footer = { "%s", align = "center" },
				cache = false,
				ttl = 0,
			},
			sections = {
				{ section = "startup" },
			},
		},
		-- end ---------------------------------------------------------------------
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer({ cwd = vim.fn.getcwd() })
			end,
			desc = "Explorer Snacks (cwd)",
		},
	},
}
