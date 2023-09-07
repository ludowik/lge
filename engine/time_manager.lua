TimeManager = class()

function TimeManager.setup()
    timeManager = TimeManager()
end

function TimeManager:init()
    -- DeltaTime = 0
    -- ElapsedTime = 0
end

function TimeManager:update(dt)
    env.DeltaTime = dt
    env.ElapsedTime = env.ElapsedTime + dt
    env.indexFrame = env.indexFrame + 1
end
