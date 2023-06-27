Sketch = class() : extends(Index, State, Rect, Image)

process = {}
function Sketch:init(w, h)
    table.insert(process, self)

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

    love.graphics.setFont(font)

    self:draw()

    if self.active then
        love.graphics.rectangle('fill', 0, 0, self.size.x, self.size.y)
    end

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas,
        X+self.position.x,
        Y+self.position.y, 0, 1, 1)
end

function Sketch:mousepressed(mouse)
    self.active = true
end

function Sketch:mousemoved(mouse)
end

function Sketch:mousereleased(mouse)
    self.active = false
end
