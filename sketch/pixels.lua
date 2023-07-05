Pixels = class() : extends(Sketch)

function Pixels:init()
    Sketch.init(self)

    self.imageData = self.canvas:newImageData()
    self.pointer = require("ffi").cast("uint8_t*", self.imageData:getFFIPointer()) -- imageData has one byte per channel per pixel.    
end

local baseX = 100 * love.math.random()
local baseY = 100 * love.math.random()

Pixels.noiseFunctions = {
    function (x, y)
        return ((x*65.685) * (y*9584.3652)) % 1
    end,
    function (x, y)
        local n = love.math.noise(
            baseX + .01654 * x,
            baseY + .02984 * y,
            ElapsedTime*.5)
        return n, n, n, 1
    end,
}

function Pixels:draw()
    local fragment = Pixels.noiseFunctions[2]
    
	local pointer, i = self.pointer, 0    
    local r, g, b, a = 0, 0, 0, 0

    for y in index(self.imageData:getHeight()) do
        for x in index(self.imageData:getWidth()) do
            r, g, b, a = fragment(x, y)

            pointer[i  ] = r * 255
            pointer[i+1] = (g or r) * 255
            pointer[i+2] = (b or r) * 255
            pointer[i+3] = (a or 1) * 255

            i = i + 4
        end
	end

    love.graphics.draw(love.graphics.newImage(self.imageData))
end
