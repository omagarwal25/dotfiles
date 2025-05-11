local util = require("util")
local M = {}

local hubName = "Anker"
local startFn
local stopFn

local function handleUsb(event)
	local eventType = event.eventType
	local productName = event.productName

	if string.find(productName, hubName) then
		if eventType == "removed" then
			if startFn ~= nil then
				startFn()
			end
		else
			if stopFn ~= nil then
				stopFn()
			end
		end
	end
end

--- Adds functions to run when the USB hub is connected
--- @param startFns function[] functions to run when the USB hub is connected
--- @param stopFns function[] functions to run when the USB hub is disconnected
function M.init(startFns, stopFns)
	startFn = util.combineFns(startFns)
	stopFn = util.combineFns(stopFns)

	local systemWatcher = hs.usb.watcher.new(handleUsb)
	systemWatcher:start()
end

return M
