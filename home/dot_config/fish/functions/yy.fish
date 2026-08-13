function yy --description "Yazi, returning to its last directory"
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
		builtin cd -- "$cwd"
	end
	# `command` so the `rm` alias (trash) cannot swallow the cleanup.
	command rm -f -- "$tmp"
end
