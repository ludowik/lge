ProcessManager = class() : extends(Node)

function ProcessManager.setup()
    processManager = ProcessManager()
end

function ProcessManager:add(sketch)
    Node.add(self, sketch)
    self:setCurrentSketch(#self.items)
end

function ProcessManager:setSketch(name)
    if not name then return end
    
    name = name:lower()
    for i,process in ipairs(self.items) do
        if process.__className == name then
            self:setCurrentSketch(i)
            break
        end        
    end
end

function ProcessManager:setCurrentSketch(currentProcess)
    self.currentProcess = currentProcess
    _G.env = self:current().env
    love.window.setTitle(self:current().__className)
end

function ProcessManager:loop()
    self.loopOverProcess = not self.loopOverProcess
    self.loopLastProcess = self:current()
    self.loopIterProcess = 20
end

function ProcessManager:update(dt)
    if self.loopOverProcess then
        self.loopIterProcess = self.loopIterProcess - 1
        if self.loopIterProcess <= 0 then
            self:next()
            self.loopIterProcess = 20

            if self:current() == self.loopLastProcess then
                self.loopOverProcess = false
            end
        end
    end

    self:current():updateSketch(dt)
end

function ProcessManager:current()
    return self.items[self.currentProcess]
end

function ProcessManager:previous()
    local currentProcess = self.currentProcess - 1
    if currentProcess < 1 then
        currentProcess = #self.items
    end
    self:setCurrentSketch(currentProcess)
    return self:current()
end

function ProcessManager:next()
    local currentProcess = self.currentProcess + 1
    if currentProcess > #self.items then
        currentProcess = 1
    end
    self:setCurrentSketch(currentProcess)
    return self:current()
end

function ProcessManager:random()
    self:setCurrentSketch(random(#self.items))
    return self:current()
end
