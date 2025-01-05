Mouse = class()

ENDING = 'ending'
PRESSED = 'pressed'
MOVING = 'moving'
RELEASED = 'released'

function Mouse.setup()
    mouse = Mouse()
end

function Mouse:init()
    self.state = ENDING
    self.id = 0
    self.position = vec2()
    self.previousPosition = vec2()
    self.startPosition = vec2()
    self.endPosition = vec2()    
    self.move = vec2()
    self.deltaPos = vec2()
    self.direction = nil
    self.startTime = 0
    self.endTime = 0
    self.elapsedTime = 0
    self.presses = 0
end

function Mouse:pressed(id, x, y, presses)
    self.state = PRESSED
    self.id = id
    
    self.position:set(x, y)
    self.previousPosition:set(mouse.position)

    self.startPosition:set(mouse.position)
    self.endPosition:set(mouse.position)    

    self.move:set()
    self.deltaPos:set()

    self.direction = nil

    self.startTime = time()
    self.endTime = self.startTime
    self.elapsedTime = 0

    self.presses = presses
end

function Mouse:moved(id, x, y)
    self.state = MOVING
    self.id = id

    self.previousPosition:set(mouse.position)
    self.position:set(x, y)

    if love.mouse.isDown(1) then
        self.endPosition:set(mouse.position)
        self.move:set(mouse.endPosition - mouse.startPosition)
        self.deltaPos:set(mouse.endPosition - mouse.previousPosition)

        self.endTime = time()
        self.elapsedTime = self.endTime - self.startTime
    end
end

function Mouse:released(id, x, y, presses)
    self.state = RELEASED
    self.id = id
    
    self.previousPosition:set(mouse.position)
    self.position:set(x, y)

    self.endPosition:set(mouse.position)    
    self.move:set(mouse.endPosition - mouse.startPosition)
    self.deltaPos:set(mouse.endPosition - mouse.previousPosition)

    self.endTime = time()
    self.elapsedTime = self.endTime - self.startTime

    self.presses = presses
end

function Mouse:getDirection(minLen)
    if self.direction then return end
    
    minLen = minLen or (min(W, H) / 6)
    if max(abs(mouse.move.x), abs(mouse.move.y)) < minLen then
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
