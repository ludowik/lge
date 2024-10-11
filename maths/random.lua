class().setup = function ()
    seed(os.time())
end

__math = math or (love and love.math)
__random = __math.random
__seed = __math.setRandomSeed or __math.randomseed

seed = function (value)
    return __seed(value)
end

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

noise = __math.simplexNoise or __math.perlinNoise or __math.noise
noiseSeed = __math.setRandomSeed or __math.randomseed

simplexNoise = __math.simplexNoise or __math.noise
perlinNoise = __math.perlinNoise or __math.noise
