vec2 = class()

function vec2:init(x, y)
    self:set(x, y)
end

function vec2:set(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

function vec2.__eq(u, v)
    return
        (u.x == v.x) and
        (u.y == v.y)
end

function vec2.random(w, h)
    return vec2():randomize(w, h)
end

function vec2:randomize(w, h)
    w = w or W or 1
    h = h or H or 1

    self.x = random() * w
    self.y = random() * h
    return self
end

function vec2:len()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function vec2.scalar(u, v)
    return u.x * v.x + u.y * v.y
end

function vec2.unitTest()
    assert(vec2(1,2) == vec2(1,2))
    assert(vec2():set(1,2) == vec2(1,2))
    assert(vec2.random() ~= vec2.random())
    assert(vec2():len() == 0)
    assert(vec2(1,2):scalar(vec2(2,2)) == 6)
end
