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
            info(info..' '..msg)
        end
    end
end

function log(k, v, ...)
    if type(k) == 'table' then
        for _k, v in pairs(k) do
            print(_k..' : '..tostring(v))
        end
        return
    end

    k = tostring(k)
    if v then
        print(k..' : '..tostring(v), ...)
    else
        print(k)
    end
end

function info(...)
    log(...)
end

function here()
    info('here')
end

function fatal(check)
    if not check then
        info(debug.traceback())
        stop()
    end
end

local major, minor, revision, codename = love.getVersion()
local str = string.format("%d.%d.%d - %s", major, minor, revision, codename)
info('Löve version', str)
info('Lua version', _VERSION)
info('Save data Directory', love.filesystem.getSaveDirectory())
