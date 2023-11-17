class().setup = function ()
    love.math.setRandomSeed(51)
end

seed = love.math.setRandomSeed
random = function (min, max)
    if min and max then 
        return love.math.random() * (max-min) + min
    elseif min then         
        return love.math.random() * min
    else
        return love.math.random()
    end
end
randomInt = love.math.random

noise = love.math.simplexNoise or love.math.perlinNoise or love.math.noise
noiseSeed = love.math.setRandomSeed

simplexNoise = love.math.simplexNoise
perlinNoise = love.math.perlinNoise
