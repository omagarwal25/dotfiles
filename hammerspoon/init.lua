local sox = require("modules.sox")
local bar = require("modules.sketchybar")
local app = require("modules.app")
local tft = require("modules.tft")
local caffeine = require("modules.caffeine")
local network = require("modules.network")
local util = require("util")

require("hs.ipc")

hs.loadSpoon("EmmyLua")

hs.hotkey.bind(util.hyper, "R", function()
	hs.reload()
	bar.reload()
	hs.execute("aerospace reload-config", true)
end)

caffeine.init()
tft.init()
app.init()
sox.init()

-- network.init()

hs.notify.show("Hammerspoon", "", "Hammerspoon reloaded")
