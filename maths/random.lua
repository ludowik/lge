class().setup = function ()
    --love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())
end

--random = love.math.random
random = math.random
noise = love.math.noise
