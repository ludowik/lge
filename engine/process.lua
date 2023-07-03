Process = class() : extends(Array)

function Process:add(sketch)
    Array.add(self, sketch)
    self.currentProcess = #self
end

function Process:current()
    return self[self.currentProcess]
end

function Process:previous()
    self.currentProcess = self.currentProcess - 1
    if self.currentProcess < 1 then
        self.currentProcess = #self
    end
    return self:current()
end

function Process:next()
    self.currentProcess = self.currentProcess + 1
    if self.currentProcess > #self then
        self.currentProcess = 1
    end
    return self:current()
end

function Process:random()
    self.currentProcess = random(#self)
    return self:current()
end
