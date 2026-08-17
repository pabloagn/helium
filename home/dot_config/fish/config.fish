set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx BAT_THEME ansi

fish_add_path /opt/homebrew/bin
fish_add_path "$HOME/.local/bin"

if status is-interactive
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
