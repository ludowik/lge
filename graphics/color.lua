Color = class()

function Color.setup()
    colors = Array{
        black = Color(0),
        white = Color(1),

        lightgray = Color(0.75, 0.75, 0.75),
        gray = Color(0.5, 0.5, 0.5),
        darkgray = Color(0.25, 0.25, 0.25),

        red = Color(210, 70, 50),    -- 1, 0, 0),
        green = Color(50, 170, 120), -- 0, 1, 0),
        blue = Color(50, 120, 170),  -- 0, 0, 1),

        yellow = Color(245, 225, 50),
        magenta = Color(1, 0, 1),
        cyan = Color(0, 1, 1),
        orange = Color(1, 165, 0),
        purple = Color(0.5, 0, 0.5),

        brown = Color(165, 42, 42),
        beige = Color(245, 245, 220),
        azure = Color(240, 255, 255),

        transparent = Color(0, 0, 0, 0),
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

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

function Color.fromParam(clr, ...)
    if clr == nil then return end
    if type(clr) == 'table' then return clr end
    return Color(clr, ...)
end

function Color.hexa(hexa)
    local r, g, b

    r = hexa % 256
    hexa = (hexa - r) / 256

    g = hexa % 256
    hexa = (hexa - g) / 256

    b = hexa % 256

    return Color(r / 255, g / 255, b / 255)
end

function Color.hsl(h, s, l, a)
    local r, g, b = hsl2rgb(h, s, l)
    return Color(r, g, b, a)
end

function Color.hsb(h, s, b, a)
    local r, g, b = hsb2rgb(h, s, b)
    return Color(r, g, b, a)
end

function Color:contrast(a)
    local _, _, lightness = rgb2hsl(self.r, self.g, self.b)
    return (lightness >= 0.1791 and colors.black or colors.white):alpha(a or 1)
end

function Color:alpha(a)
    return Color(self.r, self.g, self.b, a)
end

function Color:setComponents(r, g, b, a)
    if r and g and not b and not a then
        self.r = r
        self.g = r
        self.b = r
        self.a = g
    else
        self.r = r or 0
        self.g = g or r or 0
        self.b = b or r or 0
        self.a = a or 1
    end
    if self.r > 1 then self.r = self.r / 255 end
    if self.g > 1 then self.g = self.g / 255 end
    if self.b > 1 then self.b = self.b / 255 end
    if self.a > 1 then self.a = self.a / 255 end
    return self
end

function Color.__add(clr1, clr2)
    assert(false)
    return Color.mix(clr1, clr2, 0.5) 
end

function Color.add(clr1, clr2)
    clr1.r = clr1.r + clr2.r
    clr1.g = clr1.g + clr2.g
    clr1.b = clr1.b + clr2.b
    return clr1
end

function Color.__div(clr, coef)
    return Color(
        clr.r / coef,
        clr.g / coef,
        clr.b / coef,
        clr.a) 
end

function Color.div(clr, coef)
    clr.r = clr.r / coef
    clr.g = clr.g / coef
    clr.b = clr.b / coef
    return clr
end

function Color.mix(clr1, clr2, alpha)
    local a1 = alpha or clr1.a
    local a2 = alpha and (1 - a1) or clr2.a
    local k = a1 + a2
    return Color(
        (clr1.r * a1 + clr2.r * a2) / k,
        (clr1.g * a1 + clr2.g * a2) / k,
        (clr1.b * a1 + clr2.b * a2) / k,
        1
    )
end

function Color.min(a, b)
    return Color(
        min(a.r, b.r),
        min(a.g, b.g),
        min(a.b, b.b),
        1)
end

function Color.max(a, b)
    return Color(
        max(a.r, b.r),
        max(a.g, b.g),
        max(a.b, b.b),
        1)
end

function Color.avg(a, b)
    return Color(
        (a.r + b.r) / 2,
        (a.g + b.g) / 2,
        (a.b + b.b) / 2,
        1)
end

function Color:grayscale()
    grayscale =
        self.r * 0.299 +
        self.g * 0.587 +
        self.b * 0.114
    return Color(grayscale)
end

function Color.darken(clr, pct)
    pct = pct or 50
    return Color.lighten(clr, -pct)
end

function Color.lighten(clr, pct)
    pct = pct or 50
    local h, s, l, a = rgb2hsl(clr.r, clr.g, clr.b, clr.a)
    l = l + l * pct / 100
    return Color.hsl(h, s, l, a)
end

function Color:__tostring()
    return self.r .. ', ' .. self.g .. ', ' .. self.b .. ', ' .. self.a
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

function Color.random(self)
    if self then
        return Color(
            self.r + random(-0.05, 0.05),
            self.g + random(-0.05, 0.05),
            self.b + random(-0.05, 0.05),
            1)
    else
        return Color():randomize()
    end
end

function Color:randomize()
    self.r = random()
    self.g = random()
    self.b = random()
    self.a = 1
    return self
end

function Color.grayScaleLightness(clr, to)
    local r, g, b = clr.r, clr.g, clr.b
    local c = (max(r,g,b) + min(r,g,b)) / 2
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleAverage(clr, to)
    local r, g, b = clr.r, clr.g, clr.b
    local c = (r+g+b) / 3
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleLuminosity(clr, to)
    local r, g, b = clr.r, clr.g, clr.b
    local c = 0.21*r + 0.72*g + 0.07*b
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleIntensity(clr, to)
    local r, g, b = clr.r, clr.g, clr.b
    local c = 0.299*r + 0.587*g + 0.114*b
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

Color.grayscale = Color.grayScaleIntensity

function Color.rgb2hsl(self)
    return rgb2hsl(self.r, self.g, self.b)
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
    if hue > 1 then hue = hue / 255 end
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

            if t < 1 / 6 then
                return p + (q - p) * 6 * t
            elseif t < 1 / 2 then
                return q
            elseif t < 2 / 3 then
                return p + (q - p) * (2 / 3 - t) * 6
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

function Color.rgb2hsb(self)
    return rgb2hsb(self.r, self.g, self.b)
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
    lightness = lightness or 0.5

    -- Adjusting hue to be in the range of 0-1
    if hue > 1 then hue = hue / 255 end
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

            if t < 1 / 6 then
                return p + (q - p) * 6 * t
            elseif t < 1 / 2 then
                return q
            elseif t < 2 / 3 then
                return p + (q - p) * (2 / 3 - t) * 6
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

    assert(Color.hexa(0x000000) == colors.black)
    assert(Color.hexa(0xFFFFFF) == colors.white)
end
