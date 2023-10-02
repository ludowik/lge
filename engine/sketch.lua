Sketch = class() : extends(Index, State, Rect, MouseEvent, KeyboardEvent)

local fb

function Sketch.__index(self, key)
    local value = rawget(self, key) or rawget(Sketch, key)
    warning(value, key..' variable never initialized')
    return value
end

function Sketch:init(w, h)
    Index.init(self)
    State.init(self)

    local ws, hs

    if w then
        ws, hs = w, h
    else 
        w = w or (2*X+W)
        h = h or (2*Y+H)
        ws, hs = w/3, h/3
    end
    
    Rect.init(self, 0, 0, w, h)

    --FrameBuffer.init(self, w, h)
    fb = fb or FrameBuffer(w, h)
    self.fb = fb

    MouseEvent.init(self)
    KeyboardEvent.init(self)

    self.tweenManager = TweenManager()

    self:initMenu()

    processManager:add(self)
end

function Sketch:__tostring()
    return self.__className
end

function Sketch:initMenu()
    self.parameter = Parameter('right')
    self.parameter:group(nil, true)
end

function Sketch:checkReload()
    local fileInfo = love.filesystem.getInfo(env.__sourceFile)
    if fileInfo.modtime > env.__modtime then
        env.__modtime = fileInfo.modtime
        reload(true)
    end
end

function Sketch:updateSketch(dt)
    if self.frames and self.frames == 0 then return end
    self:checkReload()
    
    self.tweenManager:update(dt)

    local scene = self.scene or env.scene
    if scene then
        scene:update(dt)
    end
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch()
    local processDraw = true
    if self.frames then
        if self.frames == 0 then
            processDraw = false
        else
            self.frames = self.frames - 1
        end
    end

    if processDraw then
        -- love.graphics.setCanvas()
        -- love.graphics.setShader()
        
        -- love.graphics.clear(0.1, 0.5, 0.1, 1)

        love.graphics.setCanvas(self.fb.canvas)

        resetStyle()
        resetMatrix()

        self:draw()
    end
    
    love.graphics.setCanvas()
    love.graphics.setShader()

    love.graphics.setColor(colors.white:rgba())
    love.graphics.setBlendMode('replace')

    love.graphics.origin()

    if setOrigin() == BOTTOM_LEFT then
        love.graphics.scale(1, -1)
        love.graphics.translate(0, -(2*Y+H))
    end

    love.graphics.draw(self.fb.canvas,
        self.position.x, -- x
        self.position.y, -- y
        0, -- rotation
        self.size.x / self.fb.canvas:getWidth(), -- scale x
        self.size.y / self.fb.canvas:getHeight()) -- scale y
end

function Sketch:draw()
    background()

    local scene = self.scene or env.scene
    if scene then
        scene:layout()
        scene:draw()
    else
        fontSize(W/4)

        textMode(CENTER)
        text(self.__className, self.size.x/2, self.size.y/2)
    end
end

function Sketch:mousepressed(mouse)
    self.active = true

    local scene = self.scene or env.scene
    if scene then
        return scene:mousepressed(mouse)
    end
end

function Sketch:mousemoved(mouse)
    local scene = self.scene or env.scene
    if scene then
        return scene:mousemoved(mouse)
    end
end

function Sketch:mousereleased(mouse)
    self.active = false

    local scene = self.scene or env.scene
    if scene then
        return scene:mousereleased(mouse)
    end
end
