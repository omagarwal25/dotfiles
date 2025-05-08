local util = require("util")

hs.hotkey.bind(util.hyper, "T", function()
  util.runWithDelays({
    function()
      hs.eventtap.keyStroke(util.hyper, "A", 0)
    end,
    function()
      hs.eventtap.keyStroke({ "ctrl" }, "2", 0)
    end,
    function()
      hs.eventtap.keyStroke({ "cmd" }, "7", 0)
    end,
    function()
      hs.eventtap.keyStroke({ "cmd" }, "s", 0)
    end,
    function()
      hs.eventtap.keyStroke({ "alt", "shift" }, "tab", 0)
    end,
  }, 0.2) -- 0.2 second delay between each
end)
