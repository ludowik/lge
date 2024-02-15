FrameBuffer = class()

function FrameBuffer:init(w, h, format)
    self.format = format or 'normal'
    self.canvas = love.graphics.newCanvas(w, h, {
        msaa = 5,
        format = self.format
    })

    self:setContext()
    self:background(colors.transparent)

    resetContext()

    self.width = w
    self.height = h
end

function FrameBuffer:copy(fb)
    local fb = FrameBuffer(self.width, self.height, self.format)    
    fb:setContext()

    love.graphics.draw(self.canvas)

    fb:getImageData()

    resetContext()

    return fb
end

function FrameBuffer:release()
    self.imageData:release()
    self.canvas:release()
end

function FrameBuffer:setContext()
    setContext(self)
end

function FrameBuffer:background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

function FrameBuffer:getImageData()
    if self.imageData then return end
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
    if self.imageData then
        self.texture = love.graphics.newImage(self.imageData, {dpiscale=devicePixelRatio})
        self.texture:setWrap('repeat')
    end
end

function FrameBuffer:set(x, y, clr, ...)
    self:getImageData()
    if type(clr) == 'table' then
        self.imageData:setPixel(x, y, clr:rgba())
    else
        self.imageData:setPixel(x, y, clr, ...)
    end
end

function FrameBuffer:get(x, y)
    self:getImageData()
    return self.imageData:getPixel(x, y)
end

Image = class() : extends(FrameBuffer)

function Image:init(filename, ...)
    self.imageData = love.image.newImageData(filename, {dpiscale=devicePixelRatio})
    self:update()

    self.width = self.texture:getWidth()
    self.height = self.texture:getHeight()
end
