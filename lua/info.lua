local warnings = {}
function warning(value, message)
    if not value then 
        if not warnings[message] then
            warnings[message] = true
            print(message)
        end
    end
end

function info(k, v)
    print(k..' : '..v)
end

local major, minor, revision, codename = love.getVersion()
local str = string.format("%d.%d.%d - %s", major, minor, revision, codename)
info('Löve version', str)

info('App data Directory', love.filesystem.getAppdataDirectory())
info('Save Directory', love.filesystem.getSaveDirectory())
