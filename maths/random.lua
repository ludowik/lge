class().setup = function ()
    --love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())
end

--random = love.math.random
random = math.random

local __noise__ = love.math.perlinNoise or love.math.noise
noise = function (x, y, z)
    x = (x or 0) + 1.23456
    y = (y or 0) + 2.34567
    z = (z or 0) + 3.45678
    return __noise__(x, y, z)
end
