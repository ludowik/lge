Mouse = class()

ENDING = 'ending'
PRESSED = 'pressed'
MOVING = 'moving'
RELEASED = 'released'

function Mouse:init()
    self.position = vec2()
    self.startPosition = vec2()
    self.endPosition = vec2()
    self.previousPosition = vec2()
    self.move = vec2()
    self.deltaPos = vec2()
    self.direction = nil
    self.state = ENDING
end

function Mouse:pressed(x, y)
    self.state = PRESSED
    
    self.position:set(x-X, y-Y)    
    self.previousPosition:set(mouse.position)

    self.startPosition:set(mouse.position)
    self.endPosition:set(mouse.position)    

    self.move:set()
    self.deltaPos:set()

    self.direction = nil

    self.startTime = time()
    self.endTime = self.startTime
    self.elapsedTime = 0
end

function Mouse:moved(x, y)
    self.state = MOVING

    self.previousPosition:set(mouse.position)
    self.position:set(x-X, y-Y)

    self.endPosition:set(mouse.position)
    self.move:set(mouse.endPosition - mouse.startPosition)
    self.deltaPos:set(mouse.endPosition - mouse.previousPosition)

    self.endTime = time()
    self.elapsedTime = self.endTime - self.startTime
end

function Mouse:released(x, y)
    self.state = RELEASED
    
    self.previousPosition:set(mouse.position)
    self.position:set(x-X, y-Y)

    self.endPosition:set(mouse.position)    
    self.move:set(mouse.endPosition - mouse.startPosition)
    self.deltaPos:set(mouse.endPosition - mouse.previousPosition)

    self.endTime = time()
    self.elapsedTime = self.endTime - self.startTime
end

function Mouse:getDirection(len)
    if self.direction then return end
    
    len = len or (min(W, H) / 6)
    if max(abs(mouse.move.x), abs(mouse.move.y)) < len then
        return
    end

    if min(abs(mouse.move.x), abs(mouse.move.y)) < 0.5 * max(abs(mouse.move.x), abs(mouse.move.y)) then
        if abs(mouse.move.x) > abs(mouse.move.y) then
            self.direction = mouse.move.x < 0 and 'left' or 'right'
        else
            self.direction = mouse.move.y < 0 and 'up' or 'down'
        end
    end

    return self.direction
end

mouse = Mouse()
