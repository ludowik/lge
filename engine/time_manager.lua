TimeManager = class()

function TimeManager.setup()
    timeManager = TimeManager()
end

function TimeManager:init()
    -- deltaTime = 0
    -- elapsedTime = 0
end

function TimeManager:update(dt)
    local process = processManager:current()
    if not process then return end
    
    if process.frames then
        if process.frames == 0 then
            return
        end
    end
    
    env.deltaTime = dt
    env.elapsedTime = env.elapsedTime + dt
    env.frameCount = env.frameCount + 1
end
