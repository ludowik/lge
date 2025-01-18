ProcessManager = class() : extends(Node)

function ProcessManager.setup()
    processManager = ProcessManager()
end

function ProcessManager.openSketches()
    local sketch = processManager:current()
    if sketch.__className ~= 'sketches' then            
        processManager:setSketch('sketches', false)
    else
        sketch.env.navigate()
    end
end

function ProcessManager:init()
    Node.init(self)
    self.processIndex = 1
end

function ProcessManager:setSketch(name, showParam)
    assert(name)

    if showParam ~= nil then
        engine.parameter.visible = argument(showParam, true)
    end
    
    local index = self:findSketch(name)
    if index then 
        return self:setCurrentSketch(index)
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

function ProcessManager:findSketches(keyword)
    if not keyword then return end

    local sketches = Array()

    keyword = keyword:lower()
    for i, env in ipairs(self.items) do
        if env.__name:contains(keyword) then
            sketches:add(i)
        end
    end
    
    return sketches
end

function ProcessManager:getSketch(index)
    if not index then return end
    return self.items[index]
end

function ProcessManager:setCurrentSketch(processIndex)
    -- pause current sketch
    local sketch = self:current()
    if sketch then sketch:pause() end

    -- select next sketch
    self.processIndex = processIndex
    local env = self.items[self.processIndex]

    setSetting('sketch', env.__name)
    log(env.__name)
    love.window.setTitle(env.__name)

    -- load if not
    loadSketch(env)
    
    -- failed ?
    local sketch = self:current()
    if not sketch then return end

    -- set global environment
    _G.env = sketch.env

    -- resume sketch
    sketch:resume()

    -- reset instrumentation
    if instrument then
        instrument:reset()
    end

    -- clear drawing areas and force redraw
    local W = sketch.env.__W or sketch.env.W
    if W ~= sketch.env.W then
        Graphics.updateScreen()
    end

    background()

    redraw()

    sketch.env.__W = W

    return sketch
end

function ProcessManager:current()
    return self.items[self.processIndex] and self.items[self.processIndex].sketch or nil
end

function ProcessManager:previous()
    local processIndex = self.processIndex - 1
    if processIndex < 1 then
        processIndex = #self.items
    end
    return self:setCurrentSketch(processIndex)
end

function ProcessManager:next()
    local processIndex = self.processIndex + 1
    if processIndex > #self.items then
        processIndex = 1
    end
    return self:setCurrentSketch(processIndex)
end

function ProcessManager:random()
    return self:setCurrentSketch(randomInt(#self.items))
end

local LOOP_PROCESS_DT = 1/60
local LOOP_PROCESS_N = 15
local LOOP_PROCESS_DELAY = LOOP_PROCESS_N * LOOP_PROCESS_DT

function ProcessManager:loopProcesses()
    if self.__loopProcesses then
        self.__loopProcesses = nil
    else
        self.__loopProcesses = {
            startProcess = self:current(),
        }
    end
end

function ProcessManager:update(dt)    
    local sketch = processManager:current()

    if self.__loopProcesses then
        self:updateLoop(dt)
        
    elseif sketch then
        sketch:updateSketch(dt)
    end
end

function ProcessManager:updateLoop(dt)
    if not self.__loopProcesses then return end
    self:next()

    local sketch = processManager:current()
    assert(sketch)

    local delay = LOOP_PROCESS_DELAY
    local dt = LOOP_PROCESS_DT
    local n = 0
    local startTime = time()

    sketch.env.__autotest = true
    Graphics.setVSync(0)
        
    while true do
        n = n + 1

        sketch:updateSketch(dt)
        sketch:drawSketch()

        Graphics.flush()
        
        if time() - startTime > delay or n >= LOOP_PROCESS_N then
            break
        end
    end
    
    Graphics.setVSync(1)
    sketch.env.__autotest = false

    -- captureImage()
    -- captureLogo()

    if sketch == self.__loopProcesses.startProcess then
        self.__loopProcesses = nil
    else
        --self:updateLoop(dt)
    end
end
