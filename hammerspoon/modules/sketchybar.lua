local M = {}

function M.set(item, props)
  local cmd = "sketchybar --set " .. item
  for k, v in pairs(props) do
    cmd = cmd .. string.format(" %s='%s'", k, v)
  end
  hs.execute(cmd, true)
end

function M.trigger(event)
  hs.execute("sketchybar --trigger " .. event, true)
end

return M
