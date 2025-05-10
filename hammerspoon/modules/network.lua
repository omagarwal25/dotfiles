local M = {}

local ethernetInterface = "AX88179A"

local function isEthernetConnected()
  local ipv4 = hs.network.primaryInterfaces()
  local activeInterfaceName = hs.network.interfaceName(ipv4)

  return activeInterfaceName == ethernetInterface
end

local function toggleWifi()
  local desiredState = not isEthernetConnected() and true or false

  if hs.wifi.interfaceDetails()["power"] ~= desiredState then
    hs.wifi.setPower(desiredState)

    local newState = desiredState and "on" or "off"
    hs.notify.show("Hammerspoon", "", "Turning wifi " .. newState)
  end
end

local function handleWifi(event)
  hs.timer.doAfter(10, toggleWifi)
end

function M.init()
  local systemWatcher = hs.usb.watcher.new(handleWifi)
  systemWatcher:start()
end

return M
