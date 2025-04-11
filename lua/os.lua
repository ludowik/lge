function getOS()
    return love.system.getOS():gsub(' ', ''):lower()
end

info('OS : '..getOS())
