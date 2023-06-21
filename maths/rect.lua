Rect = class()

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
end

function Rect.random()
    return Rect():randomize()
end

function Rect:randomize()
    self.position:randomize()
    self.size:randomize()
end
