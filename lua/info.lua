
function info(k, v)
    print(k..' : '..v)
end

local major, minor, revision, codename = love.getVersion()
local str = string.format("%d.%d.%d - %s", major, minor, revision, codename)
info('Löve version', str)

info('App data Directory', love.filesystem.getAppdataDirectory())
info('Save Directory', love.filesystem.getSaveDirectory())
