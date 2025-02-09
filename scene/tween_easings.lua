-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)

local function none(t, b, c, d)
    return b
end

local function linear(t, b, c, d)
    return c * t / d + b
end

local function quadIn(t, b, c, d)
    t = t / d
    return c * pow(t, 2) + b
end

local function quadOut(t, b, c, d)
    t = t / d
    return -c * t * (t - 2) + b
end

local function quadInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * pow(t, 2) + b
    else
        return -c / 2 * ((t - 1) * (t - 3) - 1) + b
    end
end

local function quadOutIn(t, b, c, d)
    if t < d / 2 then
        return quadOut (t * 2, b, c / 2, d)
    else
        return quadIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function cubicIn (t, b, c, d)
    t = t / d
    return c * pow(t, 3) + b
end

local function cubicOut(t, b, c, d)
    t = t / d - 1
    return c * (pow(t, 3) + 1) + b
end

local function cubicInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * t * t * t + b
    else
        t = t - 2
        return c / 2 * (t * t * t + 2) + b
    end
end

local function cubicOutIn(t, b, c, d)
    if t < d / 2 then
        return cubicOut(t * 2, b, c / 2, d)
    else
        return cubicIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function quartIn(t, b, c, d)
    t = t / d
    return c * pow(t, 4) + b
end

local function quartOut(t, b, c, d)
    t = t / d - 1
    return -c * (pow(t, 4) - 1) + b
end

local function quartInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * pow(t, 4) + b
    else
        t = t - 2
        return -c / 2 * (pow(t, 4) - 2) + b
    end
end

local function quartOutIn(t, b, c, d)
    if t < d / 2 then
        return quartOut(t * 2, b, c / 2, d)
    else
        return quartIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function quintIn(t, b, c, d)
    t = t / d
    return c * pow(t, 5) + b
end

local function quintOut(t, b, c, d)
    t = t / d - 1
    return c * (pow(t, 5) + 1) + b
end

local function quintInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return c / 2 * pow(t, 5) + b
    else
        t = t - 2
        return c / 2 * (pow(t, 5) + 2) + b
    end
end

local function quintOutIn(t, b, c, d)
    if t < d / 2 then
        return quintOut(t * 2, b, c / 2, d)
    else
        return quintIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function sineIn(t, b, c, d)
    return -c * cos(t / d * (PI / 2)) + c + b
end

local function sineOut(t, b, c, d)
    return c * sin(t / d * (PI / 2)) + b
end

local function sineInOut(t, b, c, d)
    return -c / 2 * (cos(PI * t / d) - 1) + b
end

local function sineOutIn(t, b, c, d)
    if t < d / 2 then
        return sineOut(t * 2, b, c / 2, d)
    else
        return sineIn((t * 2) -d, b + c / 2, c / 2, d)
    end
end

local function expoIn(t, b, c, d)
    if t == 0 then
        return b
    else
        return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
    end
end

local function expoOut(t, b, c, d)
    if t == d then
        return b + c
    else
        return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
    end
end

local function expoInOut(t, b, c, d)
    if t == 0 then return b end
    if t == d then return b + c end
    t = t / d * 2
    if t < 1 then
        return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
    else
        t = t - 1
        return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
    end
end

local function expoOutIn(t, b, c, d)
    if t < d / 2 then
        return expoOut(t * 2, b, c / 2, d)
    else
        return expoIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function circIn(t, b, c, d)
    t = t / d
    return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

local function circOut(t, b, c, d)
    t = t / d - 1
    return(c * sqrt(1 - pow(t, 2)) + b)
end

local function circInOut(t, b, c, d)
    t = t / d * 2
    if t < 1 then
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
    else
        t = t - 2
        return c / 2 * (sqrt(1 - t * t) + 1) + b
    end
end

local function circOutIn(t, b, c, d)
    if t < d / 2 then
        return circOut(t * 2, b, c / 2, d)
    else
        return circIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

local function elasticIn(t, b, c, d, a, p)
    if t == 0 then return b end

    t = t / d

    if t == 1  then return b + c end

    if not p then p = d * 0.3 end

    local s

    if not a or a < abs(c) then
        a = c
        s = p / 4
    else
        s = p / (2 * PI) * asin(c/a)
    end

    t = t - 1

    return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b
end

-- a: amplitud
-- p: period
local function elasticOut(t, b, c, d, a, p)
    if t == 0 then return b end

    t = t / d

    if t == 1 then return b + c end

    if not p then p = d * 0.3 end

    local s

    if not a or a < abs(c) then
        a = c
        s = p / 4
    else
        s = p / (2 * PI) * asin(c/a)
    end

    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b
end

-- p = period
-- a = amplitud
local function elasticInOut(t, b, c, d, a, p)
    if t == 0 then return b end

    t = t / d * 2

    if t == 2 then return b + c end

    if not p then p = d * (0.3 * 1.5) end
    if not a then a = 0 end

    local s

    if not a or a < abs(c) then
        a = c
        s = p / 4
    else
        s = p / (2 * PI) * asin(c / a)
    end

    if t < 1 then
        t = t - 1
        return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b
    else
        t = t - 1
        return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p ) * 0.5 + c + b
    end
end

-- a: amplitud
-- p: period
local function elasticOutIn(t, b, c, d, a, p)
    if t < d / 2 then
        return elasticOut(t * 2, b, c / 2, d, a, p)
    else
        return elasticIn((t * 2) - d, b + c / 2, c / 2, d, a, p)
    end
end

local function backIn(t, b, c, d, s)
    if not s then s = 1.70158 end
    t = t / d
    return c * t * t * ((s + 1) * t - s) + b
end

local function backOut(t, b, c, d, s)
    if not s then s = 1.70158 end
    t = t / d - 1
    return c * (t * t * ((s + 1) * t + s) + 1) + b
end

local function backInOut(t, b, c, d, s)
    if not s then s = 1.70158 end
    s = s * 1.525
    t = t / d * 2
    if t < 1 then
        return c / 2 * (t * t * ((s + 1) * t - s)) + b
    else
        t = t - 2
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
    end
end

local function backOutIn(t, b, c, d, s)
    if t < d / 2 then
        return backOut(t * 2, b, c / 2, d, s)
    else
        return backIn((t * 2) - d, b + c / 2, c / 2, d, s)
    end
end

local function bounceOut(t, b, c, d)
    t = t / d
    if t < 1 / 2.75 then
        return c * (7.5625 * t * t) + b
    elseif t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
        return c * (7.5625 * t * t + 0.75) + b
    elseif t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
        return c * (7.5625 * t * t + 0.9375) + b
    else
        t = t - (2.625 / 2.75)
        return c * (7.5625 * t * t + 0.984375) + b
    end
end

local function bounceIn(t, b, c, d)
    return c - bounceOut(d - t, 0, c, d) + b
end

local function bounceInOut(t, b, c, d)
    if t < d / 2 then
        return bounceIn(t * 2, 0, c, d) * 0.5 + b
    else
        return bounceOut(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
    end
end

local function bounceOutIn(t, b, c, d)
    if t < d / 2 then
        return bounceOut(t * 2, b, c / 2, d)
    else
        return bounceIn((t * 2) - d, b + c / 2, c / 2, d)
    end
end

Tween.easing = Array{
    none = none,

    linear = linear,

    quadIn = quadIn,
    quadOut = quadOut,
    quadInOut = quadInOut,
    quadOutIn = quadOutIn,

    cubicIn  = cubicIn ,
    cubicOut = cubicOut,
    cubicInOut = cubicInOut,
    cubicOutIn = cubicOutIn,

    quartIn = quartIn,
    quartOut = quartOut,
    quartInOut = quartInOut,
    quartOutIn = quartOutIn,

    quintIn = quintIn,
    quintOut = quintOut,
    quintInOut = quintInOut,
    quintOutIn = quintOutIn,

    sineIn = sineIn,
    sineOut = sineOut,
    sineInOut = sineInOut,
    sineOutIn = sineOutIn,

    expoIn = expoIn,
    expoOut = expoOut,
    expoInOut = expoInOut,
    expoOutIn = expoOutIn,

    circIn = circIn,
    circOut = circOut,
    circInOut = circInOut,
    circOutIn = circOutIn,

    elasticIn = elasticIn,
    elasticOut = elasticOut,
    elasticInOut = elasticInOut,
    elasticOutIn = elasticOutIn,

    backIn = backIn,
    backOut = backOut,
    backInOut = backInOut,
    backOutIn = backOutIn,

    bounceIn = bounceIn,
    bounceOut = bounceOut,
    bounceInOut = bounceInOut,
    bounceOutIn = bounceOutIn,
}
