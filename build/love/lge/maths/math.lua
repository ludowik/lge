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

function math.round(v, decimal)
    if not decimal then
        return math.ceil(v-0.5)
    end
    return math.ceil(v*10^decimal-0.5)/10^decimal
end
round = math.round

function math.fract(v)
    return math.fmod(v, 1)
end
fract = math.fract

sqrt = math.sqrt
pow = math.pow

sin = math.sin
cos = math.cos

tan = math.tan
atan2 = math.atan2

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
    value = round(value)
    
    local n = 0
    while value >= 2 and floor(value) == value do
        value = value / 2
        n = n + 1
    end
    return n
end

function even(value)
    value = round(value)
    return value + value % 2
end

function odd()
    value = round(value)
    return value + value % 2 - 1
end

function dist(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return sqrt(dx ^ 2 + dy ^ 2)
end

function dist3d(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return sqrt(dx ^ 2 + dy ^ 2 + dz ^ 2)
end

function gcd(a, b)
    if a < b then
        a, b = b, a
    end
    local m = a % b
    if m == 0 then
        return b
    end
    return gcd(b, m)
end

function coprime(a, b)
    return gcd(a, b) == 1
end

function cofactor(a, b)
    return gcd(a, b) ~= 1
end

function prime(a)
    if a <= 1 then return false end
    for i=2,sqrt(a) do
        if a % i == 0 then
            return false
        end
    end
    return true
end

function tofraction(ratio)
    if ratio < 1 then ratio = 1/ratio end

    local precedent = 1
    while true do
        local antecedent = ratio * precedent
        if abs(antecedent - round(antecedent, 1)) <= 0.01 then
            return round(antecedent, 1)..'/'..precedent
        end
        precedent = precedent + 1
    end
end
