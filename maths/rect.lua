Rect = class()

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
end

function Rect:__tostring()
    return tostring(self.position)..'/'..tostring(self.size)
end

function Rect:setPosition(...)
    self.position:set(...)
    return self
end

function Rect:setSize(...)
    self.size:set(...)
    return self
end

function Rect.random(pw, ph, sw, sh)
    return Rect():randomize(pw, ph, sw, sh)
end

function Rect:randomize(pw, ph, sw, sh)
    pw = pw or W 
    ph = ph or H
    self.position:randomize(pw, ph)

    sw = sw or (W-self.position.x)
    sh = (sh or sw) or (H-self.position.y)
    self.size:randomize(sw, sh)
    return self
end

function Rect:contains(position)
    if (position.x >= self.position.x and
        position.y >= self.position.y and
        position.x <= self.position.x + self.size.x and
        position.y <= self.position.y + self.size.y)
    then
        return self
    end
end

function Rect:intersect(r2)
	r1 = self
    if (r1.position.x > r2.position.x + r2.size.x or        
        r2.position.x > r1.position.x + r1.size.x or
        r1.position.y > r2.position.y + r2.size.y or
        r2.position.y > r1.position.y + r1.size.y)
    then
        return false
    else
        return true
    end
end

function Rect:getArea()
    return self.size.x * self.size.y
end

function Rect:draw()
    stroke(self.clr or colors.white)
    noFill()
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
end
