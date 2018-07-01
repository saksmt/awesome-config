local _LogLevelClass = function (index, value)
    local result = {
        ordinal = function () return index end,
        value = function () return value end,
        enumClass = function () return '_LogLevelClass' end
    }
    local comparison = { __lt = function (a, b)
        if (a.ordinal ~= nil and b.ordinal ~= nil) then
            return a.ordinal() < b.ordinal()
        end
        return false
    end, __eq = function (a, b)
        if (a.ordinal ~= nil and b.ordinal ~= nil) then
            return a.ordinal() == b.ordinal()
        end
        return false
    end }

    setmetatable(result, comparison)

    return result
end
local LogLevel = {
    DEBUG = _LogLevelClass(0, 'debug'),
    INFO = _LogLevelClass(1, 'info'),
    WARN = _LogLevelClass(2, 'warn'),
    ERROR = _LogLevelClass(3, 'error'),

    isValidLogLevel = function (candidate)
        return candidate['enumClass'] ~= nil and candidate.enumClass() == '_LogLevelClass'
    end
}

local function dump(what)
    local inputType = type(what)
    if inputType == 'table' then
        local result = '{'
        for k, v in pairs(what) do
            result = result .. ' ' .. dump(k) .. ' = ' .. dump(v) .. ';'
        end
        return result .. ' }'
    elseif inputType == 'function' then
        return inputType
    else
        return tostring(what)
    end
end

local Logger = function (path)
    local handle = io.open(path, 'a+')

    local logLevel = LogLevel.INFO

    local setLogLevel = function (level)
        if not LogLevel.isValidLogLevel(level) then
            error("Attempted to set non existent log level '{}'", level)
            return
        end
        logLevel = level
    end

    local genericLog = function (atLogLevel)
        return function (message, ...)
            if atLogLevel < logLevel then
                return
            end

            local resultMessage = message
            local argStack = {... }
            while resultMessage:find('{}') ~= nil and #argStack ~= 0 do
                local value = dump(argStack[1])
                table.remove(argStack, 1)
                resultMessage = resultMessage:gsub('{}', value, 1)
            end

            handle:write('[' .. atLogLevel.value():upper() .. '] ' .. os.date('%d.%m.%y %H:%M:%S -- ') .. resultMessage .. '\n')
            handle:flush()
        end
    end

    local debug = genericLog(LogLevel.DEBUG)
    local info = genericLog(LogLevel.INFO)
    local warn = genericLog(LogLevel.WARN)
    local error = genericLog(LogLevel.ERROR)

    return {
        setLogLevel = setLogLevel,
        debug = debug,
        info = info,
        warn = warn,
        error = error
    }
end

local defaultLogDir = os.getenv('HOME') .. '/.log'

os.execute('mkdir -p -- ' .. defaultLogDir)

return { LogLevel = LogLevel, Logger = Logger, global = Logger(defaultLogDir .. '/awesome.log'), defaultLogDir = defaultLogDir }
