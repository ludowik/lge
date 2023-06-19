Sketch = class():extends(Index, State, Rect, Image)

function Sketch:init(w, h)
    w = w or W
    h = h or H

    State.init(self)
    Index.init(self)
    Rect.init(self, 0, 0, w, h)

    self.size.x = w
    self.size.y = h

    Image.init(self, w, h)
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
