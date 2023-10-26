vec3 = class()

function vec3:init(x, y, z)
    self:set(x, y, z)
end

function vec3:set(x, y, z)
    if type(x) == 'table' then
        x, y, z = x.x, x.y, x.z
    end
    
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0

    return self
end

function vec3:add(v, factor)
    factor = factor or 1
    self.x = self.x + v.x * factor
    self.y = self.y + v.y * factor
    self.z = self.z + v.z * factor
    return self
end

function vec3:sub(v, factor)
    factor = factor or 1
    self.x = self.x - v.x * factor
    self.y = self.y - v.y * factor
    self.z = self.z - v.z * factor
    return self
end

function vec3:clone()
    return vec3(self.x, self.y, self.z)
end

function vec3.random(w, h, d)
    return vec3():randomize(w, h, d)
end

function vec3:randomize(w, h, d)
    if w then
        h = h or w
        d = d or w
        self.x = random(w)
        self.y = random(h)
        self.z = random(d)
    else
        self.x = random()
        self.y = random()
        self.z = random()
    end
    return self
end

function vec3:dist(v)
    return (v-self):len()
end

function vec3:len()
    return sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
end

function vec3:normalize(len)
    return vec3.clone(self):normalizeInPlace(len)
end

function vec3:normalizeInPlace(len)
    local ratio = (len or 1) / self:len()
    self.x = self.x * ratio
    self.y = self.y * ratio
    self.z = self.z * ratio
    return self
end
