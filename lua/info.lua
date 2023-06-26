
function info(k, v)
    print(k..' => '..v)
end

info('appdata Directory', love.filesystem.getAppdataDirectory())
info('save Directory', love.filesystem.getSaveDirectory())

local major, minor, revision, codename = love.getVersion()
local str = string.format("%d.%d.%d - %s", major, minor, revision, codename)
info('version', str)
