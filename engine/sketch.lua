Sketch = class() : extends(Index, State, Rect, MouseEvent, KeyboardEvent)

local fb

function Sketch:init(w, h)
    env.sketch = self

    Index.init(self)
    State.init(self)

    if not w then
        w = w or (2 * X + W)
        h = h or (2 * Y + H)
    end

    Rect.init(self, 0, 0, w, h)

    fb = fb or FrameBuffer(w, h)
    self.fb = fb

    MouseEvent.init(self)
    KeyboardEvent.init(self)

    self.tweenManager = TweenManager()

    self:initMenu()

    self.scene = nil
end

function Sketch:__tostring()
    return self.__className
end

function Sketch:setup()
end

function Sketch:autotest()
    self.parameter:randomizeParameter()
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
    if self.frames and self.frames == 0 then return end
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
    local processDraw = true
    if self.frames then
        if self.frames == 0 then
            processDraw = false
        else
            self.frames = self.frames - 1
        end
    end

    if processDraw then
        love.graphics.setCanvas({
            self.fb.canvas,
            stencil = false,
            depth = true,
        })
        love.graphics.clear(false, false, true)

        resetMatrix(true)
        resetStyle(getOrigin())

        self:draw()
    end

    love.graphics.setCanvas()
    love.graphics.setShader()
    love.graphics.setDepthMode()
    love.graphics.setWireframe(false)

    love.graphics.setColor(colors.white:rgba())
    love.graphics.setBlendMode('replace')

    love.graphics.origin()

    if getOrigin() == BOTTOM_LEFT then
        love.graphics.scale(1, -1)
        love.graphics.translate(0, -(2 * Y + H))
    end

    local sx = self.size.x / self.fb.canvas:getWidth()
    local sy = self.size.y / self.fb.canvas:getHeight()

    if self.sketchPixelRatio then
        love.graphics.translate(X, Y)
        love.graphics.scale(self.sketchPixelRatio, self.sketchPixelRatio)
        love.graphics.translate(-X, -Y)
    end

    love.graphics.draw(self.fb.canvas,
        self.position.x, -- x
        self.position.y, -- y
        0,               -- rotation
        sx,              -- scale x
        sy)              -- scale y

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
    rect(W/2, H/2, w*1.2, h*1.2, 20)

    textMode(CENTER)
    text(gameOver, W/2, H/2)    
end

function Sketch:mousepressed(mouse)
    self.active = true

    local scene = self.scene or env.scene
    if scene then
        return scene:mousepressed(mouse)
    end
end

function Sketch:mousemoved(mouse)
    if self.cam then
        self.cam.angleX = self.cam.angleX + mouse.deltaPos.y * TAU / (W/2)
        self.cam.angleY = self.cam.angleY + mouse.deltaPos.x * TAU / (W/2)
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
