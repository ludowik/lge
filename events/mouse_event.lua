MouseEvent = class()

function MouseEvent:init()
    self.callback = nilf
end

function MouseEvent:mousepressed(mouse)
    self.pressed = true

    eventManager.currentObjectTimer = 5
    eventManager.currentObjectPressed = true
    eventManager.currentObject = self
end

function MouseEvent:mousemoved(mouse)
end

function MouseEvent:mousereleased(mouse)
    eventManager.currentObjectPressed = false
end

function MouseEvent:click(mouse)
    eventManager.currentObjectPressed = false

    if self.callback and self.callback ~= nilf then
        self:callback()
        return true
    end    
end

KeyboardEvent = class()

function KeyboardEvent:init()
end

function KeyboardEvent:keypressed(key, scancode, isrepeat)
end
