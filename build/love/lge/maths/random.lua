class().setup = function ()
    seed(os.time())
end

__math = (love and love.math) or math
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
randomInt = function (min, max)
    if min and max then
        return __random(math.floor(min), math.floor(max))
    end
    return __random(math.floor(min))
end

noise = __math.simplexNoise or __math.perlinNoise or __math.noise or __random
noiseSeed = __math.setRandomSeed or __math.randomseed

simplexNoise = __math.simplexNoise or __math.noise
perlinNoise = __math.perlinNoise or __math.noise
