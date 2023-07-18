Sketch = class() : extends(Index, State, Rect, Image, MouseEvent, KeyboardEvent)

function Sketch:init(w, h)
    process:add(self)

    State.init(self)
    Index.init(self)
    MouseEvent.init(self)

    local ws, hs

    if w then
        ws, hs = w, h
    else 
        w = w or (2*X+W)
        h = h or (2*Y+H)
        ws, hs = w/3, h/3
    end
    
    Rect.init(self, 0, 0, w, h)

    Image.init(self, w, h)

    self:initMenu()
end

function Sketch:initMenu()
    self.parameter = Parameter()
    self.parameter:initMenu()
    self.parameter:group(self.__className, true)
end

function Sketch:updateSketch(dt)    
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch()
    love.graphics.setCanvas()
    love.graphics.clear(0.1, 0.5, 0.1, 1)

    self:setContext()

    resetStyle()
    resetMatrix()

    self:draw()
    
    love.graphics.setCanvas()
    love.graphics.setColor(colors.white:rgba())

    love.graphics.origin()
    love.graphics.draw(self.canvas,
        self.position.x, -- x
        self.position.y, -- y
        0, -- rotation
        self.size.x / self.canvas:getWidth(), -- scale x
        self.size.y / self.canvas:getHeight()) -- scale y

    -- if not love.filesystem.isFused() then
    --     resetStyle()
    --     resetMatrix()
        
    --     textMode(CORNER)
    --     text(self.__className, 0, 0)
    -- end
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
