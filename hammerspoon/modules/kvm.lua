local M = {}

local hubName = "Anker"

local function handleUsb(event)
	local eventType = event.eventType
	local productName = event.productName

	if string.find(productName, hubName) then
		if eventType == "removed" then
			M.stop()
		else
			M.start()
		end
	end
end

function M.start()
	spoon.MenuExtraTrigger:triggerAction("startDeskflow")

	hs.notify.show("Hammerspoon", "", "KVM Started")
end

function M.stop()
	spoon.MenuExtraTrigger:triggerAction("stopDeskflow")

	hs.notify.show("Hammerspoon", "", "KVM Stopped")
end

function M.init()
	spoon.MenuExtraTrigger:registerAction("stopDeskflow", "Deskflow", "Stop")
	spoon.MenuExtraTrigger:registerAction("startDeskflow", "Deskflow", "Start")
end

return M
