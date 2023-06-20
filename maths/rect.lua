Rect = class()

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
end
