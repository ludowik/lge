TimeManager = class()
function TimeManager.setup()
    DeltaTime = 0
    ElapsedTime = 0
end

function TimeManager:update(dt)
    DeltaTime = dt
    ElapsedTime = ElapsedTime + dt
end
