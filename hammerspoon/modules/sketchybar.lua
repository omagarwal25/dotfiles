local util = require("util")
local M = {}

local function handleMonitorChange()
	hs.execute("sketchybar --trigger change-workspace-monitor")
end

function M.set(item, props)
	local cmd = "sketchybar --set " .. item
	for k, v in pairs(props) do
		cmd = cmd .. string.format(" %s='%s'", k, v)
	end
	hs.execute(cmd, true)
end

function M.trigger(event)
	hs.execute("sketchybar --trigger " .. event, true)
end

function M.reload()
	hs.execute("brew services restart sketchybar", true)
end

function M.init()
	local watcher = hs.screen.watcher.new(handleMonitorChange)
	watcher:start()
end

return M

