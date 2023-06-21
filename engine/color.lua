Color = class()

function Color.setup()
    colors = {
        black = Color(0),
        white = Color(1),

        red = Color(1, 0, 0),
        green = Color(0, 1, 0),
        blue = Color(0, 0, 1),
    }
end

function Color:init(...)
    self:set(...)
end

function Color:set(r, g, b, a)
    self.r = r or 0
    self.g = g or r or 0
    self.b = b or r or 0
    self.a = a or 1
    return self
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
end
