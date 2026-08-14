-- Seven of the installed plugins require an explicit setup() call to
-- initialise their state. Omitting one does not disable it quietly: the plugin
-- still runs and then fails at use time. duckdb in particular threw
-- "attempt to concatenate a nil value" on every peek because its options table
-- had never been populated.

-- Cross-instance yank. Yazi instances talk over DDS (a local pub/sub socket),
-- but sharing the yank register is opt-in: without this, yanking in one
-- terminal's Yazi is invisible to another. `session` is a bundled preset
-- plugin, so nothing needs installing.
--
-- The yank is published as `@yank`, a *static* message, which Yazi persists and
-- restores for new instances -- so a yank also survives quitting and reopening.
require("session"):setup({ sync_yanked = true })

require("full-border"):setup({ type = ui.Border.ROUNDED })

require("git"):setup({ order = 1500 })

require("smart-enter"):setup({ open_multi = true })

require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
})

require("projects"):setup({
	save = { method = "yazi",-- persist tabs, not just cwd
	},
	notify = { enable = true, title = "Projects" },
})

require("restore"):setup({
	position = { "center", w = 70, h = 40 },
	show_confirm = true,
})

-- duckdb backs every tabular preview. "summarized" shows column types, null
-- percentages and ranges; press K to toggle to the raw rows.
require("duckdb"):setup({
	mode = "summarized",
	minmax_column_width = 21,
	row_id = false,
	column_fit_factor = 10,
	cache_size = 500,
})

-- Keep the tab bar visible even when only one tab is open.
function Tabs.height()
	return 1
end

-- Fixed-width columns. Yazi composes the linemode from ordered children: this
-- one renders first, then git.yazi's status sign at order 1500 with a single
-- leading space. If this returns a variable-width string, every column to the
-- right ragged-shifts per row -- which is why size, mtime and the git sign all
-- ran together. Padding both fields to a constant width keeps mtime and the git
-- sign in the same screen column on every line.
local SIZE_W = 7 -- ya.readable_size divides while size > 1024, so the widest
                 -- possible output is "1023.9K" -- seven characters.
local TIME_W = 12 -- "Aug 13 17:54" and "Aug 13  2024" are both 12

function Linemode:size_and_mtime()
	local size = self._file:size()
	local s = "-"
	if size then
		s = ya.readable_size(size)
	end

	local time = math.floor(self._file.cha.mtime or 0)
	local t = ""
	if time > 0 then
		if os.date("%Y", time) == os.date("%Y") then
			t = os.date("%b %d %H:%M", time)
		else
			t = os.date("%b %d  %Y", time)
		end
	end

	-- Right-align the size, left-pad the date to a constant width, and keep a
	-- trailing space so git's sign never touches the date.
	return string.format("%" .. SIZE_W .. "s  %-" .. TIME_W .. "s ", s, t)
end
