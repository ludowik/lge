TimeManager = class()

function TimeManager.setup()
    timeManager = TimeManager()
end

function TimeManager:init()
end

function TimeManager:update(dt)
    local sketch = processManager:current()
    if sketch.loopMode == 'none' then return end
    
    env.deltaTime = dt
    env.elapsedTime = env.elapsedTime + dt

    env.frameCount = env.frameCount + 1
end
