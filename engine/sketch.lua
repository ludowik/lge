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
    self.loopMode = 'loop'
end

function Sketch:__tostring()
    return self.__className
end

function Sketch:setMode(w, h, persistence)    
    Rect.init(self, 0, 0, w, h)

    self.persistence = persistence

    SCALE_CANVAS = 1

    w = w / SCALE_CANVAS
    h = h / SCALE_CANVAS
    
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
    self.parameter:group(self, true)

    self.bar = Bar()
end

function Sketch:checkReload()
    local fileInfo = love.filesystem.getInfo(env.__filePath)
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

    setSetting('assertLoadIsKO', true)

    local scene = self.scene or env.scene
    if scene then
        scene:update(dt)
    end
    if self.update then
        self:update(dt)
    end

    setSetting('assertLoadIsKO', nil)
end

function Sketch:setCanvas(clear)
    self.previousCanvas = love.graphics.getCanvas()

    love.graphics.setCanvas({
        self.fb.canvas,
        stencil = false,
        depth = true,
    })

    
    if clear then
        love.graphics.clear(0, 0, 0, 1, true, false, 1)
    else
        love.graphics.clear(false, false, true)
    end

    love.graphics.setWireframe(env.__wireframe and true or false)
end

function Sketch:resetCanvas()
    love.graphics.setCanvas(self.previousCanvas)
end

function Sketch:drawSketch(force)
    if self.directDraw then
        self:draw()
    else
        self:renderSketch()
        self:presentSketch(force)
    end
end

function Sketch:renderSketch()
    if self.loopMode == 'none' then return end

    self:setCanvas()

    resetMatrix(true)
    resetStyle(getOrigin())
    
    scale(1/SCALE_CANVAS, 1/SCALE_CANVAS)

    self:draw()

    if self.loopMode == 'redraw' then
        self.loopMode = 'none'
    end

    self:resetCanvas()
end

function Sketch:presentSketch(force)
    love.graphics.setCanvas()
    setShader()
    love.graphics.setDepthMode()
    love.graphics.setWireframe(false)

    love.graphics.setColor(colors.white:rgba())
    love.graphics.setBlendMode('replace')

    local fb = self.fb
    local canvas = fb.canvas
    local texture = fb.texture or fb.canvas

    local ws, hs, flags = love.window.getMode()

    local sx = self.size.x / canvas:getWidth()
    local sy = self.size.y / canvas:getHeight()

    love.graphics.origin()

    if getOrigin() == BOTTOM_LEFT then
        love.graphics.translate(0, SCALE * sy * H)
        love.graphics.scale(1, -1)
    end

    love.graphics.draw(texture,
        0, -- self.position.x,
        0, -- self.position.y,
        0, -- no rotation
        SCALE * sx, -- scale x
        SCALE * sy) -- scale y

    if force then
        Graphics.flush()
    end
end

function Sketch:draw()
    background()

    if env.zoom then
        scale(env.zoom)
    end

    local scene = self.scene or env.scene
    if scene then
        scene:layout(scene.position.x, scene.position.y)
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
            camera.angleX = camera.angleX + mouse.deltaPos.y * TAU / (CX)
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
        camera.eye = camera.eye + direction * dy / 10
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
