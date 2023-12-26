Spirale = class() : extends(Sketch)

function Spirale:init()
    Sketch.init(self)

    -- TODO
    -- normalMaterial()

    -- TODO : parameter
    self.params = {
        deltaAngle = 32,
        -- {
        --     value = 32,
        --     min = 0,
        --     max = 64,
        -- },

        width = 100,
        widthMax = 500,

        height = 400,
        heightMax = 500,

        noise = 100,
    }

    self.parameter:boolean('rotate', 'rotateSpirale', false)

    self.elapsedTime = 0

    camera(300, 500, 300)
end

function Spirale:update(dt)
    if rotateSpirale then
        self.elapsedTime = self.elapsedTime + dt / 2
    end
end

function Spirale:draw()
    background(0)

    perspective()
    
    fill(colors.white)
    
    local angle = 0
    local x, y, z = 0, 0, 0
    local px, py, pz

    local buffers = {
        vertices = Array(),
        colors = Array()
    }

    for i = -self.params.height , self.params.height do
        y = y + noise(self.elapsedTime + (i / self.params.noise))
    end
    y = -y / 2

    for i = -self.params.height , self.params.height do
        local n = noise(self.elapsedTime + (i / self.params.noise))
        local n2 = noise(self.elapsedTime  + (i / self.params.noise))

        y = y + n

        x = cos(angle) * self.params.width * n ^ 2
        z = sin(angle) * self.params.width * n ^ 2

        --stroke(Color.hsb(n))
        local clr = Color.hsb(n2, 0.5, 0.5)
        fill(clr)

        strokeSize(n)

        buffers.vertices:add({x, y, z})
        buffers.vertices:add({0, y, 0})

        buffers.colors:add({clr.r, clr.g, clr.b, 1})
        buffers.colors:add({clr.r, clr.g, clr.b, 1})

        angle = angle + n * rad(self.params.deltaAngle)

        px = x
        py = y
        pz = z
    end

    Mesh(buffers, 'strip'):draw()
end
