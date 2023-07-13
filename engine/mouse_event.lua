MouseEvent = class()

function MouseEvent:init(mouse)
end

function MouseEvent:mousepressed(mouse)
    self:click()
end

function MouseEvent:mousemoved(mouse)
end

function MouseEvent:mousereleased(mouse)
end

function MouseEvent:click()
    if self.callback then
        self:callback()
        return true
    end    
end
