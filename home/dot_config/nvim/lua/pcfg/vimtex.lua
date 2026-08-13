return {
	"lervag/vimtex",
	lazy = false,

	init = function()
		vim.g.vimtex_view_method = "general"
		vim.g.vimtex_view_general_viewer = "open"
		vim.g.vimtex_view_general_options = "-a Preview"

		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			out_dir = "build",
			options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
		}

		vim.g.vimtex_doc_enabled = 0
		vim.g.vimtex_complete_enabled = 0
		vim.g.vimtex_syntax_enabled = 0
		vim.g.vimtex_imaps_enabled = 0

		vim.g.vimtex_view_forward_search_on_start = 0
	end
}
