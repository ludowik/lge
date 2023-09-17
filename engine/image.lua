FrameBuffer = class()

function FrameBuffer:init(w, h)
    self.canvas = love.graphics.newCanvas(w, h, {
        msaa = 5
    })

    local currentCanvas = love.graphics.getCanvas()
    self:setContext()
    self:background(colors.transparent)

    love.graphics.setCanvas(currentCanvas)
end

function FrameBuffer:setContext()
    love.graphics.setCanvas(self.canvas)
end

function FrameBuffer:background(...)
    clr = Color.fromParam(clr, ...) or colors.black
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

function FrameBuffer:getImageData()
    if self.imageData then return end
    self.imageData = self.canvas:newImageData()
end

function FrameBuffer:update()
    if self.imageData then
        self.texture = love.graphics.newImage(self.imageData)
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
    self.texture = love.graphics.newImage(filename)
end

function Image:update()
end
