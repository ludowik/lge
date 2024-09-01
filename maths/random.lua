class().setup = function ()
    seed(os.time())
end

seed = function (value)
    return love.math.setRandomSeed(value)
end

__math = love and love.math or math
__random = __math.random

random = function (min, max)
    if min and max then 
        return __random() * (max-min) + min
    elseif min then         
        return __random() * min
    else
        return __random()
    end
end
randomInt = __random

noise = __math.simplexNoise or __math.perlinNoise or __math.noise or __math.random
noiseSeed = __math.setRandomSeed or __math.seed

simplexNoise = __math.simplexNoise or __math.noise or __math.random
perlinNoise = __math.perlinNoise or __math.noise or __math.random
