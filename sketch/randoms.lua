local bit = require 'bit'

local X = os.time()
function setSeedValue(seed)
    X = seed or os.time()
end

local A1 = 710425941047
local B1 = 813633012810
local M1 = 711719770602
function getRandomValue()
    X = (A1 * X + B1) % M1
    return X / M1
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
            seed = function (self, seed) setSeedValue(seed) end,
            random = function (self, ...)
                local value = getRandomValue()
                return map(value, 0, 1, ...)
            end,
        },
    }

    anchor = Anchor(12, #randomGeneratorList + 1)

    randomGeneratorList:foreach(function (v) 
        v.distribution = Array():forn(11, 0)
        v:seed(0)
    end)

    tirage = 0
    parameter:watch('tirage')
end

function update(dt)
    for i in range(10) do
        step()
    end
end

function step()
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

    local x, y, w, h

    x = anchor:size(1, 1).x / 2
    y = anchor:size(1, 1).y / 2

    w = anchor:size(1, 1).x
    h = anchor:size(1, 1).y / 2

    function drawRandomGenerator(randomGenerator)
        local maxInstance = randomGenerator.distribution:max()

        noStroke()

        for i,v in ipairs(randomGenerator.distribution) do
            if i == randomGenerator.lastValue then
                fill(colors.blue)
            else
                fill(colors.gray)
            end
            rect(x + (i-1) * (w), y+h, w*0.8, -h * (v/maxInstance))
        end
    end

    randomGeneratorList:foreach(function (v) 
        drawRandomGenerator(v)
        y = y + h * 1.2
    end)
end
