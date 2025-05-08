local util = require("util")

local M = {}

-- Function to check if SoX daemon is running
local function isSoxRunning()
	local output, status, type, rc = hs.execute("launchctl list | grep me.omagarwal.sox.passthrough")

	-- If there's no output, the service isn't loaded at all
	if output == nil or output == "" then
		return false
	end

	-- Check if the first field has a PID (not a dash)
	local firstField = output:match("^(%S+)")
	if firstField == "-" then
		-- Service is loaded but not running
		return false
	else
		-- Service is running with a PID
		return true
	end
end

-- Function to start the SoX daemon
local function startSoxDaemon()
	if not isSoxRunning() then
		hs.execute("launchctl start me.omagarwal.sox.passthrough")
		return true
	else
		return false
	end
end

-- Function to stop the SoX daemon
local function stopSoxDaemon()
	if isSoxRunning() then
		hs.execute("launchctl stop me.omagarwal.sox.passthrough")
		return true
	else
		return false
	end
end

local initialVolume = nil -- Track the initial volume

local function start()
	-- Save initial volume
	initialVolume = hs.audiodevice.defaultOutputDevice():volume()

	-- Set volume to max
	hs.audiodevice.defaultOutputDevice():setVolume(100)

	-- Start sox process with an exit callback
	startSoxDaemon()

	hs.notify.show("Hammerspoon", "", "Sox started")
end

local function stop()
	-- Stop sox
	stopSoxDaemon()

	-- Reset volume
	if initialVolume then
		hs.audiodevice.defaultOutputDevice():setVolume(initialVolume)
	end

	hs.notify.show("Hammerspoon", "", "Sox stopped, volume reset.")
end

-- Function to toggle sox microphone passthrough and adjust volume
local function toggleSoxAndVolume()
	if isSoxRunning() then
		stop()
	else
		start()
	end
end

local function watcherCallback(event)
	if event == "dOut" and isSoxRunning() then
		stop()
	end
end

function M.init()
	hs.hotkey.bind(util.hyper, "m", toggleSoxAndVolume)
	hs.audiodevice.watcher.setCallback(watcherCallback)
	hs.audiodevice.watcher.start()
end

return M
