function getOS()
    return love.system.getOS():gsub(' ', ''):lower()
end

print('OS : '..getOS())
