local App = require("astal.gtk3.app")
local astal = require("astal")
local Variable = astal.Variable
local Clock = require("widget.clock")
local NotificationPopups = require("widget.notifications.popups")
--local NotificationLogs = require("widget.notificationLogs")
--local appLauncher = require("widget.launcher")
--local clipboard = require("widget.clipboard")
--local mainMenu = require("widget.mainMenu")
--local music = require("widget.music")

local currentMenu = Variable("none")
local windows = {}

-- List of menu names, in the cycle order
local menuList = { "none", "clock" }

-- Helper: find next in list
local function next_menu(current)
  for i, name in ipairs(menuList) do
    if name == current then
      return menuList[i % #menuList + 1]
    end
  end
  return "none" -- fallback
end

-- Helper: safe window visibility
local function set_visible(name, visible)
  local w = windows[name]
  if w then w.visible = visible end
end

-- Helper: safe manual window set
local function valid_menu(name)
  for _, n in ipairs(menuList) do
    if n == name then return true end
  end
  return false
end

local function change_menu(target)
  local prev = currentMenu:get()
  set_visible(prev, false)

  local nextMenu = (target ~= "" and valid_menu(target) and target) or next_menu(prev)
  currentMenu:set(nextMenu)

  set_visible(nextMenu, true)

  return ("Changed menu %s to %s"):format(prev, nextMenu)
end

local function toggle_visibility(name)
  local w = windows[name]
  if not w then
    return ("Cannot toggle '%s': no such window."):format(name)
  end
  w.visible = not w.visible
  return ("Toggled '%s': now %s."):format(name, w.visible and "visible" or "hidden")
end

App:start {
  css = "/home/solanum/.config/solanoid/style.css", --TODO: de-jank
  main = function()
		for _, mon in pairs(App.monitors) do
			NotificationPopups(mon)
		end
    windows.clock = Clock()
    --windows.mainMenu = MainMenu()
  end,
  request_handler = function(request, res)
    local cmd, arg = request:match("^(%S+)%s*(.*)$")
    if cmd == "menu" then
      return res(change_menu(arg))
    elseif cmd == "toggle" then
      return res(toggle_visibility(arg))
    else
      return res(("Unknown command: '%s'"):format(request))
    end
  end
}
