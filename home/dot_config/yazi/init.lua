-- Seven of the installed plugins require an explicit setup() call to
-- initialise their state. Omitting one does not disable it quietly: the plugin
-- still runs and then fails at use time. duckdb in particular threw
-- "attempt to concatenate a nil value" on every peek because its options table
-- had never been populated.

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

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
