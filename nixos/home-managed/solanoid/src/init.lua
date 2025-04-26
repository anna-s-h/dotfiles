local App = require("astal.gtk3.app")
local Clock = require("widget.clock")

App:start {
    main = function()
      Clock()
    end,
    ---@param request string
    ---@param res fun(response: any): nil
    request_handler = function(request, res)
        if request == "say hi" then
            return res("hi cli")
        end
        res("unknown command")
    end
}
