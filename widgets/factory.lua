local class = require('util.class')
local logger = require('util.logger')
local Widget = class(function (definition)
    logger.global.debug('Initializing widget: {}', definition)

    local resultWidget = {}

    if definition.bindGlobalKeys == nil then
        resultWidget.bindGlobalKeys = function (globalKeys) return globalKeys end
    else
        resultWidget.bindGlobalKeys = definition.bindGlobalKeys
    end

    if definition.bindClientKeys == nil then
        resultWidget.bindClientKeys = function (clientKeys) return clientKeys end
    else
        resultWidget.bindClientKeys = definition.bindClientKeys
    end

    if definition.gui == nil then
        resultWidget.gui = function (widgetRendererFunction) end
    else
        resultWidget.gui = definition.gui
    end

    logger.global.debug('Initialization complete: {}', resultWidget)

    return resultWidget
end)

Widget.guiFrom = function (gui)
    return function (renderingFunction)
        renderingFunction(gui)
    end
end

return Widget
