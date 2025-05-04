local Widget = require("astal.gtk3").Widget
local Gtk = require("astal.gtk3").Gtk
local Astal = require("astal.gtk3").Astal
local astal = require("astal")
local Variable = astal.Variable
local GLib = astal.require("GLib")
local bind = astal.bind


local map = require("lib").map
local time = require("lib").time
local file_exists = require("lib").file_exists

local function is_icon(icon) return Astal.Icon.lookup_icon(icon) ~= nil end

---@param props { setup?: function, on_hover_lost?: function, notification: any }
return function(props)
	local n = props.notification

	local header = Widget.Box({
		class_name = "header",
    (--[[n.app_icon or]] n.desktop_entry) and Widget.Icon({
			class_name = "icon",
			icon = --[[n.app_icon or]] n.desktop_entry,
		}),
		Widget.Label({
			class_name = "title",
			halign = "START",
			ellipsize = "END",
			label = n.app_name or "Unknown",
		}),
		Widget.Label({
			class_name = "clock-small",
			hexpand = true,
			halign = "END",
			label = time(n.time),
		}),
	})

  local ctime = GLib.get_monotonic_time() / 1000 -- in milliseconds
  
  local barFraction = Variable(1):poll(1000/60, function()
    local elapsed = (GLib.get_monotonic_time() / 1000) - ctime
    local remaining = n.expire_timeout - elapsed
    if remaining <= 0 then
      return 0
    else
      --print(remaining)
      return remaining / n.expire_timeout
    end
  end)

  local seperator = function()
    if n.expire_timeout > 0 then
      return Widget.LevelBar({
        class_name = "timer",
        value = barFraction(),
        vexpand = false,
      })
    else
			return Gtk.Separator({ visible = true })
    end
  end

	local content = Widget.Box({
		class_name = "content",
		(n.image and file_exists(n.image)) and Widget.Box({
			valign = "START",
			class_name = "image",
			css = string.format("background-image: url('%s')", n.image),
		}),
		n.image and is_icon(n.image) and Widget.Box({
			valign = "START",
			class_name = "icon",
			Widget.Icon({
				icon = n.image,
				hexpand = true,
				vexpand = true,
				halign = "CENTER",
				valign = "CENTER",
			}),
		}),
		Widget.Box({
			vertical = true,
			Widget.Label({
				class_name = "summary",
				halign = "START",
				xalign = 0,
				ellipsize = "END",
				label = n.summary,
			}),
			Widget.Label({
				class_name = "body",
				wrap = true,
				use_markup = true,
				halign = "START",
				xalign = 0,
				justify = "FILL",
				label = n.body,
			}),
		}),
	})

	return Widget.EventBox({
		--class_name = string.format("box.%s", string.lower(n.urgency)),
		setup = props.setup,
		on_hover_lost = props.on_hover_lost,
		Widget.Box({
		  class_name = string.format("box %s", string.lower(n.urgency)),
      --class_name = "box",
			vertical = true,
			header,
			seperator(),
      content,
			Widget.Box({
				class_name = "actions",
				map(n.actions, function(action)
					local label, id = action.label, action.id

					return Widget.Button({
						hexpand = true,
						on_clicked = function() return n:invoke(id) end,
						Widget.Label({
							label = label,
							halign = "CENTER",
							hexpand = true,
						}),
					})
				end),
        Widget.Button({
          hexpand = true,
          on_clicked = function() n:dismiss() end,
          Widget.Label({
            label = "Dismiss",
            halign = "CENTER",
            hexpand = true,
          }),
        }),
			}),
		}),
	})
end
