# Editors

Neovim and Helix are both ported from Rhodium. The configuration itself is
Rhodium's, unchanged wherever it was portable; this document records only the
places where macOS forced a difference, so the two repositories stay comparable.

## Neovim

### What changed structurally

Nix was Rhodium's plugin manager. It installed every plugin from `pkgs.vimPlugins`
and injected each one's Lua through the module's `config` attribute, so every
plugin was present the moment Neovim started, and `init.lua` only had to
`require` five core files.

There is no Nix here, so **lazy.nvim** takes that role:

| Rhodium | Helium |
| --- | --- |
| `pkgs.vimPlugins.<name>` in six `.nix` modules | `lua/plugins.lua`, one spec per plugin |
| `config = sourceLuaFile "x.lua"` | `config = function() require("pcfg.x") end` |
| all plugins present at startup | `defaults = { lazy = false }` reproduces that |
| ~300 tree-sitter grammars pre-built | 42-language core set, compiled locally |

61 plugins were ported: 42 top-level specs plus 19 that only ever appear as
another plugin's dependency. Every repository was verified to resolve with
`git ls-remote` rather than guessed from its nixpkgs attribute name — those names
carry no owner, so `flash-nvim` could just as easily have been anyone's fork.

`kanso.nvim` is your own repository, `pabloagn/kanso.nvim`, which Rhodium
consumed as a flake input and built with `buildVimPlugin`. It loads at
`priority = 1000` because its config calls `colorscheme kanso`.

### tree-sitter: the one config that had to be rewritten

Rhodium used nvim-treesitter's **`master`** branch API (`nvim-treesitter.configs`),
which is what nixpkgs ships. That branch states outright that **Neovim 0.12 is not
supported**, and this machine runs 0.12.4 — keeping it produced
`attempt to call method 'range' (a nil value)` from Neovim's own treesitter
runtime on every redraw, which also took down render-markdown and
treesitter-context.

`lua/pcfg/nvim-treesitter.lua` is therefore the only config not copied verbatim.
It targets the **`main`** branch, which has no `configs` module: highlighting and
indentation are enabled per buffer from a `FileType` autocmd instead. The two
things Rhodium asked for — `highlight` and `indent` — are preserved.

Note the install location differs too: `main` installs parsers under
`stdpath("data")/site`, not into the plugin directory.

### Layout

```
~/.config/nvim/
  init.lua              lazy bootstrap, then the same five requires as Rhodium
  lua/filters.lua       ─┐
  lua/functions.lua      │ copied verbatim; the flat layout is required because
  lua/main.lua           │ keybinds.lua and several plugin configs call
  lua/keybinds.lua       │ require("functions")
  lua/ftdetect.lua      ─┘
  lua/plugins.lua       generated lazy.nvim spec
  lua/pcfg/*.lua        33 per-plugin configs, verbatim from Rhodium
  ftplugin/*.lua        6 filetype files, verbatim
```

Load order is deliberate: `filters`, `functions` and `main` run *before*
`lazy.setup` so `require("functions")` resolves for plugin configs that call into
it, and `keybinds` runs *after*, because it references plugin commands.

### macOS adaptations

Only four, all in otherwise-verbatim files:

| File | Rhodium | Helium |
| --- | --- | --- |
| `lua/functions.lua` | `kitty -- nvim '%s' &` | `open -na Ghostty.app --args -e nvim '%s'` |
| `ftplugin/markdown.lua` | `:!zathura %:r.pdf &` | `:!open -a Preview %:r.pdf` |
| `lua/pcfg/vimtex.lua` | `vimtex_view_method = "zathura"` | `"general"` + `open -a Preview` |
| `lua/pcfg/typst-preview-nvim.lua` | `firefox --new-window -P Ultra %s` | `$HOME/.local/bin/ff-personal %s` |

Three further corrections were forced by upstream drift since Rhodium pinned
these plugins:

| Item | Problem | Fix |
| --- | --- | --- |
| `nvim-colorizer-lua` | nixpkgs' attribute is the **NvChad** fork, not norcalli's; the ported config uses `user_default_options` and `mode = "virtualtext"`, which only exist in the fork | repo set to `NvChad/nvim-colorizer.lua` |
| `octo-nvim` | `file_panel.use_icons` was removed upstream | renamed to `file_panel.icons` |
| `venn-nvim` | its Rhodium config is a 0-byte file, and Chezmoi does not deploy empty files without the `empty_` attribute, so the `require` failed | spec carries no config, matching the no-op it always was |

Leaders are set in `init.lua` before `lazy.setup`. lazy requires this; setting
them only in `keybinds.lua` (which runs last) is too late and makes plugin
mappings bind against the wrong key.

### How this was verified

`nvim --headless +qa` is not a test. It never renders a buffer, so treesitter
highlighting and decoration providers never run, and lazy.nvim delivers config
failures through `vim.notify`, which headless discards. A config can be badly
broken and still exit 0.

The audit harness used here instead installs a `vim.notify` shim, opens real
buffers of several filetypes, forces `redraw!`, and then reports every plugin
whose `config` actually threw plus any error reaching `:messages`. Every fault
listed above was found that way, not by reading the files.

### Deliberately not ported

`cmp-nixpkgs-maintainers` completes nixpkgs maintainer names and is meaningless
without Nix. Rhodium also carries 14 plugin configs whose entries are commented
out in its own modules — `flash-nvim.lua`, `zen-mode-nvim.lua`,
`tiny-inline-diagnostic-nvim.lua`, `catppuccin-nvim.lua`, `image-nvim.lua`,
`mini-nvim.lua` and others. Those plugins are installed where Rhodium installs
them, but their configs stay disabled, exactly as there.

### Language servers

`lua/pcfg/nvim-lspconfig.lua` configures roughly 60 servers through
`vim.lsp.config` + `vim.lsp.enable` (Neovim 0.11+). Rhodium installed the
binaries with Nix; here most are absent, which is safe — a server with no binary
simply never attaches. Install any with Homebrew and it starts working with no
config change.

## Helix

A direct translation, since Helix is configured in plain TOML:

| Helium file | Rhodium source |
| --- | --- |
| `~/.config/helix/config.toml` | `settings.nix` |
| `~/.config/helix/themes/chiaroscuro.toml` | `themes.nix` |
| `~/.config/helix/languages.toml` | `languages.nix` — 55 servers, 58 languages |

### macOS adaptations

| Setting | Rhodium | Helium |
| --- | --- | --- |
| `clipboard-provider` | `"wayland"` | `"pasteboard"` |
| `editor.evil` | `true` | removed |

`editor.evil` is an `evil-helix` option. Rhodium ran that fork; this machine runs
upstream Helix, which rejects the unknown key outright. To get those bindings
back, install `evil-helix` and restore the line.

## Validation

```sh
just doctor
```

For Neovim specifically, this is the useful pair — the first reports any plugin
that failed to install or load, the second surfaces broken health checks:

```sh
nvim --headless "+checkhealth lazy" +qa
```

```sh
nvim --headless "+Lazy! check" +qa
```
