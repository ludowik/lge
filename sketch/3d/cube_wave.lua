appCubeWave = class() : extends(Sketch)

function appCubeWave:init()
    Sketch.init(self)

    self.angle = 0

    self.parameter:integer('n', Bind(self, 'n'), 1, 20, 5)
    self.parameter:integer('size', Bind(self, 'cubeSize'), 1, 20, 5)

    self.parameter:number('zoom', Bind(self, 'zoom'), 1, 20, 8)
    self.parameter:number('speed', Bind(self, 'speed'), 1, 10, 2)

    self.mesh = Mesh(Model.box())
end

function appCubeWave:update(dt)
    self.angle = self.angle + dt * self.speed
end

function appCubeWave:draw()
    background(51)

    line(W / 2, 0, W / 2, H)

    isometric(self.zoom)

    --light(true)

    local n = self.n * 2 + 1

    local w = self.cubeSize

    local mind = 0
    local maxd = vec2(1, 1):dist(vec2(n / 2, n / 2))

    translate(-(n + 1) / 2 * w, 0, -(n + 1) / 2 * w)

    instances = Array()

    local i = 1
    for x = 1, n do
        for z = 1, n do
            local d = vec2(x, z):dist(vec2((n + 1) / 2, (n + 1) / 2))
            local offset = map(d, mind, maxd, -PI, PI)
            local s = sin(self.angle + offset)

            local h = map(s, -1, 1, w * 2, w * 8)
            local r = map(s, -1, 1, 0.4, 1)

            strokeSize(2)
            stroke(colors.gray)

            instances:add{x*w, 0, z*w, w, h, w, r, r, r, r}
        end
    end
    
    self.mesh:drawInstanced(instances)
end
