---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require('gears')

local themes_path = os.getenv('HOME') .. '/.config/awesome/'

local theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#343434"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

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
theme.menu_submenu_icon = themes_path.."theme/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

theme.taglist_bg_focus = '#0e9e9d'
theme.taglist_bg_urgent = gears.color { type = 'linear', from = { 0, 0 }, to = { 0, theme.menu_height }, stops = { { 0, '#888608' }, { 1, '#9c9a0e' } } }
theme.taglist_bg_occupied = gears.color { type = 'linear', from = { 0, 0 }, to = { 0, theme.menu_height }, stops = { { 0, '#085c5b' }, { 1, '#0e7372' } } }
theme.taglist_bg_empty = '#171717'
theme.taglist_bg_volatile = '#171717'

theme.taglist_shape = function (cr, width, height)
    gears.shape.partially_rounded_rect(cr, dpi(7), height * (3/5), false, false, true, true, 4)
end

theme.taglist_shape_border_width = dpi(1)
theme.taglist_shape_border_color = '#383838'

theme.taglist_spacing = dpi(5)

theme.wallpaper = themes_path.."theme/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."theme/layouts/fairhw.png"
theme.layout_fairv = themes_path.."theme/layouts/fairvw.png"
theme.layout_magnifier = themes_path.."theme/layouts/magnifierw.png"
theme.layout_max = themes_path.."theme/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."theme/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."theme/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."theme/layouts/tileleftw.png"
theme.layout_tiletop = themes_path.."theme/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."theme/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."theme/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."theme/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."theme/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."theme/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."theme/layouts/cornersew.png"

theme.layout_bg = '#171717'
theme.layout_border = { size = dpi(1), color = '#383838', radius = dpi(1) }

function rect(cr, width, height, radius, color, borderColor, borderSize)
    gears.shape.rounded_rect(cr, width + borderSize * 2, height + borderSize * 2, radius)
    cr.source = borderColor
    cr:fill()

    gears.shape.transform(gears.shape.rounded_rect) : translate(borderSize, borderSize)(cr, width, height, radius)
    cr.source = color
    cr:fill()
end
function generateLayoutIcon(f)
    return gears.surface.load_from_shape(theme.menu_height, theme.menu_height, f, theme.fg_normal, theme.bg_normal)
end
theme.layout_floating = generateLayoutIcon(function (cr, width, height)
    local size = { w = width * 2 / 3, h = height * 1 / 2 }
    local offset = { w = width * 1 / 3 - theme.layout_border.size * 2, h = height * 1 / 2 - theme.layout_border.size * 2 }

    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect) : translate(offset.w, offset.h)(cr, size.w - border.size, size.h - border.size, border.radius, bg, border.color, border.size)
    rect(cr, size.w, size.h, border.radius, bg, border.color, border.size)
end)
theme.layout_tile = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    rect(cr, w, height, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, 0)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(w, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_tilebottom = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    rect(cr, width, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h * 2)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_tiletop = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect)(0, h * 2)(cr, width, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, 0)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)
end)
theme.layout_fairw = generateLayoutIcon(function (cr, width, height)
    local w = width / 3
    local h = height / 3
    local bg = gears.color(theme.layout_bg)
    local border = { size = theme.layout_border.size, color = gears.color(theme.layout_border.color), radius = theme.layout_border.radius }

    gears.shape.transform(rect)(0, h * 2)(cr, width, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, 0)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, 0)(cr, w, h, border.radius, bg, border.color, border.size)

    gears.shape.transform(rect) : translate(0, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w, h)(cr, w, h, border.radius, bg, border.color, border.size)
    gears.shape.transform(rect) : translate(w * 2, h)(cr, w, h, border.radius, bg, border.color, border.size)
end)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
