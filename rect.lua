vec2 = class()

function vec2:init()
    self.x, self.y = 0, 0
end

Rect = class()

function Rect:init()
    self.position = vec2()
    self.size = vec2()
end
