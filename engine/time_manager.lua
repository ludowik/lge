TimeManager = class()

function TimeManager.setup()
    timeManager = TimeManager()
end

function TimeManager:init()
    -- deltaTime = 0
    -- elapsedTime = 0
end

function TimeManager:update(dt)
    local sketch = processManager:current()
    if sketch.loopMode == 'none' then return end

    self.deltaTime = dt
    
    env.deltaTime = self.deltaTime
    env.elapsedTime = env.elapsedTime + dt
    env.frameCount = env.frameCount + 1
end
