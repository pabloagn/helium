# Ported from the Rhodium (NixOS) alias set, adapted to macOS. Anything that
# depended on Linux-only tooling is dropped rather than silently broken:
# trash-put, plocate, procs, gping, dog, fastfetch, qalc, free, ip -c, wl-copy,
# niri, and the GNU --preserve-root variants (BSD chmod/chown reject them).

# --- Clipboard ---
alias y='pbcopy'                     # Yank: `pwd | y`
alias p='pbpaste'
alias c='pbcopy'                     # Kept as the older Helium spelling

# --- View ---
alias cat='bat --paging=never'
alias rcat='/bin/cat'
alias cata='cat * | y'               # Cat all and yank

# --- File managers ---
alias lf='yy'                        # Yazi, returning to its last directory

# --- List ---
alias ls='eza --group-directories-first --icons'
alias ll='eza -lh --group-directories-first --icons --git'
alias la='eza -lah --group-directories-first --icons --git'
alias llc='eza -1'
alias lac='eza -1a'
alias lli='eza --icons -l'
alias lai='eza --icons -la'
alias lt='eza --tree --level=2 --icons'
alias l2='eza --icons -l -T -L=2'
alias l3='eza --icons -l -T -L=3'
alias llt='eza -T'
alias lat='eza -Ta'
alias lat1='eza -Ta -L=1'
alias lat2='eza -Ta -L=2'
alias lat3='eza -Ta -L=3'
alias llty='eza -T | pbcopy'
alias laty='eza -Ta | pbcopy'

# --- Navigation ---
# `cd` is already zoxide (see .zshrc: zoxide init --cmd cd).
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# --- Jumpers ---
# These mirror the Yazi `g` keymap exactly, so one mental model covers both.
alias gg='cd ~'
alias gd='cd ~/Downloads'
alias gp='cd ~/personal'
alias ga='cd ~/atmospheric-ai'
alias gr='cd ~/personal/rhodium'
alias gh='cd ~/personal/helium'
alias gc='cd ~/.config'
alias gb='cd ~/.local/bin'
alias gi='cdi'                       # Zoxide interactive

# --- Openers: jump, then list in Yazi ---
alias ggl='cd ~ && yy'
alias gdl='cd ~/Downloads && yy'
alias gpl='cd ~/personal && yy'
alias gal='cd ~/atmospheric-ai && yy'
alias grl='cd ~/personal/rhodium && yy'
alias ghl='cd ~/personal/helium && yy'
alias gcl='cd ~/.config && yy'

# --- Git ---
# Two-and-three letter names, so they never collide with the jumpers above.
alias g='git'
alias gad='git add .'
alias gst='git status'
alias gss='git status -sb'
alias gdf='git diff'
alias glg='git log --oneline --graph --decorate -20'
alias gpu='git push -u origin main'
alias grm='git rm -rf --cached .'
alias lg='lazygit'

# --- Commitizen ---
alias gcm='cz commit'
alias gbp='cz bump'
alias gch='cz changelog'
alias gck='cz check'
alias gin='cz init'
alias gvr='cz version'

# --- Editor ---
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# --- Docker ---
alias d='docker'
alias dc='docker compose'
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# --- Archives ---
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarxz='tar -xJvf'

# --- Disk and process ---
alias du='dust'
alias df='duf'
alias htop='btm'

# --- Safety nets ---
alias rm='trash'                     # macOS /usr/bin/trash, not an rm wrapper
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# --- Search and inspection ---
alias fda='fd -Lu'                   # Find all, including hidden and ignored
alias hs='history | rg'
alias hsi='history | rg -i'
alias sa='alias | fzf'               # See aliases
alias sv='env | sort | fzf'          # See environment variables

# --- Network ---
alias myip='curl -s ifconfig.me'

# --- Time savers ---
alias now="date +'%Y-%m-%d %H:%M:%S'"
alias week='date +%V'

# --- General ---
alias cl='clear'
alias zj='zellij'
alias reload='exec zsh -l'
alias path='echo $PATH | tr ":" "\n"'
alias zshrc='nvim ~/.zshrc'
