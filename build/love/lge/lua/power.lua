function getPowerInfo()
    local state, percent, seconds = love.system.getPowerInfo()
    percent = percent or 100
    seconds = seconds or 0

    return state..' - '..percent..'% - '..floor(seconds / 60)..' minutes'
end
