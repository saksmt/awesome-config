local logger = require('util.logger')
local Widget = require('widgets.factory')
local wibox = require('wibox')
local awful = require('awful')

local gui = wibox.widget {
    text = '',
    widget = wibox.widget.textbox
}

local update = function ()
    gui.text = os.date('%R')
end

local interval = timer { timeout = 5 }
interval:connect_signal('timeout', update)
interval:start()
update()

local months = {
    "января",
    "февраля",
    "марта",
    "апреля",
    "мая",
    "июня",
    "июля",
    "августа",
    "сентября",
    "октября",
    "ноября",
    "декабря"
}

local weekDays = {
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
}

local dateTooltip = awful.tooltip {
    objects = { gui },
    timer_function = function ()
        local month = os.date('%m')
        local week  = os.date('%w')
        local day   = os.date('%d')
        local year  = os.date('%Y')

        return "\n "..
            weekDays[tonumber(week)]  ..", "..
            day   .." "..
            months[tonumber(month)] .." "..
            year  .." года."..
            " \n"

    end
}

return Widget {
    gui = Widget.guiFrom(gui)
}
