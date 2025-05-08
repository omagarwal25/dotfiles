local sox = require("modules.sox")
local app = require("modules.app")
local tft = require("modules.tft")
local caffeine = require("modules.caffeine")
local util = require("util")

require("hs.ipc")

hs.loadSpoon("EmmyLua")

hs.hotkey.bind(util.hyper, "R", function()
	hs.reload()
end)

caffeine.init()
tft.init()
app.init()
sox.init()

hs.notify.show("Hammerspoon", "", "Hammerspoon reloaded")
