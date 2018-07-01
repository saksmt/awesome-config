---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local logger = require('util.logger').global

local gears = require('gears')

local themes_path = os.getenv('HOME') .. '/.config/awesome/'

local theme = {}

theme.font          = "Hasklig Medium 10"

theme.wibar_height = dpi(30)

theme.bg_normal     = "#343434"
theme.bg_focus      = "#292929"
theme.bg_urgent     = "#403434"
theme.bg_minimize   = "#343434"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#888888"
theme.fg_focus      = "#999999"
theme.fg_urgent     = "#aaaaaa"
theme.fg_minimize   = "#777777"

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal
theme.tooltip_border_width = dpi(5)
theme.tooltip_border_color = "#383838"

theme.prompt_bg = "#303030"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#343434"
theme.border_focus  = "#303030"
theme.border_marked = "#303030"

theme.tasklist_fg_focus = theme.fg_normal
theme.tasklist_fg_minimize = "#777777"
theme.tasklist_fg_normal = "#777777"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
--theme.tasklist_align = "center"
--theme.tasklist_shape_border_width = dpi(1)
--theme.tasklist_shape_border_color = "#282828"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(30)
theme.menu_width  = dpi(100)

theme.taglist_bg_focus = '#0e9e9d'
theme.taglist_bg_urgent = gears.color { type = 'linear', from = { 0, 0 }, to = { 0, theme.menu_height }, stops = { { 0, '#888608' }, { 1, '#9c9a0e' } } }
theme.taglist_bg_occupied = gears.color { type = 'linear', from = { 0, 0 }, to = { 0, theme.menu_height }, stops = { { 0, '#085c5b' }, { 1, '#0e7372' } } }
theme.taglist_bg_empty = '#171717'
theme.taglist_bg_volatile = '#171717'

theme.taglist_shape = function (cr, width, height)
--    logger.info("About to draw taglist bg")
--    cr:set_source(gears.color("#ffffff"))
--    local originalColor = cr:get_source()
--    logger.info("kek")
    --gears.shape.partially_rounded_rect(cr, width * (7/11), height * (5 / 13), false, false, true, true, 0)
    --rect(cr, width * (7/11), height * (5/13) + dpi(1), 0, gears.color { type = 'linear', from = { 0, 0 }, to = { 0, height * (7/13) }, stops = { { 0, '#ffffff00' }, { 1, '#ffffffaa' } } }, gears.color('#000000'), 0)
--    rect(cr, width * (7/11), height * (6/13), 0, gears.color { type = 'radial', from = { width/2, height * (6/13) - dpi(10), 0 }, to = { width/2, height * (6/13), dpi(10) }, stops = { { 0, '#343434' }, { 1, '#555555' } } }, gears.color('#000000'), 0)
    gears.shape.partially_rounded_rect(cr, width * (7/11), height * (5 / 13), false, false, true, true, 0)
--    logger.info("Drawn rect")
end

theme.taglist_shape_border_width = dpi(0)
theme.taglist_shape_border_color = '#383838'
theme.taglist_shape_border_color = '#343434'

theme.taglist_spacing = dpi(5)

theme.wallpaper = themes_path.."theme/background.png"

-- You can use your own layout icons like this:
theme.layout_magnifier = themes_path.."theme/layouts/magnifierw.png"
theme.layout_max = themes_path.."theme/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."theme/layouts/fullscreenw.png"
theme.layout_spiral  = themes_path.."theme/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."theme/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."theme/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."theme/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."theme/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."theme/layouts/cornersew.png"

theme.layout_padding_percent = 15
theme.layout_bg = '#171717'
theme.layout_border = { size = dpi(1), color = '#383838', radius = dpi(0) }

function rect(cr, width, height, radius, color, borderColor, borderSize)
    gears.shape.rounded_rect(cr, width, height, radius)
    cr:set_source(borderColor)
    cr:fill()

    gears.shape.transform(gears.shape.rounded_rect) : translate(borderSize, borderSize)(cr, width - borderSize * 2, height - borderSize * 2, radius)
    cr:set_source(color)
    cr:fill()
end

function sameEvenPercents(value, percent)
    local raw = math.floor(value * percent / 100)
    if (raw % 2) == (value % 2) then
        return raw
    else
        return raw - 1
    end
end

function generateLayoutIcon(f)
    local sized = function (cr, w, h)
        local padding = theme.layout_padding_percent
        local sizedW = sameEvenPercents(w, 100 - padding * 2)
        local sizedH = sameEvenPercents(h, 100 - padding * 2)
        local paddingW = (w - sizedW) / 2
        local paddingH = (h - sizedH) / 2
        gears.shape.transform(f) : translate(paddingW, paddingH)(cr, sizedW, sizedH)
    end
    return gears.surface.load_from_shape(theme.menu_height, theme.menu_height, sized, theme.fg_normal, theme.bg_normal)
end
theme.layout_floating = generateLayoutIcon(function (cr, width, height)
    gears.shape.transform(rect) : translate(width * 1/10, 0)(cr, width * 9/10, height * 9/10, theme.layout_border.radius, gears.color(theme.layout_bg), gears.color(theme.layout_border.color), theme.layout_border.size)
    gears.shape.transform(rect) : translate(0, height - height / 2)(cr, width / 2, height / 2, theme.layout_border.radius, gears.color(theme.layout_bg), gears.color(theme.layout_border.color), theme.layout_border.size)
end)
theme.layout_tile = generateLayoutIcon(function (cr, width, height)
    local w = width / 2
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    rect(cr, w, height, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_tileleft = generateLayoutIcon(function (cr, width, height)
    local w = width / 2
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect) : translate(w, 0)(cr, w, height, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(0, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_tilebottom = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 2
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    rect(cr, width, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_tiletop = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 2
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect) : translate(0, h)(cr, width, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, 0)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_fairh = generateLayoutIcon(function (cr, width, height)
    local w = width / 2
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(0, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_fairv = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 2
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, 0)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_max = generateLayoutIcon(function (cr, width, height)
    rect(cr, width, height, theme.layout_border.radius, gears.color(theme.layout_bg), gears.color(theme.layout_border.color), theme.layout_border.size)
end)
theme.layout_fullscreen = generateLayoutIcon(function (cr, width, height)
    rect(cr, width, height, theme.layout_border.radius, gears.color(theme.layout_bg), gears.color(theme.layout_border.color), theme.layout_border.size)
end)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = 'breeze-dark'

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
