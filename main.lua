require 'engine.lge'

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

function updateScripts()
    if getOS():inList{'osx', 'ios'} then
        local url = 'https://ludowik.github.io/lca/lca.love'
        https.request(url, function ()
                exit()
            end,
            function (result, code, headers)
                print(headers)
            end)
    end
end
updateScripts()
makezip()
