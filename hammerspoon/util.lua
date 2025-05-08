local M = {}

M.hyper = { "ctrl", "alt", "cmd", "shift" }

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

return M
