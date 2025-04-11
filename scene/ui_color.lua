UIColor = class() : extends(UI)

function UIColor:init(label, varName, callback)
    UI.init(self, label, callback)

    if classnameof(varName) == 'Bind' then
        self.value = varName
    else
        self.value = Bind(varName)
    end

    self.fixedSize = vec2(100, 25)
end

function UIColor:draw()
    local value = self.value:get()

    fill(value)
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
end

function UIColor:mousepressed(mouse)
    self.fixedSize = vec2(100, 100)
end

function UIColor:mousemoved(mouse)
    local rx = (mouse.position.x-self.position.x) / self.size.x
    local ry = (mouse.position.y-self.position.y) / self.size.y

    self.value:set(Color.hsl(rx, ry))
end

function UIColor:mousereleased(mouse)
    self.fixedSize = vec2(100, 25)
end
