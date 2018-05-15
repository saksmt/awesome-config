local asClass = function (constructor)
    local classDef = {}

    setmetatable(classDef, {
        __call = function (self, ...) return constructor(...) end
    })

    return classDef
end

return asClass
