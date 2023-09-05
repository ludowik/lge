vec2 = class()

function vec2:init(x, y)
    self:set(x, y)
end

function vec2:set(x, y)
    if type(x) == 'table' then
        x, y = x.x, x.y
    end
    
    self.x = x or 0
    self.y = y or 0

    return self
end

function vec2.fromAngle(angle)
    return vec2(cos(angle), sin(angle))
end

function vec2:clone()
    return vec2(self.x, self.y)
end

function vec2:__tostring()
    if isinteger(self.x) and isinteger(self.y) then
        return string.format("%2d,%2d", self.x, self.y)
    else
        return string.format("%.2f,%.2f", self.x, self.y)
    end
end

function vec2.__eq(u, v)
    return
        (u.x == v.x) and
        (u.y == v.y)
end

function vec2.__add(u, v)
    return vec2(
        u.x + v.x,
        u.y + v.y)
end

function vec2.add(u, v)
    u.x = u.x + v.x
    u.y = u.y + v.y
    return u
end

function vec2.__sub(u, v)
    return vec2(
        u.x - v.x,
        u.y - v.y)
end

function vec2.sub(u, v)
    u.x = u.x - v.x
    u.y = u.y - v.y
    return u
end

function vec2.__mul(u, coef)
    return vec2(
        u.x * coef,
        u.y * coef)
end

function vec2.mul(u, coef)
    u.x = u.x * coef
    u.y = u.y * coef
    return u
end

function vec2.__div(u, coef)
    return vec2(
        u.x / coef,
        u.y / coef)
end

function vec2.div(u, coef)
    u.x = u.x / coef
    u.y = u.y / coef
    return u
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

function vec2:dist(v)
    return (v-self):len()
end

function vec2:len()
    return sqrt(self.x ^ 2 + self.y ^ 2)
end

function vec2:normalize(len)
    local ratio = (len or 1) / self:len()
    self.x = self.x * ratio
    self.y = self.y * ratio
end

function vec2.scalar(u, v)
    return u.x * v.x + u.y * v.y
end

function vec2:floor()
    self.x = floor(self.x)
    self.y = floor(self.y)

    return self
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
