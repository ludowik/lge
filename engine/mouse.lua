Mouse = class()

function Mouse:init()
    self.position = vec2()
    self.startPosition = vec2()
    self.endPosition = vec2()
    self.previousPosition = vec2()
    self.move = vec2()
end

function Mouse:pressed(x, y)
    self.position:set(x-X, y-Y)
    self.startPosition:set(mouse.position)
    self.endPosition:set(mouse.position)
    self.previousPosition:set(mouse.position)
end

function Mouse:moved(x, y)
    self.previousPosition:set(mouse.position)
    self.position:set(x-X, y-Y)
    self.endPosition:set(mouse.position)
    self.move:set(mouse.endPosition - mouse.startPosition)
end

function Mouse:released(x, y)
    self.previousPosition:set(mouse.position)
    self.position:set(x-X, y-Y)
    self.endPosition:set(mouse.position)
    self.move:set(mouse.endPosition - mouse.startPosition)
end

mouse = Mouse()
