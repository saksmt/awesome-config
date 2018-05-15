function widget(name)
    return require('widgets.' .. name)
end

return {
    widget('clock')
}