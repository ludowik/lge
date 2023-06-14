Sketch = class():extends(State):extends(Index):extends(Rect)

function Sketch:init()
    State.init(self)
    Index.init(self)
    Rect.init(self)
end

function Sketch:updateSketch(dt)
    self:update?(dt)
end

function Sketch:drawSketch()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.setScissor(self.position.x, self.position.y, self.size.x, self.size.y)

    self:draw?()
end
