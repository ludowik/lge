requireLib {
    'lexer',
    'parser'
}

function setup()
    local directoryItems = love.filesystem.getDirectoryItems('engine', '*.lua')
    for i,file in ipairs(directoryItems) do
        lexer(love.filesystem.read('engine/'..file))
    end
end
