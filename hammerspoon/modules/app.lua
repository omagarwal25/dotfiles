local util = require("util")

local M = {}

function M.init()
	hs.hotkey.bind(util.hyper, "s", function()
		hs.application.launchOrFocus("Spotify")
	end)

	-- Bind Hyper + A to launch Arc
	hs.hotkey.bind(util.hyper, "a", function()
		hs.application.launchOrFocus("Arc")
	end)
end

return M
