local obj = {}
obj.__index = obj

obj.name = "MenuExtraTrigger"
obj.version = "1.0"
obj.author = "Ste"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Configuration table: key = action name, value = { app = ..., menuItem = ... }
obj.actions = {}

local ax = hs.axuielement

--- obj:triggerAction(actionName)
--- Method
--- Triggers the configured menu item for the given action
function obj:triggerAction(actionName)
  local config = self.actions[actionName]
  if not config then
    hs.alert.show("No config for action: " .. actionName)
    return
  end

  local appName = config.app
  local menuTitle = config.menuItem

  for _, app in ipairs(hs.application.runningApplications()) do
    if app:name() == appName then
      local axApp = ax.applicationElement(app)
      local extrasMenuBar = axApp.AXExtrasMenuBar
      if extrasMenuBar then
        for _, item in ipairs(extrasMenuBar) do
          local children = item.AXChildren
          if children then
            for _, child in ipairs(children) do
              local subItems = child.AXChildren
              if subItems then
                for _, subChild in ipairs(subItems) do
                  if subChild.AXTitle == menuTitle then
                    local state = "Unknown"
                    local mark = subChild.AXMenuItemMarkChar or ""
                    local value = subChild.AXValue

                    -- Check if it's toggleable and its state
                    if mark ~= "" then
                      state = mark == "✓" and "Checked" or "Unchecked"
                    elseif value ~= nil then
                      state = value and "Enabled" or "Unchecked"
                    end

                    -- Trigger the action
                    local ok = subChild:performAction("AXPress")
                    if ok then
                      print("✅ Triggered", menuTitle, "in", appName, "State:", state)
                    else
                      print("⚠️ Failed to trigger", menuTitle)
                    end
                    return
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  hs.alert("Menu item not found: " .. menuTitle)
end

--- obj:bindHotkeys(mapping)
--- Method
--- Binds hotkeys to menu extra actions
---
--- Parameters:
--- - mapping - Table with keys matching actions defined in `self.actions`
function obj:bindHotkeys(mapping)
  local spec = {}
  for actionName, _ in pairs(mapping) do
    spec[actionName] = hs.fnutils.partial(self.triggerAction, self, actionName)
  end
  hs.spoons.bindHotkeysToSpec(spec, mapping)
  return self
end

--- obj:registerAction(name, app, menuItem)
--- Method
--- Registers an action by name, specifying the app and menu item to trigger
function obj:registerAction(name, app, menuItem)
  self.actions[name] = {
    app = app,
    menuItem = menuItem,
  }
  return self
end

return obj
