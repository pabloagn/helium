use framework "AppKit"
use scripting additions

-- Select Work by its main process, never by the shared Claude bundle ID.
set workPID to do shell script "/bin/ps -axo pid=,command= | /usr/bin/awk -v data=\"$HOME/Library/Application Support/Claude\" '$2 == \"/Applications/Claude.app/Contents/MacOS/Claude\" { command = substr($0, index($0, $2)); if (!found && (command == $2 || command == $2 \" --user-data-dir=\" data)) found = $1 } END { if (found) print found }'"
if workPID is not "" then
	set workApp to current application's NSRunningApplication's runningApplicationWithProcessIdentifier:(workPID as integer)
	set didActivate to workApp's activateWithOptions:3
	if didActivate as boolean then return
end if

do shell script "/usr/bin/open -n -a /Applications/Claude.app --args --user-data-dir=\"$HOME/Library/Application Support/Claude\""
