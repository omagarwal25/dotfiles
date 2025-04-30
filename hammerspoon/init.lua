ctrl_table = {
	sends_escape = true,
	last_mods = {},
}

control_key_timer = hs.timer.delayed.new(0.15, function()
	ctrl_table["send_escape"] = false
	-- log.i("timer fired")
	-- control_key_timer:stop()
end)

last_mods = {}

control_handler = function(evt)
	local new_mods = evt:getFlags()
	if last_mods["ctrl"] == new_mods["ctrl"] then
		return false
	end
	if not last_mods["ctrl"] then
		-- log.i("control pressed")
		last_mods = new_mods
		ctrl_table["send_escape"] = true
		-- log.i("starting timer")
		control_key_timer:start()
	else
		-- log.i("contrtol released")
		-- log.i(ctrl_table["send_escape"])
		if ctrl_table["send_escape"] then
			-- log.i("send escape key...")
			hs.eventtap.keyStroke({}, "ESCAPE")
		end
		last_mods = new_mods
		control_key_timer:stop()
	end
	return false
end

control_tap = hs.eventtap.new({ 12 }, control_handler)

control_tap:start()

hs.hotkey.bind({ "cmd", "shift", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")

-- === Sox Toggle Hotkey ===
local soxTask = nil -- Track the running sox task
local initialVolume = nil -- Track the initial volume

local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Function to toggle sox microphone passthrough and adjust volume
local function toggleSoxAndVolume()
	if soxTask and soxTask:isRunning() then
		-- Stop sox
		soxTask:terminate()
		soxTask = nil

		-- Reset volume
		if initialVolume then
			hs.audiodevice.defaultOutputDevice():setVolume(initialVolume)
		end

		hs.alert.show("Sox stopped, volume reset.")
	else
		-- Save initial volume
		initialVolume = hs.audiodevice.defaultOutputDevice():volume()

		-- Set volume to max
		hs.audiodevice.defaultOutputDevice():setVolume(100)

		-- Start sox process with an exit callback
		soxTask = hs.task.new("/opt/homebrew/bin/sox", function(exitCode, stdOut, stdErr)
			hs.alert.show("Sox exited with code: " .. tostring(exitCode))
			soxTask = nil
		end, { "-d", "-d" })

		if soxTask then
			hs.alert.show("ELLO")
			local devnull = io.open("/dev/null", "w")
			soxTask:setStandardOutput(devnull)
			soxTask:setStandardError(devnull)
			hs.alert.show("HELLO")
			soxTask:start()
			hs.alert.show("Sox running, volume maxed.")
		else
			hs.alert.show("Failed to start Sox.")
		end
	end
end

-- Hotkey: Ctrl + Alt + Cmd + Shift + M
hs.hotkey.bind(hyper, "m", toggleSoxAndVolume)
-- Bind Hyper + S to launch Spotify
hs.hotkey.bind(hyper, "s", function()
	hs.application.launchOrFocus("Spotify")
end)

-- Bind Hyper + A to launch Arc
hs.hotkey.bind(hyper, "a", function()
	hs.application.launchOrFocus("Arc")
end)

function runWithDelays(actions, delay)
	local function step(i)
		if i > #actions then
			return
		end
		actions[i]()
		hs.timer.doAfter(delay, function()
			step(i + 1)
		end)
	end
	step(1)
end

hs.hotkey.bind(hyper, "T", function()
	runWithDelays({
		function()
			hs.eventtap.keyStroke(hyper, "A", 0)
		end,
		function()
			hs.eventtap.keyStroke({ "ctrl" }, "2", 0)
		end,
		function()
			hs.eventtap.keyStroke({ "cmd" }, "7", 0)
		end,
		function()
			hs.eventtap.keyStroke({ "alt", "shift" }, "tab", 0)
		end,
	}, 0.2) -- 0.2 second delay between each
end)
