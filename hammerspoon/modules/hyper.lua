local M = {}

local hyperActive = false
local releaseTimer = nil

local tap = hs.eventtap.new({
	hs.eventtap.event.types.keyDown,
	hs.eventtap.event.types.keyUp,
}, function(event)
	local keyCode = event:getKeyCode()
	local isDown = event:getType() == hs.eventtap.event.types.keyDown

	if keyCode == hs.keycodes.map["f19"] then
		if isDown then
			if releaseTimer then
				releaseTimer:stop()
				releaseTimer = nil
			end
			hyperActive = true
		else
			-- grace period so R keydown isn't missed if F19 releases first
			releaseTimer = hs.timer.doAfter(0.05, function()
				hyperActive = false
				releaseTimer = nil
			end)
		end
		return true
	end

	if hyperActive and isDown then
		local copy = event:copy()
		copy:setFlags({ ctrl = true, alt = true, cmd = true, shift = true })
		copy:post()
		return true
	end
end)

function M.init()
	tap:start()
end

return M
