min = math.min
max = math.max

function math.clamp(value, minIn, maxIn)
    return math.min(math.max(value, minIn), maxIn)
end
clamp  = math.clamp

function math.map(value, minIn, maxIn, minOut, maxOut)
    value = math.clamp(value, minIn, maxIn)
    return ((value - minIn) / (maxIn - minIn)) * (maxOut - minOut) + minOut
end
map = math.map

abs = math.abs

function math.sign(value)
    if value == 0 then return 0 end
    return value > 0 and 1 or -1
end
sign = math.sign

floor = math.floor
ceil = math.ceil
round = function (v) return math.ceil(v - 0.5) end

sqrt = math.sqrt

sin = math.sin
cos = math.cos

rad = math.rad
deg = math.deg

math.maxinteger =  2^52
math.mininteger = -2^52

maxinteger = math.maxinteger
mininteger = math.mininteger

math.TAU = math.pi * 2

PI = math.pi
TAU = math.TAU

function getPowerOf2(value)
    local n = 0
    while value >= 2 and floor(value) == value do
        value = value / 2
        n = n + 1
    end
    return n
end

function even(value)
    return value + value % 2
end

function odd()
    return value + value % 2 - 1
end
