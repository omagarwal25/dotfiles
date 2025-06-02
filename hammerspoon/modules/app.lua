local util = require("util")

local M = {}

local function bind(key, appName)
	hs.hotkey.bind(util.hyper, key, function()
		hs.application.launchOrFocus(appName)
	end)
end

function M.init()
	-- Bind Hyper S to spotify
	bind("S", "Spotify")

	bind("Z", "Zen")
end

return M
