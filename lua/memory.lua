function ram()
    return collectgarbage('count') * 1024
end

function gc()
    collectgarbage('collect')
end

function getMemoryInfo(__ram)
    __ram = __ram or ram()
    return string.format('%.1f mo', __ram / 1024 / 1024)
end
