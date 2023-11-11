function getOS()
    return love.system.getOS():gsub(' ', ''):lower()
end

log('OS : '..getOS())
