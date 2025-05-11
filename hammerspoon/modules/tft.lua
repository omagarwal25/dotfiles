local util = require("util")

local M = {}

function M.init()
	hs.hotkey.bind(util.hyper, "T", nil, function()
		local arc = hs.application.find("Arc")
		util.runWithDelays({

			function()
				hs.eventtap.keyStroke(util.hyper, "A", 0)
			end,
			function()
				hs.eventtap.keyStroke({ "ctrl" }, "2", nil, arc)
			end,
			function()
				hs.eventtap.keyStroke({ "cmd" }, "7", nil, arc)
			end,
			function()
				hs.eventtap.keyStroke({ "cmd" }, "s", nil, arc)
			end,
			function()
				hs.eventtap.keyStroke({ "alt", "shift" }, "tab", 0)
			end,
		}, 0.2) -- 0.2 second delay between each
	end)
end

return M
