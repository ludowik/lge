function updateScripts(github)
    local url 
    if github then
        url = 'https://ludowik.github.io/lge'
    else
        url = 'http://192.168.1.13:8080' -- 1.13 at garches
    end
    
    url = url..'/build/love/lge.love'
    
    request(url,
        function (result, code, headers)
            local identity = love.filesystem.getIdentity()
            love.filesystem.setIdentity('lge')
            love.filesystem.write('lge.love', result)
            love.filesystem.setIdentity(identity)
        end,
        function (result, code, headers)
            log(result, code, headers)
        end)
end
