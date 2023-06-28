Rect = class()

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
end

function Rect.random()
    return Rect():randomize()
end

function Rect:randomize()
    self.size:randomize(W, H)
    self.position:randomize(W-self.size.x, H-self.size.y)
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
