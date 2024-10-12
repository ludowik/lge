Box = class()

function Box:init(position, size)
    self.position = position and position:clone() or vec3()
    self.size = size and size:clone() or vec3()
end

function Box:setPosition(...)
    self.position:set(...)
    return self
end

function Box:setSize(...)
    self.size:set(...)
    return self
end

function Box.random(pw, ph, pd, sw, sh, sd)
    return Box():randomize(pw, ph, pd, sw, sh, sd)
end

function Box:randomize(pw, ph, pd, sw, sh, sd)
    pw = pw or W 
    ph = ph or H
    pd = pd or W
    self.position:randomize(pw, ph, pd)

    sw = sw or (W-self.position.x)
    sh = (sh or sw) or (H-self.position.y)
    sd = (sd or sh or sw) or (W-self.position.y)
    self.size:randomize(sw, sh, sd)
    return self
end

function Box:contains(position)
    if (position.x >= self.position.x and
        position.y >= self.position.y and
        position.z >= self.position.z and
        position.x <= self.position.x + self.size.x and
        position.y <= self.position.y + self.size.y and
        position.z <= self.position.z + self.size.z)
    then
        return self
    end
end

function Box.intersect(r1, r2)
    if (r1.position.x > r2.position.x + r2.size.x or        
        r2.position.x > r1.position.x + r1.size.x or
        r1.position.y > r2.position.y + r2.size.y or
        r2.position.y > r1.position.y + r1.size.y or
        r1.position.z > r2.position.z + r2.size.z or
        r2.position.z > r1.position.z + r1.size.z)
    then
        return false
    else
        return true
    end
end

function Box:draw()
    noStroke()
    fill(self.clr or colors.white)
    box(self.position.x, self.position.y, self.position.z, self.size.x, self.size.y, self.size.z)
end

function Box:drawBorder()
    stroke(self.clr or colors.white)
    noFill()
    boxBorder(self.position.x, self.position.y, self.position.z, self.size.x, self.size.y, self.size.z)
end
