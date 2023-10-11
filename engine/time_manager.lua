TimeManager = class()

function TimeManager.setup()
    timeManager = TimeManager()
end

function TimeManager:init()
    -- DeltaTime = 0
    -- ElapsedTime = 0
end

function TimeManager:update(dt)
    local process = processManager:current()
    if not process then return end
    
    if process.frames then
        if process.frames == 0 then
            return
        end
    end
    
    env.DeltaTime = dt
    env.ElapsedTime = env.ElapsedTime + dt
    env.indexFrame = env.indexFrame + 1
end
