require("modules.sox")
require("modules.app")
require("modules.tft")
local caffeine = require("modules.caffeine")

local util = require("util")

require("hs.ipc")

hs.loadSpoon("EmmyLua")

hs.hotkey.bind(util.hyper, "R", function()
	hs.reload()
end)

caffeine.init()

hs.notify.show("Hammerspoon", "", "Hammerspoon reloaded")
