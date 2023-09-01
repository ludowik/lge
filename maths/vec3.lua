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
