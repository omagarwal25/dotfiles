local bar = require("modules.sketchybar")

local M = {}

local caffeine = hs.menubar.new()
local itemName = "caffeine"

local awakeIcon = "􂊭"
local sleepIcon = "􀆾"

local function updateBar(state)
  local icon = state and awakeIcon or sleepIcon
  bar.set(itemName, { label = icon })
end

local function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle(awakeIcon)
    updateBar(true)
  else
    caffeine:setTitle(sleepIcon)
    updateBar(false)
  end
end

function M.toggle()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function M.init()
  if caffeine then
    caffeine:setClickCallback(M.toggle)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
  end
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
