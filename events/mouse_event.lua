MouseEvent = class()

function MouseEvent:init()
    self.callback = nilf
end

function MouseEvent:mousepressed(mouse)
end

function MouseEvent:mousemoved(mouse)
end

function MouseEvent:mousereleased(mouse)
end

function MouseEvent:click(mouse)
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
