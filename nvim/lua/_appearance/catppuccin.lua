return function(args)
	return {
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = args.transparent,
			float = {
				transparent = args.transparent,
			},
		},
	}
end
