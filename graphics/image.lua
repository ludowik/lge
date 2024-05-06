FrameBuffer = class()

function FrameBuffer:init(w, h, format, clr)
    self.format = format or 'normal'
    self.canvas = love.graphics.newCanvas(w, h, {
        msaa = 5,
        format = self.format
    })
    
    self:setContext()
    self:background(clr or colors.transparent)
    self:resetContext()
    
    self.width = w
    self.height = h
end

function FrameBuffer:copy(fb)
    self:update()
    
    local fb = FrameBuffer(self.width, self.height, self.format)    
    fb:setContext()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.canvas)

    fb:getImageData()
    fb:resetContext()

    return fb
end

function FrameBuffer:release()
    self.imageData:release()
    self.imageData = nil
    
    self.canvas:release()
    self.canvas = nil
end

function FrameBuffer:setContext()
    setContext(self)
    resetMatrixContext()
end

function FrameBuffer:resetContext()
    resetContext()
end

function FrameBuffer:background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

function FrameBuffer:getImageData()
    if self.imageData then
        self.needUpdate = true
        return
    end

    local getImageData = love.graphics.readbackTexture or self.canvas.newImageData

    local restoreCanvas = false
    if love.graphics.getCanvas() == self.canvas then
        restoreCanvas = true
        love.graphics.setCanvas()
    end

    self.imageData = getImageData(self.canvas)

    if restoreCanvas then
        love.graphics.setCanvas(self.canvas)
    end

    return self.imageData
end

function FrameBuffer:update()
    if self.imageData and (self.texture == nil or self.needUpdate == true) then
        self.needUpdate = false

        self.texture = love.graphics.newImage(self.imageData, {
            dpiscale = devicePixelRatio
        })
        self.texture:setWrap('repeat')

        -- self:setContext()

        -- love.graphics.setColor(1, 1, 1)
        -- love.graphics.draw(self.texture)

        -- self:resetContext()
    end
end

function FrameBuffer:set(x, y, clr, ...)
    error('unsupported => use setPixel')
end

function FrameBuffer:setPixel(x, y, clr, ...)
    self:getImageData()
    self.needUpdate = true

    if type(clr) == 'table' then
        self.imageData:setPixel(x, y, clr:rgba())
    else
        self.imageData:setPixel(x, y, clr, ...)
    end
end

function FrameBuffer:get(x, y, clr)
    error('unsupported => use getPixel')
end

function FrameBuffer:getPixel(x, y, clr)
    self:getImageData()

    if clr then
        local r, g, b, a = self.imageData:getPixel(x, y)    
        clr:set(r, g, b, a)
        return r, g, b, a
    else
        return self.imageData:getPixel(x, y)
    end
end

Image = class() : extends(FrameBuffer)

function Image:init(filename, ...)
    if love.filesystem.getInfo(filename) == nil then
        log('Image : '..filename..' not found')
        FrameBuffer.init(self, ...)
        return
    end

    self.texture = love.graphics.newImage(filename, {
        dpiscale = devicePixelRatio,
    })

    local w, h =  self.texture:getDimensions()
    FrameBuffer.init(self, w, h, self.texture:getFormat())

    self:setContext()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.texture)
    
    self:resetContext()
end
