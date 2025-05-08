local util = require("util")

hs.hotkey.bind(util.hyper, "s", function()
  hs.application.launchOrFocus("Spotify")
end)

-- Bind Hyper + A to launch Arc
hs.hotkey.bind(util.hyper, "a", function()
  hs.application.launchOrFocus("Arc")
end)
