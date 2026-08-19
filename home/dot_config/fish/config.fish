set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx BAT_THEME ansi
# Silence direnv's per-load "export +VAR ..." dump. Mirrors the same line in
# ~/.zshrc; direnv reads this on every load, so an empty format hides all of it.
set -gx DIRENV_LOG_FORMAT ""
# Silence Homebrew's "Adjust how often this is run..." and "Hide these hints"
# banners. Mirrors the same export in ~/.zshrc.
set -gx HOMEBREW_NO_ENV_HINTS 1

fish_add_path /opt/homebrew/bin
fish_add_path "$HOME/.local/bin"

if status is-interactive
	# --- SHLVL rebase ---
	# Same rebase as ~/.zshrc: macOS wrapper shells inflate SHLVL, so the
	# first interactive shell of a terminal resets it to 1 and nested
	# shells count from there.
	if not set -q HELIUM_SHLVL_BASE
		set -gx HELIUM_SHLVL_BASE $SHLVL
		set -gx SHLVL 1
	end

	# --- Vi mode ---
	# fish_hybrid_key_bindings is a function fish ships: vi bindings in normal
	# mode, plus the emacs editing keys in insert mode. Setting the variable is
	# the documented way to make it stick; fish has a handler on
	# fish_key_bindings that applies the change straight away.
	# This must come before `atuin init fish` below. Atuin only adds its insert
	# mode Ctrl-r binding when `bind -M insert` already works, and that needs vi
	# mode to be active first.
	set -g fish_key_bindings fish_hybrid_key_bindings

	# The cursor shows the mode. Shapes are block, line or underscore; append
	# " blink" to any of them for a blinking cursor. Fish's own [N]/[I] mode
	# indicator needs no override here: `starship init fish` below already runs
	# `functions -e fish_mode_prompt`, and starship's `character` module prints
	# the mode instead, as ❯ for insert and ❮ for normal, replace and visual.
	# Insert mode used "line", which draws a one-pixel sliver that is hard to
	# find on a dark background. "underscore" is the full width of the cell, so
	# it stays visible and is still clearly not the normal-mode block.
	set -g fish_cursor_default block
	set -g fish_cursor_insert underscore
	set -g fish_cursor_visual block
	set -g fish_cursor_replace underscore
	set -g fish_cursor_replace_one underscore
	set -g fish_cursor_external underscore

	# --- System clipboard ---
	# fish's vi mode yanks into fish's own kill ring, which never reaches macOS.
	# fish ships fish_clipboard_copy and fish_clipboard_paste, which go through
	# pbcopy and pbpaste, and it already binds them behind vim's register syntax:
	# "+yy to copy a line, "+p to paste, ctrl-v to paste anywhere. That is four
	# keystrokes for something done constantly, so the common paths are rebound
	# onto the bare keys below.
	#
	# Normal-mode `y` is deliberately NOT rebound. There it is the yank operator,
	# and taking it over would break yw, ye and y$. Those still yank into fish's
	# kill ring only; use "+yw when the system clipboard is the target.
	# In visual mode `y` is not an operator, so rebinding it there is safe.
	#
	# fish_clipboard_copy copies the selection, or the whole command line when
	# nothing is selected. That covers both visual y and normal-mode Y.
	function fish_user_key_bindings
		bind -M default Y fish_clipboard_copy
		bind -M default p fish_clipboard_paste
		bind -M default P fish_clipboard_paste
		bind -M visual -m default y fish_clipboard_copy end-selection repaint-mode
		bind -M visual p fish_clipboard_paste
		bind -M visual P fish_clipboard_paste
	end

	# --- Starship command timer ---
	# These set STARSHIP_CUSTOM_START/END for [custom.times] in starship.toml.
	# Sourced explicitly because fish only autoloads a function when it is
	# called by name, and --on-event handlers are never called by name.
	# Verbatim copies of Rhodium's files; they need gdate from coreutils.
	if command -q gdate
		source ~/.config/fish/functions/__starship_start_timer.fish
		source ~/.config/fish/functions/__starship_end_timer.fish
	end

	starship init fish | source
	zoxide init fish --cmd cd | source
	atuin init fish --disable-up-arrow | source
	direnv hook fish | source
end

# Aliases mirror ~/.config/zsh/aliases.zsh one-for-one; see that file for the
# notes on what was dropped from the Rhodium set as Linux-only.

# --- Clipboard ---
alias y pbcopy
alias p pbpaste
alias c pbcopy

# --- View ---
alias cat 'bat --paging=never'
alias rcat /bin/cat
alias cata 'cat * | y'

# --- File managers ---
alias lf yy

# --- List ---
alias ls 'eza --group-directories-first --icons=auto'
alias ll 'eza -lh --group-directories-first --icons=auto --git'
alias la 'eza -lah --group-directories-first --icons=auto --git'
alias llc 'eza -1'
alias lac 'eza -1a'
alias lli 'eza --icons=auto -l'
alias lai 'eza --icons=auto -la'
alias lt 'eza --tree --level=2 --icons=auto'
alias l2 'eza --icons=auto -l -T -L=2'
alias l3 'eza --icons=auto -l -T -L=3'
alias llt 'eza -T'
alias lat 'eza -Ta'
alias llty 'eza -T | pbcopy'
alias laty 'eza -Ta | pbcopy'

# --- Jumpers (mirror the Yazi `g` keymap) ---
alias gg 'cd ~'
alias gd 'cd ~/Downloads'
alias gp 'cd ~/personal'
alias ga 'cd ~/atmospheric-ai'
alias gr 'cd ~/personal/rhodium'
alias gh 'cd ~/personal/helium'
alias gc 'cd ~/.config'
alias gb 'cd ~/.local/bin'
alias gi cdi

# --- Openers: jump, then list in Yazi ---
alias ggl 'cd ~ && yy'
alias gdl 'cd ~/Downloads && yy'
alias gpl 'cd ~/personal && yy'
alias gal 'cd ~/atmospheric-ai && yy'
alias grl 'cd ~/personal/rhodium && yy'
alias ghl 'cd ~/personal/helium && yy'
alias gcl 'cd ~/.config && yy'

# --- Git ---
alias g git
alias gad 'git add .'
alias gst 'git status'
alias gss 'git status -sb'
alias gdf 'git diff'
alias glg 'git log --oneline --graph --decorate -20'
alias gpu 'git push -u origin main'
alias grm 'git rm -rf --cached .'
alias lg lazygit

# --- Commitizen ---
alias gcm 'cz commit'
alias gbp 'cz bump'
alias gch 'cz changelog'
alias gck 'cz check'
alias gin 'cz init'
alias gvr 'cz version'

# --- Editor ---
alias vim nvim
alias vi nvim
alias v nvim

# --- Docker ---
alias d docker
alias dc 'docker compose'

# --- Archives ---
alias untar 'tar -xvf'
alias untargz 'tar -xzvf'
alias untarxz 'tar -xJvf'

# --- Disk and process ---
alias du dust
alias df duf
alias htop btm

# --- Safety nets ---
alias rm trash
alias cp 'cp -iv'
alias mv 'mv -iv'
alias mkdir 'mkdir -pv'

# --- Search and inspection ---
alias fda 'fd -Lu'
alias sa 'alias | fzf'
alias sv 'env | sort | fzf'

# --- Network ---
alias myip 'curl -s ifconfig.me'

# --- General ---
alias cl clear
alias zj zellij
alias path 'echo $PATH | tr ":" "\n"'
