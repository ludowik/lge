UlamSpiral = class() : extends(Sketch)

function UlamSpiral:init()
    Sketch.init(self)
    
    self.xp = CX
    self.yp = CY

    self.x = CX
    self.y = CY

    self.value = 1
    
    self.stepTotal = 0
    self.stepMax = 1
    self.step = self.stepMax
    self.stepSize = 8
    self.direction = 0
end

function UlamSpiral:draw()
    if prime(self.value) then
        -- fontSize(self.stepSize)
        -- textAlign(CENTER, CENTER)
        -- text(self.value, self.x, self.y)
        fill(colors.red)
        circle(self.x, self.y, self.stepSize / 2)
    end

    stroke(colors.white)
    strokeSize(2)
    line(self.x, self.y, self.xp, self.yp)

    self.xp = self.x
    self.yp = self.y

    if self.direction == 0 then
        self.x = self.x + self.stepSize
    elseif self.direction == 1 then
        self.y = self.y - self.stepSize
    elseif self.direction == 2 then
        self.x = self.x - self.stepSize
    elseif self.direction == 3 then
        self.y = self.y + self.stepSize
    end

    self.step = self.step - 1

    if self.step == 0 then
        self.direction = (self.direction + 1) % 4
        self.stepTotal = self.stepTotal + 1
        if self.stepTotal % 2 == 0 then
            self.stepMax = self.stepMax + 1
        end
        self.step = self.stepMax
    end

    -- if (self.value % 2 === 0) {
    --     self.stepMax++
    --     if (self.value % (self.step1) === 0) {
    --         self.step = (self.step + 1) % 4
    --     }
    -- }

    self.value = self.value + 1
end
