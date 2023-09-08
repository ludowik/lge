if getOS() == 'web' then return end

local ffi = try_require 'ffi'

Pixels = class() : extends(Sketch)

function Pixels:init()
    Sketch.init(self)

    self.pixelRatio = 4

    self.imageData = love.image.newImageData(W/self.pixelRatio, H/self.pixelRatio)
    self.pointer = ffi.cast('uint8_t*', self.imageData:getFFIPointer()) -- imageData has one byte per channel per pixel.    

    self.parameter:integer('Noise function', 'noiseFunctionIndex', 1, #Pixels.noiseFunctions, 1)
end

local baseX = 100 * love.math.random()
local baseY = 100 * love.math.random()

Pixels.noiseFunctions = {
    function (x, y)
        return ((x*65.685) * (y*9584.3652)) % 1
    end,
    function (x, y)
        local n = noise(
            baseX + .01654 * x,
            baseY + .02984 * y,
            ElapsedTime*.5)
        return n, n, n, 1
    end,
    function (x, y)
        rd = rd or love.math.newRandomGenerator()
        rd:setSeed(x/10*y/584+ElapsedTime)
        return rd:random() % 1
    end,
}

function Pixels:draw()
    seed = 56494446

    local fragment = Pixels.noiseFunctions[noiseFunctionIndex]
    
	local pointer, i = self.pointer, 0    
    local r, g, b, a = 0, 0, 0, 0

    for y in index(self.imageData:getHeight()) do
        for x in index(self.imageData:getWidth()) do
            r, g, b, a = fragment(x*self.pixelRatio, y*self.pixelRatio)

            pointer[i  ] = r * 255
            pointer[i+1] = (g or r) * 255
            pointer[i+2] = (b or r) * 255
            pointer[i+3] = (a or 1) * 255

            i = i + 4
        end
	end

    local image = love.graphics.newImage(self.imageData)
    image:setFilter('nearest', 'nearest', 0)
    
    love.graphics.draw(image, 0, 0, 0, self.pixelRatio, self.pixelRatio)
end
