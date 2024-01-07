FrameBuffer = class()

function FrameBuffer:init(w, h, format)
    self.canvas = love.graphics.newCanvas(w, h, {
        msaa = 5,
        format = format or 'normal'
    })

    self:setContext()
    self:background(colors.transparent)

    resetContext()

    self.width = w
    self.height = h
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
        --self.imageData = nil
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
    return self.imageData:getPixel(x, y)
end

Image = class()

function Image:init(filename, ...)
    self.texture = love.graphics.newImage(filename, {dpiscale=devicePixelRatio})

    self.width = self.texture:getWidth()
    self.height = self.texture:getHeight()
end

function Image:update()
end
