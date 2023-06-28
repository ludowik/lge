Sketch = class() : extends(Index, State, Rect, Image)

process = {}
function Sketch:init(w, h)
    table.insert(process, self)

    State.init(self)
    Index.init(self)

    local ws, hs

    if w then
        ws, hs = w, h
    else 
        w = w or W
        h = h or H
        ws, hs = w/3, h/3
    end
    
    Rect.init(self,
        #process * W/20,
        #process * W/20,
        ws,
        hs)

    Image.init(self, w, h)
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
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle('line', 1, 1, W-2, H-2)
    end

    love.graphics.setCanvas()
    love.graphics.reset()
    love.graphics.draw(self.canvas,
        X + self.position.x, -- x
        Y + self.position.y, -- y
        0, -- rotation
        self.size.x / self.canvas:getWidth(), -- scale X
        self.size.y / self.canvas:getHeight()) -- scale Y
end

function Sketch:mousepressed(mouse)
    self.active = true
end

function Sketch:mousemoved(mouse)
end

function Sketch:mousereleased(mouse)
    self.active = false
end
