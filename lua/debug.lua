io.stdout:setvbuf("no")

-- if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
if arg[#arg] == "vsc_debug" then
    local lldebugger = require "lldebugger"
    lldebugger.start()

    debugMode = true
    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...)
            return lldebugger.call(f, false, ...)
        end
    end
end

if arg[#arg] == "-debug" then
    local mobdebug = require "mobdebug"
    mobdebug.start()

    debugMode = true
end
