if false and os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
    lldebugger = require "lldebugger"
    lldebugger.start()

    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...)
            return lldebugger.call(f, false, ...)
        end
    end
end

io.stdout:setvbuf("no")

if arg[#arg] == "-debug" then
    require("mobdebug").start()
end

-- function debug.traceback(message, level)
--     for ligne in message:gmatch("[^\n]+") do
--         print(ligne:gsub('engine/', './engine/'))
--     end
--     return message
-- end
