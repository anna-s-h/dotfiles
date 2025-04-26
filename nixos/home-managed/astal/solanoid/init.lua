local App = require("astal.gtk3.app")
local Bar = require("widget.bar")

App:start {
    main = function()
        Bar(0)
        Bar(1) -- instantiate for each monitor
    end,
}
