local util = require("util")

local M = {}

function M.init()
	hs.hotkey.bind(util.hyper, "T", nil, function()
		local zen = hs.application.find("Zen")
		util.runWithDelays({

			function()
				hs.eventtap.keyStroke(util.hyper, "Z", 0)
			end,
			function()
				hs.eventtap.keyStroke({ "ctrl" }, "2", nil, zen)
			end,
			function()
				hs.eventtap.keyStroke({ "cmd" }, "4", nil, zen)
			end,
			function()
				hs.eventtap.keyStroke({ "cmd", "alt" }, "c", nil, zen)
			end,
			function()
				hs.eventtap.keyStroke({ "alt", "shift" }, "tab", 0)
			end,
		}, 0.2) -- 0.2 second delay between each
	end)
end

return M
