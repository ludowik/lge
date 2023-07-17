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


Image = class() : extends(FrameBuffer)

function Image:init(w, h)
    FrameBuffer.init(self, w, h)
end
