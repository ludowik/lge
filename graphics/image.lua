FrameBuffer = class()

function FrameBuffer:init(w, h, format, clr)
    self.format = format or 'normal'
    self.canvas = love.graphics.newCanvas(w, h, {
        format = self.format,
        msaa = 5,
        dpiscale = dpiscale,
    })
    self.canvas:setFilter('linear', 'linear')
    
    self:background(clr or colors.transparent)
    
    self.width = self.canvas:getWidth()
    self.height = self.canvas:getHeight()
end

function FrameBuffer:copy(x, y, w, h)
    x, y = x or 0, y or 0
    w, h = w or self.width, h or self.height

    self:update()
    
    local fb = FrameBuffer(w, h, self.format)    
    fb:render(function ()
        tint(colors.white)
        pushStyles()
        spriteMode(CORNER)
        sprite(self, 0, 0, w, h, x, y, w, h)
    end)

    return fb
end

function FrameBuffer:getWidth()
    return self:getTexture():getWidth()
end

function FrameBuffer:getHeight()
    return self:getTexture():getHeight()
end

function FrameBuffer:resize(w, h)
    assert(w and h)

    self:update()
    
    local fb = FrameBuffer(w, h, self.format)    
    fb:render(function ()
        tint(colors.white)
        sprite(self, 0, 0, w, h)
    end)

    return fb
end

function FrameBuffer:getTexture()
    return self.texture or self.canvas
end

function FrameBuffer:release()
    if self.imageData then
        self.imageData:release()
        self.imageData = nil
    end
    
    self.canvas:release()
    self.canvas = nil
end

function FrameBuffer:setContext()
    self.previousCanvas = love.graphics.getCanvas()

    love.graphics.setCanvas({
        self.canvas,
        stencil = false,
        depth = true,
    })

    pushMatrix()
    resetMatrixContext()
end

function FrameBuffer:resetContext()
    popMatrix()
    love.graphics.setCanvas({self.previousCanvas})
end

function FrameBuffer:background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black

    local previous = love.graphics.getCanvas()
    love.graphics.setCanvas({self.canvas})
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a, true, false, 1)
    love.graphics.setCanvas({previous})

    self.imageData = nil
end

function FrameBuffer:getImageData()
    if self.imageData then
        return self.imageData
    end

    local restoreCanvas = false
    if love.graphics.getCanvas() == self.canvas then
        restoreCanvas = true
        love.graphics.setCanvas()
    end

    local getImageData = love.graphics.readbackTexture or self.canvas.newImageData
    self.imageData = getImageData(self.canvas)

    self.texture = love.graphics.newImage(self.imageData, {
        dpiscale = dpiscale,
        linear = true
    })
    
    if restoreCanvas then
        love.graphics.setCanvas({self.canvas})
    end

    self.needUpdate = true

    return self.imageData
end

function FrameBuffer:update()
    if self.imageData and (self.texture == nil or self.needUpdate == true) then
        self.needUpdate = false
        self.texture:replacePixels(self.imageData)
    end
end

function FrameBuffer:render(f)
    self:setContext()
    f()
    self:resetContext()
end

function FrameBuffer:mapPixel(f)
    self:getImageData()
    self.needUpdate = true
    
    self.imageData:mapPixel(f)
    self:update()
end

function FrameBuffer:set(x, y, clr, ...)
    error('unsupported => use setPixel')
end

function FrameBuffer:setPixel(x, y, r, g, b, a)
    self:getImageData()
    self.needUpdate = true

    if type(r) == 'table' then
        self.imageData:setPixel(x, y, r:rgba())
    else
        self.imageData:setPixel(x, y, r, g, b, a)
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

GRAY = 'gray'

function FrameBuffer:filter(filterType)
    if filterType == GRAY then
        self:mapPixel(function (x, y, r, g, b, a)
            return Color(r, g, b, a):grayscale():unpack()
        end)
    end
end


local function scan(path, files)
    files = files or Array()

    local directoryItems = love.filesystem.getDirectoryItems(path)
    for _,itemName in ipairs(directoryItems) do
        local filePath = path..'/'..itemName
        local info = love.filesystem.getInfo(filePath)
        if info.type == 'directory' then
            scan(filePath, files)
        else
            files[itemName:lower()] = filePath:lower()
        end
    end
    return files
end

local function find(filename)
    filename = filename:lower()
    if love.filesystem.getInfo(filename) then return filename end
    local files = scan('resources/images')
    return files[filename]
end        


Image = class() : extends(FrameBuffer)

function Image:init(filename, ...)
    local filepath = find(filename)

    if not filepath then
        echo('Image : '..filename..' not found')
        FrameBuffer.init(self, ...)
        return
    end

    local texture = love.graphics.newImage(filepath, {
        dpiscale = dpiscale,
        linear = true
    })
    texture:setFilter('linear', 'linear')
    
    local w, h = texture:getDimensions()
    FrameBuffer.init(self, w, h, texture:getFormat())
    
    self:render(function ()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(texture)
    end)
end
