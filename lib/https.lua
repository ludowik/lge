--http = require 'socket.http'
https = require 'https'

function request(url, success, fail, parameterTable)
    --local result, code, headers = http.request(url, 'GET')
    print('download...')
    local code, result, headers = https.request(url, {
        method = 'GET',
        cache = "reload",
    })

    local title = "request "..url
    local message = "code "..code
    local buttons = {"OK"}

    love.window.showMessageBox(title, message, buttons)
    print(code)
    
    if result then
        print('download ok')
        if success then 
            success(result, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end
