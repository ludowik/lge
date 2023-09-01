MouseEvent = class()

function MouseEvent:init()
end

function MouseEvent:mousepressed(mouse)
end

function MouseEvent:mousemoved(mouse)
end

function MouseEvent:mousereleased(mouse)
    self:click()
end

function MouseEvent:click()
    if self.callback then
        self:callback()
        return true
    end    
end

KeyboardEvent = class()

function KeyboardEvent:init()
end

function KeyboardEvent:keypressed(key, scancode, isrepeat)
    self:click()
end
