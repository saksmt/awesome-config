local wibox     = require('wibox')
local naughty   = require("naughty")
local beautiful = require("beautiful")
local awful     = require("awful")
local batteryId = 'BAT0'
local interval

widget = wibox.widget {
    widget = wibox.widget.textbox
}

local notify = function (status)
    naughty.notify({
        title      = "Battery Warning",
        text       = "Battery low! "..status.percentage.."("..status.remaining..") left!",
        timeout    = 5,
        position   = "top_right",
        fg         = beautiful.fg_focus,
        bg         = beautiful.bg_focus,
    })
end

local info = function ()
    return io.popen("acpi -b | cut -d ',' -f3 | cut -d ' ' -f2"):read()
end

local getBatteryInfo = function ()
    local sysPath = '/sys/class/power_supply/' .. batteryId .. '/'
    return {
        state = io.open(sysPath .. 'state'):read(),
        capacity = io.open(sysPath .. 'capacity'):read(),
        current = io.open(sysPath .. 'current_now'),
        charge = {
            full = io.open(sysPath .. 'charge_full'),
            now = io.open(sysPath .. 'charge_now')
            -- todo: until charge = (charge.full - charge.now) / current * 60 * 60 [seconds]
            -- todo: until dischage = ???
        }
    }
end

local isCharging = function ()
    return io.open('/sys/class/power_supply/AC/online'):read() == '1'
end

local batteryCharge = function ()
    local sysPath = '/sys/class/power_supply/' .. batteryId .. '/'
    return tonumber(io.open(sysPath .. 'capacity'):read())
end

awful.tooltip({
    objects = { widget },
    timer_function = function ()

        local wrapped = 'todo'
        local preffix
        if not isCharging() then
            preffix = " Life-time remaining: "
        elseif io.open('/sys/class/power_supply/' .. batteryId .. '/status'):read():match('Charging') then
            preffix = " Until charge: "
        else
            preffix = " Charged"
        end
        wrapped = "\n" .. preffix .. wrapped .. " \n"
        return wrapped
    end
})

local update = function ()
    local status = {}
    status.percentage = batteryCharge()
    status.remaining = 'TODO'
    widget.text = status.percentage
end

interval = timer({timeout = 5})
interval:connect_signal('timeout', update)
interval:start()
update()

return widget
