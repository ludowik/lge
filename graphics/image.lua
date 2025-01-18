FrameBuffer = class()

function FrameBuffer:init(w, h, format, clr)
    self.format = format or 'normal'
    self.canvas = love.graphics.newCanvas(w, h, {
        format = self.format,
        msaa = 5,
        dpiscale = dpiscale,
    })
    
    self:background(clr or colors.transparent)
    
    self.width = self.canvas:getWidth()
    self.height = self.canvas:getHeight()
end

function FrameBuffer:copy(fb)
    self:update()
    
    local fb = FrameBuffer(self.width, self.height, self.format)    
    fb:setContext()
    do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.canvas)
    end
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
    love.graphics.setCanvas(self.previousCanvas)
end

function FrameBuffer:background(clr, ...)
    clr = Color.fromParam(clr, ...) or colors.black

    local previous = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a, true, false, 1)
    love.graphics.setCanvas(previous)

    self.imageData = nil
end

function FrameBuffer:getImageData()
    if self.imageData then
        -- self.pointerData = ffi.cast('uint8_t*', self.imageData:getFFIPointer())
        return self.imageData
    end

    local restoreCanvas = false
    if love.graphics.getCanvas() == self.canvas then
        restoreCanvas = true
        love.graphics.setCanvas()
    end

    local getImageData = love.graphics.readbackTexture or self.canvas.newImageData
    self.imageData = getImageData(self.canvas)
    -- self.pointerData = ffi.cast('uint8_t*', self.imageData:getFFIPointer())

    if restoreCanvas then
        love.graphics.setCanvas(self.canvas)
    end

    self.needUpdate = true

    return self.imageData
end

function FrameBuffer:update()
    if self.imageData and (self.texture == nil or self.needUpdate == true) then
        self.needUpdate = false

        if self.texture then
            self.texture:release()
        end

        self.texture = love.graphics.newImage(self.imageData, {
            dpiscale = dpiscale,
        })
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
        -- local offset = (x + y * self.width) * 4
        -- self.pointerData[offset+0] = r * 255
        -- self.pointerData[offset+1] = g * 255
        -- self.pointerData[offset+2] = b * 255
        -- self.pointerData[offset+3] = (a or 1) * 255
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
        log('Image : '..filename..' not found')
        FrameBuffer.init(self, ...)
        return
    end

    self.texture = love.graphics.newImage(filepath, {
        dpiscale = dpiscale,
        linear = true
    })

    local w, h =  self.texture:getDimensions()
    FrameBuffer.init(self, w, h, self.texture:getFormat())

    self:setContext()
    do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.texture)
    end  
    self:resetContext()
end
