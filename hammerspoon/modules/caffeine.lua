local bar = require("modules.sketchybar")
local util = require("util")

local M = {}

local itemName = "caffeine"

local awakeIcon = "􂊭"
local sleepIcon = "􀆾"

local function updateBar(state)
	local icon = state and awakeIcon or sleepIcon
	bar.set(itemName, { label = icon })
end

local function setCaffeineDisplay(state)
	if state then
		updateBar(true)
	else
		updateBar(false)
	end
end

function M.toggle()
	setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function M.init()
	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))

	hs.hotkey.bind(util.hyper, "c", M.toggle)

	local screenWatcher = hs.screen.watcher.new(M.caffieneOff)
	screenWatcher:start()
end

function M.caffieneOn()
	hs.caffeinate.set("displayIdle", true, true)

	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

function M.caffieneOff()
	hs.caffeinate.set("displayIdle", false, true)

	setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

return M
