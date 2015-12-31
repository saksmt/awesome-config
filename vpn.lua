local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local wrapper   = require('widget_wrapper')

local current = nil
local widgets = {}

widgets.main  = wibox.widget.background()
widgets.text  = wibox.widget.textbox()
widgets.label = wibox.widget.imagebox()
widgets.left  = wibox.widget.imagebox()

local function getVpnList()
    local handler = io.popen('ls -1 /etc/openvpn/client 2> /dev/null | grep -v .conf')
    local result = {}
    for line in handler:lines() do
        result[#result + 1] = line
        if not io.popen('systemctl is-active openvpn-client@' .. line .. ' | grep -v active'):read() then
            current = line
        end
    end
    handler:close()
    return result
end

local function disconnect(name)
    if current == name then
        current = nil
    end
    awful.util.spawn_with_shell('sudo systemctl stop openvpn-client@' .. name)
end

local function connect(name)
    if current then
        disconnect(current)
    end
    awful.util.spawn_with_shell('sudo systemctl start openvpn-client@' .. name)
    current = name
end

local function createMenuEntry(name)
    return { name, function ()
        connect(name)
        widgets.text:set_text(name)
    end }
end

local function createMenu()
    local available = getVpnList()
    local result = {}
    for i = 1, #available do
        result[i] = createMenuEntry(available[i])
    end
    return awful.menu(result)
end

local menu = createMenu()

if not current then
    widgets.text:set_text("Not connected")
else
    widgets.text:set_text(current)
end

widgets.main:set_bgimage(beautiful.widgets.display.bg)
widgets.main:set_widget(widgets.text)
widgets.left:set_image(beautiful.widgets.display.left)

local builder = wrapper.createBuilder()
builder:add(widgets.label)
builder:add(widgets.left)
builder:add(widgets.main)
builder:finish()

widgets.text:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        menu:show()
    end)
))
widgets.main:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        menu:show()
    end)
))
widgets.left:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        menu:show()
    end)
))
widgets.label:buttons(awful.util.table.join(
    awful.button({}, 1, function ()
        menu:show()
    end)
))

return {
    widget = builder:getWidgets()
}
