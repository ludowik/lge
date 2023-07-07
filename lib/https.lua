local https = require 'https'

function request(url, success, fail, parameterTable)
    local code, result, headers = https.request(url, {
        method = 'GET',
        cache = 'reload',
    })
    
    if result then
        if success then 
            success(result, code, headers)
        end
        
    else        
        love.window.showMessageBox('request '..url, 'code '..code, {'OK'})
        if fail then
            fail(result, code, headers)
        end
    end
end
