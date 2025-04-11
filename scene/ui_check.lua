UICheck = class() : extends(UI)

function UICheck:init(label, object, callback)
    UI.init(self, label)

    self.callback = callback

    if classnameof(object) == 'Bind' then
        self.value = object
    else
        self.value = Bind(object)
    end
end

function UICheck:click(mouse)
    self.value:toggle()
    MouseEvent.click(self, mouse)
end

function UICheck:getLabel()
    return tostring(self.label)
end

function UICheck:computeSize()
    UI.computeSize(self)
    self.size.x = self.size.x + self.size.y/2 + 2 * UI.innerMarge
end

function UICheck:draw()
    UI.draw(self)

    if self.value:get() then
        fill(colors.green)
    else
        fill(colors.red)
    end

    noStroke()

    circleMode(CENTER)
    circle(
        self.position.x + self.size.x - self.size.y/2,
        self.position.y + self.size.y/2,
        self.size.y/3)
end
