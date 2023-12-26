function updateScripts(github)
    local url 
    if github then
        url = 'https://ludowik.github.io/lge'
    else
        url = 'http://192.168.1.29:8080' -- 1 at garches
    end

    url = url..'/build/lge.love'

    request(url,
        function (result, code, headers)
            local data = love.filesystem.write('lge.love', result)
        end,
        function (result, code, headers)
            log(result, code, headers)
        end)
end
