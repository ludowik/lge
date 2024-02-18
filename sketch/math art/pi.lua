function setup()
    iteration = 1

    methods = {
        EstimatePI(),
        EstimatePI_coprime(),
        EstimatePI_montecarlo(),
        EstimatePI_montecarlo3D(),
        EstimatePI_leibniz()
    }

    parameter:watch('iteration')
end

function update()
    if getFPS() > 58 then
        iteration = min(iteration + 50, 50000)
    else
        iteration = max(iteration - 50, 100)
    end

    for i in range(iteration) do
        for _,method in ipairs(methods) do
            method:step()
        end
    end

    for _,method in ipairs(methods) do
        method:update()
    end
end

function draw()
    background(colors.black)

    local h = 24

    local x = (W / 2) / 8
    local y = (H / 5)

    fontSize(h)
    textMode(CENTER)

    for _,method in ipairs(methods) do
        method:render(x, y, h)
        y = y + 4 * h
    end
end

EstimatePI = class ()

function EstimatePI:init(title)
    self.title = title or 'PI'
    self.values = Array()
end

function EstimatePI:compute()
    return PI
end

function EstimatePI:step()
end

function EstimatePI:update()
    local pi = self:compute()
    self.values:push(pi)
    while #self.values > W do
        self.values:shift()
    end
end

function EstimatePI:render(x, y, h)
    self:draw(x, y, self.title, h)
end

function EstimatePI:draw(ox, oy, title, h)
    local values = self.values
    local pi = values[#values]

    noStroke()
    fill(colors.white)

    text(title, ox + W/2, oy)
    text(pi, ox + W/2, oy + h)

    oy = oy + 2 * h

    if values then
        noFill()

        local minY =  1000
        local maxY = -1000

        for i=1,#values do
            minY = min(PI, minY, values[i])
            maxY = max(PI, maxY, values[i])
        end

        local maxFromPI = max(10e-10, max(abs(PI - minY), abs(PI - maxY)))

        minY = PI - maxFromPI
        maxY = PI + maxFromPI

        local piY = map(PI, minY, maxY, h, 0)

        stroke(colors.gray)
        strokeSize(1)
        line(ox, oy + piY, ox + W, oy + piY)

        stroke(colors.red)

        beginShape()
        for x,v in ipairs(values) do
            local y = map(v, minY, maxY, h, 0)
            vertex(ox + x, oy + y)
        end
        endShape()
    end
end

-- from probability of 2 random integers being coprime
EstimatePI_coprime = class() : extends(EstimatePI)

local MAX = 10^10
local MAX_HALF = MAX / 2

function EstimatePI_coprime:init()
    EstimatePI.init(self, 'coprime')

    self.totalCount = 0
    self.coprimeCount = 0
end

function EstimatePI_coprime:step()
    self.totalCount = self.totalCount + 1

    local a = randomInt(1, MAX)
    local b = randomInt(1, MAX)

    if coprime(a, b) then
        self.coprimeCount = self.coprimeCount + 1
    end
end

function EstimatePI_coprime:compute()
    return sqrt(6 / (self.coprimeCount / self.totalCount))
end

-- from probability that a point is in a circle circumscribed in a square
EstimatePI_montecarlo = class() : extends(EstimatePI)

function EstimatePI_montecarlo:init()
    EstimatePI.init(self, 'monte carlo')

    self.totalCount = 0
    self.inCircleCount = 0
end

function EstimatePI_montecarlo:step()
    self.totalCount = self.totalCount + 1

    local a = randomInt(MAX)
    local b = randomInt(MAX)

    if dist(a, b, MAX_HALF, MAX_HALF) <= MAX_HALF then
        self.inCircleCount = self.inCircleCount + 1
    end
end

function EstimatePI_montecarlo:compute()
    return 4 * (self.inCircleCount / self.totalCount)
end

-- from probability that a point is in a sphere circumscribed in a cube
EstimatePI_montecarlo3D = class() : extends(EstimatePI)

function EstimatePI_montecarlo3D:init()
    EstimatePI.init(self, 'monte carlo 3D')

    self.totalCount = 0
    self.inSphereCount = 0
end

function EstimatePI_montecarlo3D:step()
    self.totalCount = self.totalCount + 1

    local a = randomInt(MAX)
    local b = randomInt(MAX)
    local c = randomInt(MAX)

    if dist3d(a, b, c, MAX_HALF, MAX_HALF, MAX_HALF) <= MAX_HALF then
        self.inSphereCount = self.inSphereCount + 1
    end
end

function EstimatePI_montecarlo3D:compute()
    return 6 * (self.inSphereCount / self.totalCount)
end

-- from leibniz formula
EstimatePI_leibniz = class() : extends(EstimatePI)

function EstimatePI_leibniz:init()
    EstimatePI.init(self, 'leibniz')

    self.leibniz = 1
    self.leibnizSign = -1
    self.leibnizDivisor = 3
end

function EstimatePI_leibniz:step()
    self.leibniz = self.leibniz + self.leibnizSign / self.leibnizDivisor
    self.leibnizSign = -self.leibnizSign
    self.leibnizDivisor = self.leibnizDivisor + 2
end

function EstimatePI_leibniz:compute()
    return 4 * (self.leibniz)
end
