--- @description: Utility functions for Hammerspoon
--- @module util
local M = {}

--- Hyper key combination
--- @type string[]
M.hyper = { "ctrl", "alt", "cmd", "shift" }

--- runs fns with a delay
--- @param actions table of functions
--- @param delay number delay in seconds
function M.runWithDelays(actions, delay)
	local function step(i)
		if i > #actions then
			return
		end
		actions[i]()
		hs.timer.doAfter(delay, function()
			step(i + 1)
		end)
	end
	step(1)
end

--- combines multiple functions into one
--- @param fnTable table of functions
--- @return function a function that calls all functions in the table
--- 					:
function M.combineFns(fnTable)
	return function(...)
		for _, fn in ipairs(fnTable) do
			fn(...)
		end
	end
end

return M
