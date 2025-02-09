min = math.min
max = math.max

function math.clamp(value, minIn, maxIn)
    return math.min(math.max(value, minIn), maxIn)
end
clamp = math.clamp

function math.map(value, minIn, maxIn, minOut, maxOut)
    value = math.clamp(value, minIn, maxIn)
    return ((value - minIn) / (maxIn - minIn)) * (maxOut - minOut) + minOut
end
map = math.map

--- TODO check this 3 new functions
function math.smoothstep(edge0, edge1, x)
    -- Scale, bias and saturate x to 0..1 range
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)

    -- Evaluate polynomial
    return x * x * (3 - 2 * x)
end
smoothstep = math.smoothstep

function math.smootherstep(edge0, edge1, x)
    -- Scale, and clamp x to 0..1 range
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)

    -- Evaluate polynomial
    return x * x * x * (x * (x * 6 - 15) + 10)
end
smootherstep = math.smootherstep

function math.quotient(dividend, divisor)
    return __ceil(dividend / divisor)
end
quotient = math.quotient

function lerp(a, b, t)
    return (1 - t) * a + t * b
end

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
math.pow = math.pow or function (a, b)
    return a^b
end
pow = math.pow

sin = math.sin
cos = math.cos

asin = math.asin
acos = math.acos

tan = math.tan
atan2 = math.atan2 or math.atan

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

function odd(value)
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
