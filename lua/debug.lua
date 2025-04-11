io.stdout:setvbuf("no")

if arg[#arg] == 'vsc_debug' then
    local lldebugger = require 'lldebugger'
    lldebugger.start()

    debugMode = true

    info('debug mode')

    function love.run(...)
        local f = lldebugger.call(love.runProc, false, ...)
        return function (...)
            return lldebugger.call(f, false, ...)
        end
    end

    function breakpoint(check)
        if check then
            lldebugger.requestBreak()
        end
    end

else
    function love.run(...)
        return love.runProc(...)
    end
end

function __FILE__(level)
    return debug.getinfo(level or 1, 'S').source or 'unknown file'
end

function __LINE__(level) return debug.getinfo(level or 1, 'l').currentline or 'unknown line' end

function __FUNC__(level) return debug.getinfo(level or 1).name or 'unknown function' end

function getFileLocation(msg, level)
    level = 3 + (level or 1)

    if __FUNC__(level) then
        msg = msg and tostring(msg) or ''

        local file = __FILE__(level) or ''
        local line = __LINE__(level) or ''

        return file .. ':' .. line
    end
end

function getFunctionLocation(msg, level)
    level = level or 0

    local fileLocation = getFileLocation(msg, level + 1)
    if fileLocation then
        msg = msg and tostring(msg) or ''

        local func = __FUNC__(level + 3) or ''

        return fileLocation .. ': ' .. msg .. ' ' .. func
    end
end

function logf(msg, ...)
    info(getFunctionLocation(nil, 1))
    if msg then
        info(msg, ...)
    end
end

function logcall(level, msg, ...)
    info(getFunctionLocation(nil, level))
    if msg then
        info(msg, ...)
    end
end
