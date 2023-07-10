Sketch = class() : extends(Index, State, Rect, Image)

function Sketch:init(w, h)
    process:add(self)

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
    
    Rect.init(self, 0, 0, w, h)
        -- #process * W/20,
        -- #process * W/20,
        -- ws,
        -- hs)

    Image.init(self, w, h)
end

function Sketch:updateSketch(dt)
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch()
    self:setContext()

    fontSize(22)

    self:draw()

    textMode(CORNER)
    text(self.__className, 0, 0)

    love.graphics.setCanvas()
    
    love.graphics.reset()
    love.graphics.setScissor(X, Y, W, H)
        
    love.graphics.draw(self.canvas,
        X + self.position.x, -- x
        Y + self.position.y, -- y
        0, -- rotation
        self.size.x / self.canvas:getWidth(), -- scale X
        self.size.y / self.canvas:getHeight()) -- scale Y
end

function Sketch:draw()
    background()
    text(self.__className, self.size.x/2, self.size.y/2)
end

function Sketch:mousepressed(mouse)
    self.active = true
    if self.scene then
        return self.scene:mousepressed(mouse)
    end
end

function Sketch:mousemoved(mouse)
end

function Sketch:mousereleased(mouse)
    self.active = false
end
