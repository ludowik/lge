require 'engine.lge'

-- /Users/ludo/Library/Application Support/LOVE/Lge


MySketch = class():extends(Sketch)

function MySketch:init()
    Sketch.init(self)
end

function MySketch:draw()
    love.graphics.clear(255, 0, 0)
    love.graphics.setFont(font)
    text("hello "..self.index, 100 + 100 * self.index, 100)
end

sketches = {
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch()
}

print(love.filesystem.getAppdataDirectory())

function updateScripts()
    if getOS():inList{'osx', 'ios'} then
        local url = 'https://ludowik.github.io/lge/build/lca.love'
        request(url, function (result, code, headers)
                local data = love.filesystem.write('lca.love', code)
            end,
            function (result, code, headers)
                print(headers)
            end)
    end
end

makezip()
