UISlider = class():extends(UIButton)

function UISlider:init(label, varName, minValue, maxValue, callback)
    UIButton.init(self, label, callback)

    if classnameof(varName) == 'Bind' then
        self.value = varName
    else
        self.value = Bind(varName)
    end

    self.minValue = minValue or 0
    self.maxValue = maxValue or 100

    self.intValue = false
    self.incrementValue = (self.maxValue - self.minValue) / 20
end

function UISlider:computeSize()
    fontSize(self.styles.fontSize * .7)
    local wlabel = textSize(tostring(self.label))

    fontSize(self.styles.fontSize)
    local strValue = self:getValue(self.maxValue)
    local wvalue, hvalue = textSize(strValue)
    self.size:set(min(W / 3, wlabel + 5 + wvalue) + 2 * hvalue, hvalue)
end

function UISlider:draw()
    translate(self.position.x, self.position.y)

    -- sub/add buttons
    local r = 5
    noStroke()
    fill(self.styles.fillColor:alpha(0.8))    
    rect(0, 0, self.size.y-1, self.size.y, r)
    rect(self.size.x - self.size.y + 1, 0, self.size.y-1, self.size.y, r)

    -- slider part
    fill(self.styles.fillColor)
    rect(self.size.y, 0, self.size.x - 2 * self.size.y, self.size.y)

    -- label
    fontSize(self.styles.fontSize * .7)
    textColor(self.styles.textColor)
    textMode(CORNER)
    text(tostring(self.label), self.size.y +1, -1)

    -- value
    fontSize(self.styles.fontSize)
    local strValue = self:getValue()
    local w, h = textSize(strValue)
    textMode(CORNER)
    text(strValue, self.size.x - w - self.size.y -1, -1)

    -- slider
    local dx = (self.value:get() - self.minValue) / (self.maxValue - self.minValue)
    local x = self.size.y + dx * (self.size.x - 2 * self.size.y)
    strokeSize(5)
    stroke(colors.red)
    line(x, 0, x, self.size.y)
    
    strokeSize(1.5)
    stroke(colors.orange)
    line(x, 0, x, self.size.y)
end

function UISlider:click(mouse)
    local dx_left = mouse.position.x - self.position.x
    local dx_right = self.size.x - dx_left

    if dx_left < self.size.y then
        self:incrementOrDecrement(-1)
    
    elseif dx_right < self.size.y then
        self:incrementOrDecrement(1)
        
    else
        local rx = (mouse.position.x - self.position.x - self.size.y) / (self.size.x - 2*self.size.y)
        local newValue = rx * (self.maxValue - self.minValue) + self.minValue
        log(rx, newValue)

        self:set(newValue)
    end
end

function UISlider:mousemoved(mouse)
    local rx = mouse.deltaPos.x / (self.size.x - 2*self.size.y)
    local deltaValue = rx * (self.maxValue - self.minValue)
    local newValue = self.value:get() + deltaValue

    self:set(newValue)
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
    self:callback()
end
