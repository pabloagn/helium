-- --- Variables ---
local opt = vim.opt
local diagnostic = vim.diagnostic

-- Enable filetype detection and plugins
vim.cmd("filetype plugin indent on")

-- Silence deprecation warnings
vim.deprecate = function() end

-- Set theme
-- vim.cmd("colorscheme kanso")

-- Diagnostics
diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "●",
			[vim.diagnostic.severity.HINT] = "●",
			[vim.diagnostic.severity.INFO] = "●",
		},
	},
})

-- --- General ---
opt.clipboard = "unnamedplus" -- Enable system clipboard
opt.encoding = "utf-8" -- Encoding
opt.fileencoding = "utf-8" -- File encoding
opt.hidden = true -- Enable background buffers
opt.history = 10000 -- Remember N lines in history
-- lazyredraw is deliberately left off. Rhodium set it, but noice.nvim checks
-- `vim.go.lazyredraw` in its health module and warns on every startup that it
-- is only meant to be set temporarily and breaks Noice's UI. Both plugins are
-- in this config, so the option has to go rather than the plugin.
-- opt.lazyredraw = true
opt.more = false
opt.mouse = "a" -- Enable mouse support
opt.showmode = false -- We already have this on line
opt.swapfile = false -- Disable swap
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.timeoutlen = 300 -- Faster keymap response
opt.undofile = true
opt.updatetime = 200 -- Better responsiveness
opt.scrolloff = 4 -- Keep 4 lines of context above/below cursor
opt.sidescrolloff = 8 -- Keep horizontal context
-- opt.confirm = true -- Prompt for save before closing modified buffers
opt.completeopt = { "menuone", "noselect", "noinsert" } -- Completion behavior
opt.shortmess:append("c") -- Don't show completion messages
opt.virtualedit = "block" -- Allow cursor anywhere in visual block mode
opt.pumblend = 10 -- Popup menu transparency (requires `termguicolors`)
opt.winblend = 10 -- Floating window transparency

-- --- UI ---
opt.cmdheight = 0 -- Hide command line when not using
opt.termguicolors = true -- 24-bit RGB colors
opt.showmatch = true -- Matching parenthesis
opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

-- Cursor Appearance
opt.guicursor = {
	"n-v-c:block", -- Normal/Visual/Command: block
	"v:block-blinkon0", -- Visual: blink off (some terminals interpret as hollow)
	"i:ver25", -- Insert: vertical bar
	"r-cr:hor20", -- Replace: horizontal bar
	"o:hor50", -- Operator-pending: half-height bar
}

-- Line Numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.fillchars = { eob = " " } -- Remove the trailing tilde on dashboard

-- Statusline
opt.laststatus = 3 -- Always show a single global statusline

-- --- Search ---
opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "split"

-- --- Folding ---
opt.foldmethod = "manual" -- Changed from 'marker' to 'manual' (newer preference)

-- Text wrapping
opt.wrap = true
opt.linebreak = true

-- --- Indentation ---
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true -- Use spaces instead of tabs globally
opt.tabstop = 2 -- Number of spaces for each tab
opt.shiftwidth = 2 -- Number of spaces when shifting text

-- --- Splits ---
opt.splitbelow = true
opt.splitright = true

-- --- Format Options ---
opt.formatoptions:remove("o") -- Don't have `o` add a comment

-- --- Shada (session Data) ---
opt.shada = { "'10", "<0", "s10", "h" }

-- --- Neovide (GUI) ---
-- `vim.g.neovide` exists only inside Neovide, so this whole block is invisible
-- to the terminal Neovim.
--
-- Transparency cannot go in ~/.config/neovide/config.toml. That file only
-- covers what the command line covers: fonts, frame, vsync, tabs. Opacity is a
-- Neovim global, which is why it lives here instead.
if vim.g.neovide then
	-- Two separate knobs, both 0.0 to 1.0:
	--   neovide_opacity        the whole window, frame included
	--   neovide_normal_opacity the Normal highlight background on its own, so
	--                          floats, popups and the statusline keep a solid
	--                          backing and stay readable
	-- Lower either number to see more wallpaper through the window.
	vim.g.neovide_opacity = 0.90
	vim.g.neovide_normal_opacity = 0.90

	-- macOS blur behind the window. This is the same effect as Ghostty's
	-- `background-blur-radius = 20`. The blur level follows neovide_opacity.
	vim.g.neovide_window_blurred = true

	-- g:neovide_background_color was the old way to do this. Neovide removed it
	-- in 0.16.0, and this machine runs 0.16.2, so the two globals above are the
	-- only ones that work now.

	-- Left Option sends Meta, right Option keeps typing accented characters.
	-- Ghostty does the same through `macos-option-as-alt`.
	vim.g.neovide_input_macos_option_key_is_meta = "only_left"

	-- Animations, shortened from the 0.150 and 0.3 second defaults. Long enough
	-- to read as motion, short enough not to lag behind fast movement.
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_scroll_animation_length = 0.2

	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_remember_window_size = true
end
