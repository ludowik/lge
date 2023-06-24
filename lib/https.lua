--http = require 'socket.http'
https = require 'https'

function request(url, success, fail, parameterTable)
    --local result, code, headers = http.request(url, 'GET')
    local code, result, headers = https.request(url, 'GET')

    if result then
        if success then 
            success(result, code, headers)
        end
        
    else        
        if fail then
            fail(result, code, headers)
        end
    end

end
