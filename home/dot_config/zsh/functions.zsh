# `yy` opens Yazi and leaves the shell in whatever directory Yazi exited from.
# It is named `yy` (not `y`) because `y` is the clipboard yank alias, matching
# Rhodium: there, `y = wl-copy` and `lf = yy`.
function yy() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

function mkcd() {
  command mkdir -p "$1" && cd "$1"
}

function fe() {
  local file
  file="$(fzf --preview 'bat --color=always --line-range=:200 {}')" && "$EDITOR" "$file"
}

function fb() {
  local branch
  branch="$(git branch --all | grep -v HEAD | fzf | sed 's/^[* ] //;s#remotes/[^/]*/##')" && git switch "$branch"
}
