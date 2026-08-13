-- Plugin specification, ported from Rhodium's six Nix modules.
--
-- On Rhodium, Nix installed every plugin and injected each one's Lua config
-- through the `config` attribute, so everything was present at startup. lazy.nvim
-- reproduces that with `defaults = { lazy = false }` below; per-plugin configs
-- live in lua/pcfg/ and are required verbatim from Rhodium.
--
-- Every repository here was verified to resolve with `git ls-remote`.

return {
	{
		"stevearc/aerial.nvim",
		config = function()
			require("pcfg.aerial-nvim")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		config = function()
			require("pcfg.bufferline-nvim")
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("pcfg.comment-nvim")
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("pcfg.conform-nvim")
		end,
	},
	{
		"chrisbra/csv.vim",
		config = function()
			require("pcfg.csv-vim")
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		config = function()
			require("pcfg.dashboard-nvim")
		end,
	},
	{
		"folke/flash.nvim",
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("pcfg.harpoon2-nvim")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("pcfg.indent-blankline-nvim")
		end,
	},
	{
		"pabloagn/kanso.nvim",
		priority = 1000,
		config = function()
			require("pcfg.kanso-nvim")
		end,
	},
	{
		"kmonad/kmonad-vim",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
		config = function()
			require("pcfg.lualine-nvim")
		end,
	},
	{
		"chentoast/marks.nvim",
		config = function()
			require("pcfg.marks-nvim")
		end,
	},
	{
		"benlubas/molten-nvim",
		config = function()
			require("pcfg.molten-nvim")
		end,
	},
	{
		"smoka7/multicursors.nvim",
		dependencies = { "nvimtools/hydra.nvim" },
		config = function()
			require("pcfg.multicursors-nvim")
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("pcfg.noice-nvim")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp", "uga-rosa/cmp-dictionary", "kdheepak/cmp-latex-symbols", "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
		config = function()
			require("pcfg.nvim-cmp")
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("pcfg.nvim-colorizer-lua")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "b0o/SchemaStore.nvim", "j-hui/fidget.nvim" },
		config = function()
			require("pcfg.nvim-lspconfig")
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("pcfg.nvim-spectre")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("pcfg.nvim-tree")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		-- `main` (the default branch). master declares Neovim 0.12 unsupported
		-- and breaks Neovim's treesitter runtime on this version; the config in
		-- pcfg/nvim-treesitter.lua is written against main's API.
		branch = "main",
		config = function()
			require("pcfg.nvim-treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
	},
	{
		"pwntester/octo.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("pcfg.octo-nvim")
		end,
	},
	{
		"nvim-orgmode/orgmode",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		config = function()
			require("pcfg.render-markdown-nvim")
		end,
	},
	{
		"folke/snacks.nvim",
		config = function()
			require("pcfg.snacks-nvim")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim", "nvim-telescope/telescope-frecency.nvim", "nvim-telescope/telescope-live-grep-args.nvim", "nvim-telescope/telescope-project.nvim", "nvim-telescope/telescope-ui-select.nvim" },
		config = function()
			require("pcfg.telescope-nvim")
		end,
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("pcfg.todo-comments-nvim")
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 900,
		config = function()
			require("pcfg.tokyonight-nvim")
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("pcfg.trouble-nvim")
		end,
	},
	{
		"chomosuke/typst-preview.nvim",
		config = function()
			require("pcfg.typst-preview-nvim")
		end,
	},
	{
		-- No config: Rhodium's venn-nvim.lua is a 0-byte file, so it was a no-op
		-- there as well. Chezmoi does not deploy empty files without the `empty_`
		-- attribute, which made the require fail outright.
		"jbyuki/venn.nvim",
	},
	{
		"fatih/vim-go",
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("pcfg.vim-illuminate-nvim")
		end,
	},
	{
		"LnL7/vim-nix",
	},
	{
		"lervag/vimtex",
		config = function()
			require("pcfg.vimtex")
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("pcfg.which-key-nvim")
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		config = function()
			require("pcfg.yazi-nvim")
		end,
	},
	{
		"folke/zen-mode.nvim",
	},
}
