UISlider = class() : extends(UIButton)

function UISlider:init(label, varName, minValue, maxValue, callback)
    UIButton.init(self, label, callback)

    self.value = Bind(varName)

    self.minValue = minValue or 0
    self.maxValue = maxValue or 100

    self.intValue = false    
    self.incrementValue = (self.maxValue - self.minValue) / 20
end

function UISlider:draw()
    translate(self.position.x, self.position.y)

    noStroke()
    
    local r = 4
    fill(self.styles.fillColor:darker())
    rect(0, 0, self.size.y, self.size.y, r)
    rect(self.size.x - self.size.y, 0, self.size.y, self.size.y, r)

    fill(self.styles.fillColor)
    rect(self.size.y - r, 0, self.size.x - 2*self.size.y + 2*r, self.size.y)

    local dx = (self.value:get() - self.minValue) / (self.maxValue - self.minValue)
    local x = self.size.y + dx * (self.size.x - 2*self.size.y)
    stroke(colors.blue)
    line(x, 0, x, self.size.y)
    
    fontSize(self.styles.fontSize*.7)
    textMode(CORNER)
    text(tostring(self.label), self.size.y, 0)

    fontSize(self.styles.fontSize)
    local strValue = self:getValue()
    local w, h = textSize(strValue)
    textMode(CORNER)
    text(strValue, self.size.x-w-self.size.y, 0)
end

function UISlider:mousemoved(mouse)
    local rx = mouse.deltaPos.x / self.size.x

    local deltaValue = rx * (self.maxValue - self.minValue)
    local newValue = self.value:get() + deltaValue
    self:set(newValue)
end

function UISlider:mousepressed(mouse)
    local dx_left = mouse.position.x - self.position.x
    local dx_right = self.size.x - dx_left

    if dx_left < self.size.y then
        self:incrementOrDecrement(-1)
    elseif dx_right < self.size.y then
        self:incrementOrDecrement(1)
    end
end

function UISlider:incrementOrDecrement(incrementOrDecrement)
    local deltaValue = incrementOrDecrement * self.incrementValue
    local newValue = self.value:get() + deltaValue
    self:set(newValue)
end

function UISlider:set(newValue)
    newValue = clamp(newValue, self.minValue, self.maxValue)
    if self.intValue then
        newValue = round(newValue)
    end
    self.value:set(newValue)
    self:click()
end
