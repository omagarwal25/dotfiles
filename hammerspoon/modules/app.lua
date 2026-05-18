local util = require("util")

local M = {}

local hyperApps = {
	S = "Spotify",
	Z = "Zen",
}

function M.init()
	for key, appName in pairs(hyperApps) do
		hs.hotkey.bind(util.hyper, key, function()
			hs.application.launchOrFocus(appName)
		end)
	end
end

return M
