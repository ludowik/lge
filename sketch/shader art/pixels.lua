if getOS() == 'web' then return end

local ffi = try_require 'ffi'

Pixels = class() : extends(Sketch)

function Pixels:init()
    Sketch.init(self)

    self.pixelRatio = 4
    self.img = FrameBuffer(W/self.pixelRatio, H/self.pixelRatio)

    self.parameter:integer('Noise function', 'noiseFunctionIndex', 1, #Pixels.noiseFunctions, 6)
end

local baseX = 100 * love.math.random()
local baseY = 100 * love.math.random()

Pixels.noiseFunctions = {

    function (x, y)
        return Color.random():rgba()
    end,

    function (x, y)
        return ((x*65.685) * (y*9584.3652)) % 1
    end,

    function (x, y)
        local n = noise(
            baseX + .01654 * x,
            baseY + .02984 * y,
            elapsedTime*.5)
        return n, n, n, 1
    end,

    function (x, y)
        rd = rd or love.math.newRandomGenerator()
        rd:setSeed(x/10*y/584+elapsedTime)
        return rd:random() % 1
    end,

    function (x, y, w, h)
        local t = elapsedTime * 100

        local dx = w / 2 - x - cos(t * 0.01) * w / 2
        local dy = h / 2 - y - sin(t * 0.03) * h / 4

        dx = dx * 2
        dy = dy * 2

        local d = pow((pow(dx, 2) + pow(dy, 2)), 0.5)
        local a = atan2(dx, dy)
        local p = pow(d, 0.8) + pow(sin(3 * a + t * 0.04), 16) * w / 8

        return round(p % 16) * 16
    end,

    function (x, y, w, h)
        x = x / 25
        y = y / 25

        local p = noise(x, y, elapsedTime / 2)
        return p * p, p, x / w
    end,

    function (x, y, w, h)
        local p1, p2
        
        x = x - w / 2
        y = y - h / 2

        -- circle
        p1 = (dist(x, y, 0, 0) < (w / 5)) and 1 or 0

        -- rect
        local v = vec2(x, y):rotate(-elapsedTime)
        p2 = (abs(v.x) < (w / 5) and abs(v.y) < (w / 5)) and 1 or 0

        return p1, p2, 0
    end
}

function Pixels:draw()
    background()

    seed = 56494446

    local fragment = Pixels.noiseFunctions[noiseFunctionIndex]
    
    local w, h = self.img.imageData:getWidth(), self.img.imageData:getHeight()

    self.img:mapPixel(function (x, y)
        local r, g, b, a = fragment(x, y, w, h)
        return r, (g or r), (b or r), (a or 1)
    end)

    scale(self.pixelRatio, self.pixelRatio)
    sprite(self.img)
end
