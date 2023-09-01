function getOS()
    return love.system.getOS():gsub(' ', ''):lower()
end

print(getOS())
