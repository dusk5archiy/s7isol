return {
	"snacks.nvim",
	opts = {
		-- picker ------------------------------------------------------------------
		picker = {
			sources = {
				explorer = {
					hidden = true,
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
}
