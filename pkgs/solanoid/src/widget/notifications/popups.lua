local astal = require("astal")
local Widget = require("astal.gtk3").Widget

local Notifd = astal.require("AstalNotifd")
local Notification = require("widget.notifications.notification")
local timeout = astal.timeout

local varmap = require("lib").varmap
local notifd = Notifd.get_default()

local function NotificationMap()
	local notif_map = varmap({})
	notifd.on_notified = function(_, id)
		notif_map.set(
			id,
			Notification({
				notification = notifd:get_notification(id),
				setup = function()
          local timeout_ms = notifd:get_notification(id).expire_timeout
					if timeout_ms == -1 then notifd:get_notification(id).expire_timeout=5000
          timeout(notifd:get_notification(id).expire_timeout, function()
            notif_map.delete(id)
					end)
				end,
			})
		)
	end
	notifd.on_resolved = function(_, id) notif_map.delete(id) end
	return notif_map
end

return function(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor
	local notifs = NotificationMap()

	return Widget.Window({
		class_name = "empty",
		gdkmonitor = gdkmonitor,
		anchor = Anchor.TOP + Anchor.RIGHT,
		Widget.Box({
			vertical = true,
			notifs(),
		}),
	})
end
