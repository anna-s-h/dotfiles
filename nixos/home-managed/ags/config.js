import { NotificationPopups } from "./notificationPopups.js"
import { applauncher } from "./applauncher.js"

const hyprland = await Service.import("hyprland")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const systemtray = await Service.import("systemtray")

const date = Variable("", {
  poll: [100, 'date "+%a %r %b %e"'],
})

const clock = Widget.Window({
  name: "clock",
  class_name: "empty",
  visible: false,
  layer: "overlay",
  child: Widget.Box({
    class_name: "box",
    children : [ 
      Widget.Label({
        class_name: "clock",
        label: date.bind(),
      })
    ],
  })
})

const sysTray = Widget.Window({
  name: "sysTray",
  class_name: "empty",
  visible: false,
  layer: "overlay",
  child: Widget.Box({
    class_name: "box",
    children: systemtray.bind("items")
    .as(items => items.map(item => Widget.Button({
      child: Widget.Icon({ icon: item.bind("icon") }),
      on_primary_click: (_, event) => item.activate(event),
      on_secondary_click: (_, event) => item.openMenu(event),
      tooltip_markup: item.bind("tooltip_markup"),
    })))
  })
})

App.config({
  style: "./style.css",
  windows: [
    NotificationPopups(0),
    NotificationPopups(1),
    clock,
    sysTray,
    applauncher,
  ],
})

globalThis.currentMenu = "none"
globalThis.change_menu = function(m) {
  switch(m){
    case "none":
      clock.visible = false
      sysTray.visible = false
      applauncher.visible = false
      break;
    case "clock":
      clock.visible = true
      sysTray.visible = false
      applauncher.visible = false
      break;
    case "sysTray":
      clock.visible = false
      sysTray.visible = true
      applauncher.visible = false
      break;
    case "applauncher":
      clock.visible = false
      sysTray.visible = false
      applauncher.visible = true
      break;
    default:
      change_menu(
        ({
          "applauncher": "sysTray",
        })[currentMenu] ?? "applauncher"
      )
  }
}
