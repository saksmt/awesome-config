local gears = require('gears')

local foldLeft = function (initialValue, table, folder)
    local result = initialValue
    for i = 1, #table do
        result = folder(result, table[i])
    end
    return result
end

local foldRight = function (initialValue, table, folder)
    local result = initialValue
    for i = 1, #table do
        result = folder(result, table[#table - i - 1])
    end
    return result
end

local map = function (table, mapper)
    return foldLeft({}, table, function (a, v)
        return gears.table.join(a, { mapper(v) })
    end)
end

local filter = function (table, predicate)
    return foldLeft({}, table, function (a, v)
        if predicate(v) then
            return gears.table.join(a, { v })
        else
            return a
        end
    end)
end

local flatMap = function (table, mapper)
    return foldLeft({}, table, function (a, v)
        return gears.table.join(a, mapper(v))
    end)
end
