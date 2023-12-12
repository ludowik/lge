ProcessManager = class():extends(Node)

function ProcessManager.setup()
    processManager = ProcessManager()
end

function ProcessManager:init()
    self.processIndex = 1
end

function ProcessManager:setSketch(name)
    local index = self:findSketch(name)
    if index then 
        self:setCurrentSketch(index)
    end
end

function ProcessManager:findSketch(name)
    if not name then return end

    name = name:lower()
    for i, env in ipairs(self.items) do
        if env.__name == name then
            return i
        end
    end
end

function ProcessManager:getSketch(nameOrIndex)
    if not nameOrIndex then return end

    if type(nameOrIndex) == 'number' then
        return self.items[nameOrIndex]
        
    else
        nameOrIndex = nameOrIndex:lower()
        for i, env in ipairs(self.items) do
            if env.__name == nameOrIndex then
                return env.sketch
            end
        end
    end
end

function ProcessManager:setCurrentSketch(processIndex)
    local process = self:current()
    if process and process.pause then process:pause() end

    collectgarbage('collect')

    self.processIndex = processIndex
    loadSketch(self.items[self.processIndex])

    local process = self:current()
    if not process then return end

    _G.env = process.env
    setfenv(0, _G.env)
    if process.resume then process:resume() end

    setSettings('sketch', process.env.__name)

    love.window.setTitle(process.env.__name)

    process.fb:setContext()
    process.fb:background()
    resetContext()

    if instrument then
        instrument:reset()
    end

    engine.parameter.items[#engine.parameter.items].items[1].label = process.env.__name
    engine.parameter.items[#engine.parameter.items].items[2] = process.parameter.items[1]

    redraw()
end

function ProcessManager:current()
    return self.items[self.processIndex].sketch
end

function ProcessManager:previous()
    local processIndex = self.processIndex - 1
    if processIndex < 1 then
        processIndex = #self.items
    end
    self:setCurrentSketch(processIndex)
    return self:current()
end

function ProcessManager:next()
    local processIndex = self.processIndex + 1
    if processIndex > #self.items then
        processIndex = 1
    end
    self:setCurrentSketch(processIndex)
    return self:current()
end

function ProcessManager:random()
    self:setCurrentSketch(randomInt(#self.items))
    return self:current()
end

LOOP_ITER_PROCESS = 1

function ProcessManager:loopProcesses()
    if self.__loopProcesses then
        self.__loopProcesses = nil
    else
        self.__loopProcesses = {
            startProcess = self:current(),
            famesToDraw = LOOP_ITER_PROCESS
        }
    end
end

function ProcessManager:update(dt)
    local process = processManager:current()
    if not process then return end

    self:updateLoop(dt)
    process:updateSketch(dt)
end

function ProcessManager:updateLoop(dt)
    if self.__loopProcesses then
        self.__loopProcesses.famesToDraw = self.__loopProcesses.famesToDraw - 1
        if self.__loopProcesses.famesToDraw <= 0 then
            self:next()
            self.__loopProcesses.famesToDraw = LOOP_ITER_PROCESS

            local process = processManager:current()
            if not process then return end

            local delay = 0.25
            local dt = 1/60
            local startTime = time()
            while true do
                process:updateSketch(dt)
                process:drawSketch()

                love.graphics.present()
                
                if time() - startTime > delay then
                    break
                end
            end

            captureImage()
            captureLogo()

            if process == self.__loopProcesses.startProcess then
                self.__loopProcesses = nil
            end
        end
    end
end
