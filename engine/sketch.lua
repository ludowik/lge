Sketch = class():extends(Index, State, Rect)

function Sketch:init()
    State.init(self)
    Index.init(self)
    Rect.init(self)

    self.size.x = 640 
    self.size.y = 480
end

function Sketch:updateSketch(dt)
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.setScissor(self.position.x, self.position.y, self.size.x, self.size.y)

    self:draw()
end
