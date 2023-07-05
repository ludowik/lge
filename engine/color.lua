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
