local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local GLib = astal.require("GLib")
local bind = astal.bind

local function Time(format, class)
  local time = Variable("time"):poll(1000, function()
    return GLib.DateTime.new_now_local():format(format)
  end)
  return Widget.Label({
    class_name = class,
    on_destroy = function()
      time:drop()
    end,
    label = time(),
  })
end

return function ()
  return Widget.Window({
    name = "clock",
    class_name = "empty",
    visible = false,
    Widget.Box({
      class_name = "box",
      vertical = true,
      Time("%I:%M:%S %p", "clock-large"),
      Time("%A, %B %e", "clock-small")
    })
  })
end
