Horloge = class() : extends(Sketch)

function Horloge:init(lieu, decalage, x, y, rayon)
    Sketch.init(self)

    self.lieu = lieu or 'Garches'

    self.decalage = decalage or 0

    self.x = x or CX
    self.y = y or CY

    self.rayon = rayon or SIZE / 3

    self.shapes = Array()
end

function Horloge:draw()
    background(51)

    self:graduation(self.x, self.y, self.rayon, 15,  4, 5, false, colors.red)
    self:graduation(self.x, self.y, self.rayon,  8, 12, 3, true , colors.green)
    self:graduation(self.x, self.y, self.rayon,  4, 60, 1, false, colors.blue)

    local date = date()
    local ipart, fpart = math.modf(os.clock())
    
    self:aiguille(colors.red  , self.x, self.y, ( date.hour - self.decalage ) * 30 , self.rayon * 0.8, 7)
    self:aiguille(colors.green, self.x, self.y, ( date.min                  ) * 6  , self.rayon * 0.8, 4)
    self:aiguille(colors.blue , self.x, self.y, ( date.sec                  ) * 6  , self.rayon, 1)

    width, height = textSize(self.lieu)

    textMode(CENTER)
    text(self.lieu, self.x, self.y - self.rayon - height)
end

function Horloge:aiguille(clr, x, y, a, l, size)
    pushMatrix()

    translate(x, y)

    rotate(rad(-a), 0, 0, 1)

    if self.shapes[size] == nil then
        local vertices = Buffer('vec3', {
            {0, l},
            {-size, 0},
            {size, 0},
        })
        
        self.shapes[size] = Mesh(vertices, 'fan')
    end

    noStroke()
    fill(clr)

    self.shapes[size]:draw()

    circle(0, 0, size)

    popMatrix()
end

-- This function draws a circle graduation
function Horloge:graduation(x, y, r, l, p, size, draw_text, c)
    local r0 = r - l * 2
    local r1 = r - l / 2
    local r2 = r + l / 2

    strokeSize(size)
    stroke(c)

    draw_text = draw_text or false
    c = c or colors.white

    local a = -90
    local da = 360 / p

    for i = 1, p do
        a = a + da

        local cos_r = cos(rad(a))
        local sin_r = sin(rad(a))

        line(
            x + cos_r * r1, y + sin_r * r1,
            x + cos_r * r2, y + sin_r * r2
        )

        if draw_text then
            textMode(CENTER)
            text(i,
                x + cos_r * r0,
                y + sin_r * r0
            )
        end
    end
end
