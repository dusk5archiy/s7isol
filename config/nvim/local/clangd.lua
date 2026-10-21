local function get_program_path(program)
	return string.lower(vim.fn.exepath(program)):gsub("\\", "/"):gsub("^%l", string.upper)
end

require("lspconfig").clangd.setup({
	cmd = {
		"clangd",
		string.format("--query-driver=%s,%s", get_program_path("gcc"), get_program_path("g++")),
		"--fallback-style=GNU",
		"--compile-commands-dir=build",
		"--clang-tidy",
		"--background-index",
	},
	filetypes = { "c", "h", "hpp", "cpp" },
})
