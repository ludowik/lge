ProcessManager = class() : extends(Node)

function ProcessManager.setup()
    process = ProcessManager()
end

function ProcessManager:add(sketch)
    Node.add(self, sketch)
    self.currentProcess = #self.items
end

function ProcessManager:setSketch(name)
    if not name then return end
    
    name = name:lower()
    for i,process in ipairs(self.items) do
        if process.__className == name then
            self.currentProcess = i
            break
        end        
    end
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
    self.currentProcess = self.currentProcess - 1
    if self.currentProcess < 1 then
        self.currentProcess = #self.items
    end
    return self:current()
end

function ProcessManager:next()
    self.currentProcess = self.currentProcess + 1
    if self.currentProcess > #self.items then
        self.currentProcess = 1
    end
    return self:current()
end

function ProcessManager:random()
    self.currentProcess = random(#self.items)
    return self:current()
end
