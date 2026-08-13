-- Ported from the Rhodium (NixOS) Neovim configuration.
--
-- The one structural difference: Nix was Rhodium's plugin manager. It installed
-- every plugin and injected each one's Lua config, so nothing needed bootstrapping
-- at runtime. There is no Nix here, so lazy.nvim takes that role. Plugin configs
-- themselves are the Rhodium files, unchanged apart from four macOS fixes noted
-- in docs/editors.md.
--
-- Load order matters: filters/functions/main run before lazy so that
-- require("functions") resolves for plugin configs that call into it, and
-- keybinds runs after, since it references plugin commands.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim requires the leaders to be set before it loads, otherwise any
-- mapping a plugin spec defines binds against the wrong key. keybinds.lua sets
-- these too (it runs last, after plugins exist), but they must exist by now.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("filters")
require("functions")
require("main")

require("lazy").setup("plugins", {
	-- Rhodium had every plugin present at startup; keep that behaviour rather
	-- than introducing lazy-loading that the ported configs never expected.
	defaults = { lazy = false },
	install = { colorscheme = { "kanso", "habamax" } },
	change_detection = { notify = false },
	rocks = { enabled = false },
})

require("keybinds")
require("ftdetect")
