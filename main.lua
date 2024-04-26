_love = love

local recurse
function getName(t, where)
    if where == nil then
        where = _G
        recurse = {}
    end
    if recurse[where] then return end

    recurse[where] = true
    for k,v in pairs(where or _G) do
        if v == t then return k end
        if type(v) == 'table' then
            local name = getName(t, v)
            if name then return name end
        end
    end    
    recurse[where] = nil
end

-- function exit()
--     local ffi = require 'ffi'
--     if ffi then
--         ffi.cdef 'void exit(int)'
--         ffi.C.exit(0)
--     end
-- end

function meta(t)
    setmetatable(t, {
        __index = function (t, k)
            print(getName(t), k)
            if rawget(t, k) == nil then assert(false) end
            return rawget(t, k)
        end,
        __newindex = function (t, k, v)
            print(k)
            rawset(t, k, v)
        end
    })
    return t
end

love = meta{
    getVersion = function ()
        return 0, 1, 0, 'starting'
    end,

    load = _love.load,
}

love.system = meta{
    getOS = function ()
        return 'windows'
    end
}

love.filesystem = meta{
    getSaveDirectory = _love.filesystem.getSaveDirectory,
    createDirectory = _love.filesystem.createDirectory,
    load = _love.filesystem.load,
    write = _love.filesystem.write,
}

love.timer = meta{
    getTime = _love.timer.getTime,
    step = _love.timer.step,
}

love.math = meta{
    newTransform = _love.math.newTransform,
    random = _love.math.random,
    setRandomSeed = _love.math.setRandomSeed,
    simplexNoise = _love.math.simplexNoise,
    perlinNoise = _love.math.perlinNoise,
}

love.random = meta{

}

love.event = meta{
    pump = _love.event.pump,
    poll = _love.event.poll,
    poll_i = _love.event.poll_i,
}

love.graphics = meta{
    newShader = _love.graphics.newShader,
}

love = _love

xpcall = function (f, err, ...)
    assert(f)

    local status = true
    local result = f(...)
    
     return status, result
end

require 'engine'
