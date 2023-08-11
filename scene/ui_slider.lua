UISlider = class() : extends(UIButton)

function UISlider:init(label, varName, minValue, maxValue, callback)
    UIButton.init(self, label, callback)

    self.value = Bind(varName)

    self.minValue = minValue or 0
    self.maxValue = maxValue or 100
end

function UISlider:mousepressed(mouse)
    local dx = mouse.position.x - (self.position.x + self.size.x / 2)
    local deltaValue = (dx > 0 and 1 or -1)
    local newValue = self.value:get() + deltaValue
    newValue = clamp(newValue, self.minValue, self.maxValue)
    self.value:set(newValue)
    self:click()
end
