Color = class()

function Color.setup()
    colors = {
        black = Color(0),
        white = Color(1),
        
        gray = Color(0.62),

        red = Color(1, 0, 0),
        green = Color(0, 1, 0),
        blue = Color(0, 0, 1),
    }
end

function Color:init(...)
    self:set(...)
end

function Color:set(r, ...)
    if type(r) == 'table' then
        return self:setComponents(r.r, r.g, r.b, r.a)
    else
        return self:setComponents(r, ...)
    end
end

function Color.hsl(h, s, l, a)
    local r, g, b = hsl2rgb(h, s, l)
    return Color(r, g, b, a)
end

function Color.hsb(h, s, b, a)
    local r, g, b = hsb2rgb(h, s, b)
    return Color(r, g, b, a)
end

function Color:setComponents(r, g, b, a)
    self.r = r or 0
    self.g = g or r or 0
    self.b = b or r or 0
    self.a = a or 1
    if self.r > 1 then self.r = self.r / 255 end
    if self.g > 1 then self.g = self.g / 255 end
    if self.b > 1 then self.b = self.b / 255 end
    if self.a > 1 then self.a = self.a / 255 end
    return self
end

function Color:__tostring()
    return self.r..', '..self.g..', '..self.b..', '..self.a
end

function Color:rgba()
    return self.r, self.g, self.b, self.a
end

function Color.__eq(a, b)
    return
        (a.r == b.r) and
        (a.g == b.g) and
        (a.b == b.b) and
        (a.a == b.a)
end

function Color.random()
    return Color():randomize()
end

function Color:randomize()
    self.r = random()
    self.g = random()
    self.b = random()
    self.a = 1
    return self
end

function rgb2hsl(r, g, b)
    -- Finding the maximum and minimum values
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)

    -- Calculating lightness
    local lightness = (max + min) / 2

    -- If the maximum and minimum values are the same, it's a shade of gray
    if max == min then
        return 0, 0, lightness
    end

    -- Calculating saturation
    local delta = max - min
    local saturation = delta / (1 - math.abs(2 * lightness - 1))

    -- Calculating hue
    local hue
    if max == r then
        hue = ((g - b) / delta) % 6
    elseif max == g then
        hue = (b - r) / delta + 2
    else
        hue = (r - g) / delta + 4
    end
    hue = hue * 60

    -- Adjusting hue to be in the range of 0-1
    if hue < 0 then
        hue = hue + 1
    end

    return hue, saturation, lightness
end

function hsl2rgb(hue, saturation, lightness)
    saturation = saturation or 0.5
    lightness = lightness or 0.5

    -- Adjusting hue to be in the range of 0-1
    hue = hue % 1

    -- Normalizing saturation and lightness to be in the range of 0-1
    saturation = math.max(0, math.min(1, saturation))
    lightness = math.max(0, math.min(1, lightness))

    if saturation == 0 then
        -- If saturation is 0, it's a shade of gray
        local grayValue = lightness
        return grayValue, grayValue, grayValue

    else
        local q
        if lightness < 0.5 then
            q = lightness * (1 + saturation)
        else
            q = lightness + saturation - lightness * saturation
        end

        local p = 2 * lightness - q

        local function hueToRGB(t)
            if t < 0 then
                t = t + 1
            elseif t > 1 then
                t = t - 1
            end
            
            if t < 1/6 then
                return p + (q - p) * 6 * t

            elseif t < 1/2 then
                return q

            elseif t < 2/3 then
                return p + (q - p) * (2/3 - t) * 6

            else
                return p
            end
        end

        local r = hueToRGB(hue + 1 / 3)
        local g = hueToRGB(hue)
        local b = hueToRGB(hue - 1 / 3)

        return r, g, b
    end
end

function rgb2hsb(r, g, b)
    -- Finding the maximum and minimum values
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)

    -- Calculating brightness
    local brightness = max

    -- If the maximum and minimum values are the same, it's a shade of gray
    if max == min then
        return 0, 0, brightness
    end

    -- Calculating saturation
    local delta = max - min
    local saturation = delta / max

    -- Calculating hue
    local hue
    if max == r then
        hue = ((g - b) / delta) % 6
    elseif max == g then
        hue = (b - r) / delta + 2
    else
        hue = (r - g) / delta + 4
    end
    hue = hue * 60

    -- Adjusting hue to be in the range of 0-1
    if hue < 0 then
        hue = hue + 1
    end

    return hue, saturation, brightness
end

function hsb2rgb(hue, saturation, lightness)
    saturation = saturation or 0.5
    lightness = lightness or 1

    -- Adjusting hue to be in the range of 0-1
    hue = hue % 1

    -- Normalizing saturation and lightness to be in the range of 0-1
    saturation = math.max(0, math.min(1, saturation))
    lightness = math.max(0, math.min(1, lightness))

    if saturation == 0 then
        -- If saturation is 0, it's a shade of gray
        return lightness, lightness, lightness

    else
        local q
        if lightness < 0.5 then
            q = lightness * (1 + saturation)
        else
            q = lightness + saturation - lightness * saturation
        end

        local p = 2 * lightness - q

        local function hueToRGB(t)
            if t < 0 then
                t = t + 1
            elseif t > 1 then
                t = t - 1
            end

            if t < 1/6 then
                return p + (q - p) * 6 * t

            elseif t < 1/2 then
                return q

            elseif t < 2/3 then
                return p + (q - p) * (2/3 - t) * 6

            else
                return p
            end
        end

        local r = hueToRGB(hue + 1/3)
        local g = hueToRGB(hue)
        local b = hueToRGB(hue - 1/3)

        return r, g, b
    end
end

function Color.unitTest()
    local clr = Color()
    assert(clr.r == 0)
    assert(clr.g == 0)
    assert(clr.b == 0)
    assert(clr.a == 1)

    clr = Color(.2, .4, .6, 1.0)
    assert(clr.r == 0.2)
    assert(clr.g == 0.4)
    assert(clr.b == 0.6)
    assert(clr.a == 1.0)

    assert(Color.random ~= Color.random())

    assert(colors.black.r == 0)
    assert(colors.white.r == 1)
end
