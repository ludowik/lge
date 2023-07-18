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

function Mouse:getDirection()    
    if max(abs(mouse.move.x), (mouse.move.y)) < W/4 then
        return
    end

    if abs(mouse.move.x) > abs(mouse.move.y) then
        return mouse.move.x < 0 and 'left' or 'right'
    else
        return mouse.move.y < 0 and 'up' or 'down'
    end
end

mouse = Mouse()
