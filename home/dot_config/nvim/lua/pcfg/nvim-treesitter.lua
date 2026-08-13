-- Rewritten for nvim-treesitter's `main` branch.
--
-- Rhodium used the `master` branch API (`nvim-treesitter.configs`), which Nix
-- supplied along with ~300 pre-built grammars. That branch states plainly that
-- "Neovim 0.12 is not supported", and this machine runs 0.12.4: keeping it
-- produced "attempt to call method 'range' (a nil value)" from Neovim's own
-- treesitter runtime on every render.
--
-- `main` drops the configs module. Highlighting and indentation are now enabled
-- per buffer via vim.treesitter, so the two settings Rhodium asked for --
-- highlight and indent -- are reproduced in the FileType autocmd below.

local langs = {
	-- No "jsonc": main has no such parser, jsonc files use the json one.
	"bash", "c", "cpp", "css", "diff", "dockerfile", "fish", "git_config",
	"gitcommit", "gitignore", "go", "graphql", "haskell", "hcl", "html", "java",
	"javascript", "json", "julia", "latex", "lua", "luadoc", "make",
	"markdown",
	"markdown_inline", "nix", "python", "query", "r", "regex", "rust", "scss",
	"sql", "toml", "tsx", "typescript", "typst", "vim", "vimdoc", "xml", "yaml",
}

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Asynchronous, and a no-op once the parsers are present.
require("nvim-treesitter").install(langs)

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("helium_treesitter", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if not lang then
			return
		end
		-- pcall: a filetype whose parser is not installed yet must not raise.
		if pcall(vim.treesitter.start, args.buf, lang) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
