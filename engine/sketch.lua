Sketch = class() : extends(Index, State, Rect, MouseEvent, KeyboardEvent)

function Sketch.setup()
    Sketch.fb = nil    
end

function Sketch:init()
    env.sketch = self

    self:setMode(W, H)

    Index.init(self)
    State.init(self)
    MouseEvent.init(self)
    KeyboardEvent.init(self)

    self:initMenu()

    self.tweenManager = TweenManager()
    self.scene = nil
end

function Sketch:__tostring()
    return self.__className
end

function Sketch:setMode(w, h, persistence)    
    Rect.init(self, 0, 0, w, h)

    self.persistence = persistence

    if self.persistence then
        self.fb = FrameBuffer(w, h)
    else
        Sketch.fb = Sketch.fb or FrameBuffer(w, h)
        self.fb = Sketch.fb
    end
end

function Sketch:setup()
end

function Sketch:pause()
end

function Sketch:resume()
end

function Sketch:resize()
end

function Sketch:update()
end

function Sketch:initMenu()
    self.parameter = Parameter('right')
    self.parameter:group(nil, true)
end

function Sketch:checkReload()
    local fileInfo = love.filesystem.getInfo(env.__sourceFile)
    if fileInfo.modtime > env.__modtime then
        env.__modtime = fileInfo.modtime
        engine.reload(true)
    end
end

function Sketch:updateSketch(dt)
    if self.loopMode == 'none' then return end
    self:checkReload()

    if env.__autotest and self.autotest then
        self:autotest()
    end

    self.tweenManager:update(dt)

    local scene = self.scene or env.scene
    if scene then
        scene:update(dt)
    end
    if self.update then
        self:update(dt)
    end
end

function Sketch:drawSketch(force)
    self:renderSketch()
    self:presentSketch(force)
end

function Sketch:renderSketch()
    if self.loopMode == 'none' then return end

    love.graphics.setCanvas({
        self.fb.canvas,
        stencil = false,
        depth = true,
    })
    love.graphics.clear(false, false, true)
    love.graphics.setWireframe(env.__wireframe and true or false)

    resetMatrix(true)
    resetStyle(getOrigin())

    self:draw()

    if self.loopMode == 'redraw' then
        self.loopMode = 'none'
    end
end

function Sketch:presentSketch(force)
    love.graphics.setCanvas()
    love.graphics.setShader()
    love.graphics.setDepthMode()
    love.graphics.setWireframe(false)

    love.graphics.setColor(colors.white:rgba())
    love.graphics.setBlendMode('replace')

    love.graphics.origin()

    if getOrigin() == BOTTOM_LEFT then
        love.graphics.scale(1, -1)
        love.graphics.translate(0, -H)
    end

    local ws, hs, flags = love.window.getMode()

    local sx = self.size.x / self.fb.canvas:getWidth()
    local sy = self.size.y / self.fb.canvas:getHeight()

    local scale = min(ws/self.fb.canvas:getWidth(), hs/self.fb.canvas:getHeight())

    love.graphics.draw(self.fb.canvas,
        0, -- self.position.x,
        0, -- self.position.y,
        0, -- rotation
        scale * sx, -- scale x
        scale * sy) -- scale y

    -- TODO : gérer un zoom
    -- TODO : gérer une translation
    -- TODO : gérer un pixelRatio

    if force then
        love.graphics.present()
    end
end

function Sketch:draw()
    background()

    if env.zoom then
        scale(env.zoom)
    end

    local scene = self.scene or env.scene
    if scene then
        scene:layout()
        scene:draw()
    else
        fontSize(W / 4)

        textMode(CENTER)
        text(self.__className, self.size.x / 2, self.size.y / 2)
    end
end

function Sketch:drawGameOver()
    resetMatrix()

    background(0, 0, 0, 0.5)

    stroke(colors.white)
    fill(colors.black)

    fontSize(50)
    local gameOver = 'Game Over'
    local w, h = textSize(gameOver)

    rectMode(CENTER)
    rect(CX, CY, w*1.2, h*1.2, 20)

    textMode(CENTER)
    text(gameOver, CX, CY)    
end

function Sketch:autotest()
    self.parameter:randomizeParameter()
end

function Sketch:mousepressed(mouse)
    self.active = true

    local scene = self.scene or env.scene
    if scene then
        return scene:mousepressed(mouse)
    end
end

function Sketch:mousemoved(mouse)
    local camera = self.cam
    if camera then
        if camera.mode == MODEL then
            -- camera.angleX = camera.angleX + mouse.deltaPos.y * TAU / (CX)
            camera.angleY = camera.angleY + mouse.deltaPos.x * TAU / (CX)
        else
            local direction = camera.target - camera.eye 
            direction:rotateInPlace(mouse.deltaPos.x * TAU / (CX))
            camera.target:set(camera.eye + direction)
        end
    end

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

function Sketch:wheelmoved(dx, dy)
    local camera = self.cam
    if camera then
        local direction = camera.target - camera.eye 
        camera.eye.x = camera.eye.x + dx / 10.
        camera.eye.y = camera.eye.y + dy / 10.
        camera.target:set(camera.eye + direction)
    end

    if env.zoom then
        local ratio = 1.2
        if dy > 0 then
            env.zoom = env.zoom * ratio
        else
            env.zoom = env.zoom / ratio
        end
    end
end

function setOrigin(origin)
    env.__origin = origin or TOP_LEFT
end

function getOrigin(origin)
    return env.__origin or TOP_LEFT
end
