function message(msg)
    msg = tostring(msg)
    love.window.showMessageBox('Message', msg, {'OK'})
end

local warnings = {}
function warning(value, msg)
    if not value then 
        msg = tostring(msg)
        if not warnings[msg] then
            warnings[msg] = true
            local info = scriptLink(3)
            log(info..' '..msg)
        end
    end
end

function log(k, v)
    k = tostring(k)
    if v then
        print(k..' : '..tostring(v))
    else
        print(k)
    end
end

local major, minor, revision, codename = love.getVersion()
local str = string.format("%d.%d.%d - %s", major, minor, revision, codename)
log('Löve version', str)
log('Lua version', _VERSION)
log('Save data Directory', love.filesystem.getSaveDirectory())
