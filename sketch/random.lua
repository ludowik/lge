local bit = require 'bit'

function nextSeed(seed)
    seed = seed * 3432 + 23434
    local result = bit.rshift(seed, bit.rshift(seed, 4) + 2) ^ 1.5234 + 233241
    result = bit.rshift(result, 4) ^ 3.14
    return result
end

function setup()
    local rd = love.math.newRandomGenerator()

    randomGeneratorList = Array{
        {
            seed = function (self, seed) math.randomseed(seed) end,
            random = function (self, ...) return math.random(...) end,
        },
        {
            seed = function (self, seed) love.math.setRandomSeed(seed) end,
            random = function (self, ...) return love.math.random(...) end,
        },
        {
            seed = function (self, seed) love.math.setRandomSeed(seed) end,
            random = function (self, ...) return love.math.randomNormal()*2 + 6 end,
        },
        {
            rd = love.math.newRandomGenerator(),
            seed = function (self, seed) self.rd:setSeed(seed) end,
            random = function (self, ...) return self.rd:random(...) end,
        },
        {
            seedValue = 264,
            seed = function (self, seed) self.seedValue = seed end,
            random = function (self, ...)
                self.seedValue = nextSeed(self.seedValue)
                return map(math.modf(self.seedValue) % 22091 / 22091, 0, 1, ...)
            end,
        },
    }

    randomGeneratorList:foreach(function (v) 
        v.distribution = Array():forn(11, 0)
        v:seed(0)
    end)

    tirage = 0
    parameter:watch('tirage')
end

function update(dt)
    tirage = tirage + 1

    function updateRandomGenerator(randomGenerator)
        local lastValue = clamp(round(randomGenerator:random(1, 11)), 1, 11)
        randomGenerator.distribution[lastValue] = randomGenerator.distribution[lastValue] + 1
        randomGenerator.lastValue = lastValue
    end

    randomGeneratorList:foreach(function (v) 
        updateRandomGenerator(v)
    end)
end

function draw()
    background()

    local x, y, w, h = 20, 100, 25, 80

    function drawRandomGenerator(randomGenerator)
        local maxInstance = randomGenerator.distribution:max()

        noStroke()

        for i,v in ipairs(randomGenerator.distribution) do
            if i == randomGenerator.lastValue then
                fill(colors.blue)
            else
                fill(colors.gray)
            end
            rect(x + (i-1) * (w*1.4), y+h, w, -h * (v/maxInstance))
        end
    end

    randomGeneratorList:foreach(function (v) 
        drawRandomGenerator(v)
        y = y + h * 1.2
    end)
end
