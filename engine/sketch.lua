Sketch = class() : extends(Index, State, Rect, Image)

function Sketch:init(w, h)
    State.init(self)
    Index.init(self)

    w = w or W
    h = h or H
    Rect.init(self, 0, 0, w, h)

    Image.init(self, self.size.x, self.size.y)
end

function Sketch:updateSketch(dt)
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch()
    self:setContext()

    self:draw()

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.position.x, self.position.y, 0, 1, 1)
end
