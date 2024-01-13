SolarSystem = class() : extends(Sketch)

function SolarSystem:init()
    Sketch.init(self)
    p = Planet(0, 0, 6)
    camera(20, 20, 20)
end

function SolarSystem:draw()
    background(51)

    perspective()

    p:update()
    p:draw()
end

Planet = class()

function Planet.setup()
    Planet.model = Planet.model or Mesh(Model.sphere2())
end

function Planet:init(x, y, r, level)
    level = (level or 0) + 1

    self.x = x
    self.y = y

    self.r = r

    if level > 1 then
        self.angle = random(0, 360)
        self.angularVelocity = random(-2, 2)
    else
        self.angle = 0
        self.angularVelocity = 0
    end

    self.planets = Array()
    if level < 3 then
        for i=1,random(2,5) do
            self.planets:add(Planet(random(2*r+r/3, 2*r+r/2), 0, r*0.63, level))
        end
    end
end

function Planet:update(dt)
    self.angle = self.angle + self.angularVelocity
    self.planets:update()
end

function Planet:sphere(r)
    pushMatrix()
    do
        scale(r)        
        fill(colors.red)
        Planet.model:draw()
    end
    popMatrix()
end

function Planet:draw()
    light({Light()})

    pushMatrix()
    do
        stroke(colors.white)
        fill(colors.white)

        rotate(rad(self.angle))
        translate(self.x, self.y)

        self:sphere(self.r)

        self.planets:draw()
    end
    popMatrix()
end
