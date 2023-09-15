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

function vec3:clone()
    return vec3(self.x, self.y, self.z)
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
