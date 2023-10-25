Spirale = class() : extends(Sketch)

function Spirale:init()
    Sketch.init(self)

    -- TODO
    -- normalMaterial()

    -- TODO : implement a camera
    -- self.cam = createEasyCam()

    -- local state = getItem('cam_state')
    -- self.cam.setState(state)

    self.params = {
        update = true,

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

    self.elapsedTime = 0
end

function Spirale:update(dt)
    if self.params.update then
        self.elapsedTime = self.elapsedTime + dt
    end

    -- TODO : implement a camera
    -- storeItem('cam_state', self.cam.getState())
end

function Spirale:draw()
    background(0)

    -- TODO
    perspective()

    -- TODO
    -- camera()

    fill(colors.white)
    
    axes2d()

    translate(W/2, H/2)

    -- TODO
    -- translate(0, 0, 100)
    -- rect(-100, -100, 200, 200)

    -- translate(0, 0, -200)
    -- rect(-100, -100, 200, 200)

    local angle = 0

    local x, y, z = 0, 0, 0

    local px, py, pz

    beginShape(TRIANGLE_STRIP)

    for i = -self.params.height , self.params.height do
        y = y + noise(self.elapsedTime + (i / self.params.noise))
    end
    y = -y / 2

    for i = -self.params.height , self.params.height do
        local n = noise(self.elapsedTime + (i / self.params.noise))
        y = y + n

        x = cos(angle) * self.params.width * n ^ 2
        z = sin(angle) * self.params.width * n ^ 2

        --stroke(Color.hsb(n))
        fill(Color.hsb(n, 0.5, 1))

        strokeSize(n)

        vertex(x, y, z)
        vertex(0, y, 0)

        --  if (px) {
        --      strokeSize(2)
        --      vertex(0, y, 0, 0, py, 0)
        --      vertex(x, y, z, px, py, pz)
        --  }

        angle = angle + n * rad(self.params.deltaAngle)

        px = x
        py = y
        pz = z
    end

    endShape()
end
