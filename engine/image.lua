FrameBuffer = class()

function FrameBuffer:init(w, h)
    self.canvas = love.graphics.newCanvas(w, h)
end

function FrameBuffer:background()
    self.canvas:clear()
end

function FrameBuffer:setContext()
    love.graphics.setCanvas(self.canvas)
end

Image = class() : extends(FrameBuffer)

function Image:init(w, h)
    FrameBuffer.init(self, w, h)
end
