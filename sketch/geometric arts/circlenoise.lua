Noise = class() : extends(Sketch)

function Noise:init()
    Sketch.init(self)

    self.params = {
        ratio = 2,
        size = 20,
        speed = 3,
    }

    self.parameter:integer('ratio', Bind(self.params, 'ratio'))
    self.parameter:integer('size', Bind(self.params, 'size'))
    self.parameter:integer('speed', Bind(self.params, 'speed'))
end

function Noise:draw()
    background(colors.white)
    local size = self.params.size

    stroke(colors.red)
    noStroke()

    blendMode(NORMAL)

    circleMode(CENTER)
    rectMode(CENTER)

    translate(size/2, size/2)

    for i in index(W / size) do
        for j in index(H / size) do
            fill(
                Color(noise(
                    (i) / self.params.ratio,
                    (j) / self.params.ratio,
                    ElapsedTime / self.params.speed
                ),
                -- noise(
                --     elapsedTime / self.params.speed,
                --     (i) / self.params.ratio,
                --     (j) / self.params.ratio,
                -- ),
                -- noise(
                --     (i) / self.params.ratio,
                --     elapsedTime / self.params.speed,
                --     (j) / self.params.ratio,
                -- )
                    0.5)
            )

            circle(i * size, j * size, size)
            -- rect(i * size, j * size, size, size)
        end
    end
end
