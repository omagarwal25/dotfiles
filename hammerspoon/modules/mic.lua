local bar = require("modules.sketchybar")

local M = {}

local timeSinceMute = 0
local watcher
local itemName = "mic"

local mutedIcon = "􀊲"
local notMutedIcon = "􀊰"

local function setBar(state)
	if state == "off" then
		bar.set(itemName, { ["drawing"] = "off" })

		return
	end

	local icon = (state == "muted") and mutedIcon or notMutedIcon

	bar.set(itemName, { ["drawing"] = "on" })
	bar.set(itemName, { label = icon })
end

local function updateBar()
	local status = hs.audiodevice.defaultInputDevice():muted()

	if not status and hs.audiodevice.defaultInputDevice():inUse() == false then
		setBar("off")
		return
	end

	setBar(status == true and "muted" or "unmuted")
end

function M.toggle()
	local mic = hs.audiodevice.defaultInputDevice()
	-- local zoom = hs.application("Zoom")
	-- local teams = hs.application.find("com.microsoft.teams")
	if mic == nil then
		return
	end

	if mic:muted() then
		mic:setInputMuted(false)

		-- if zoom then
		-- 	local ok = zoom:selectMenuItem("Unmute Audio")
		-- 	if not ok then
		-- 		hs.timer.doAfter(0.5, function()
		-- 			zoom:selectMenuItem("Unmute Audio")
		-- 		end)
		-- 	end
		-- end
		-- if teams then
		-- 	local ok = teams:selectMenuItem("Unmute")
		-- 	if not ok then
		-- 		hs.timer.doAfter(0.5, function()
		-- 			hs.eventtap.keyStroke({
		-- 				"cmd",
		-- 				"shift",
		-- 			}, "m", 0, teams)
		-- 		end)
		-- 	end
		-- end
	else
		mic:setInputMuted(true)

		-- if zoom then
		-- 	local ok = zoom:selectMenuItem("Mute Audio")
		-- 	if not ok then
		-- 		hs.timer.doAfter(0.5, function()
		-- 			zoom:selectMenuItem("Mute Audio")
		-- 		end)
		-- 	end
		-- end
		-- if teams then
		-- 	local ok = teams:selectMenuItem("Mute")
		-- 	if not ok then
		-- 		hs.timer.doAfter(0.5, function()
		-- 			hs.eventtap.keyStroke({
		-- 				"cmd",
		-- 				"shift",
		-- 			}, "m", 0, teams)
		-- 		end)
		-- 	end
		-- end
	end

	updateBar()
end

local function bindHotkeys(mapping, timeout)
	local mods = mapping[1]
	local key = mapping[2]

	if timeout then
		hs.hotkey.bind(mods, key, function()
			M.toggle()
			timeSinceMute = hs.timer.secondsSinceEpoch()
		end, function()
			if hs.timer.secondsSinceEpoch() > timeSinceMute + timeout then
				M.toggle()
			end
		end)
	else
		hs.hotkey.bind(mods, key, function()
			M.toggle()
		end)
	end
end

function M.watcherCallback(event)
	if event == "dOut" or event == "dIn" then
		switchWatcher()
		updateBar()
	end
end

local function deviceWatcherCallback(uid, event, scope, channel)
	if event == "gone" then
		updateBar()
	end
end

local function switchWatcher()
	if watcher then
		watcher:watcherStop()
		watcher = nil
	end

	watcher = hs.audiodevice.defaultInputDevice():watcherCallback(deviceWatcherCallback)
	watcher:watcherStart()
end

function M.init()
	timeSinceMute = 0
	switchWatcher()
	updateBar()

	bindHotkeys({ {}, "f20" }, 0.5)
end

return M
