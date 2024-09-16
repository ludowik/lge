io.stdout:setvbuf("no")

--if os.getenv 'LOCAL_LUA_DEBUGGER_VSCODE' == '1' then
if arg[#arg] == 'vsc_debug' then
    local lldebugger = require 'lldebugger'
    lldebugger.start()

    debugMode = true

    function love.run(...)
        local f = lldebugger.call(love.runProc, false, ...)
        return function(...)
            return lldebugger.call(f, false, ...)
        end
    end

    function breakpoint(check)
        if check then
            lldebugger.requestBreak()
        end
    end

-- elseif arg[#arg] == '-debug' then
--     local mobdebug = require 'mobdebug'
--     mobdebug.start()

--     debugMode = true

else
    function love.run(...)
        return love.runProc(...)
    end
end
