io.stdout:setvbuf("no")

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
    local lldebugger = require "lldebugger"
    lldebugger.start()

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
end

function debug._traceback(message, level)
    for ligne in message:gmatch("[^\n]+") do
        print(ligne:gsub('engine/', './engine/'))
    end
    return message
end
