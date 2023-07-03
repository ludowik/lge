vec2 = class()

function vec2:init(x, y)
    self:set(x, y)
end

function vec2:set(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

function vec2:__tostring()
    return self.x..', '..self.y
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
    if w then
        h = h or w
        self.x = random(w)
        self.y = random(h)
    else
        self.x = random()
        self.y = random()
    end
    return self
end

function vec2:len()
    return sqrt(self.x ^ 2 + self.y ^ 2)
end

function vec2.scalar(u, v)
    return u.x * v.x + u.y * v.y
end

function vec2.unitTest()
    assert(vec2(1,2) == vec2(1,2))
    assert(vec2():set(1,2) == vec2(1,2))
    assert(vec2.random() ~= vec2.random())
    assert(vec2.random(10000) ~= vec2.random(10000))
    assert(vec2.random(1, 1) == vec2.random(1, 1))
    assert(vec2():len() == 0)
    assert(vec2(1,2):scalar(vec2(2,2)) == 6)
end
