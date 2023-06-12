require 'lua.debug'
require 'lua.string'
require 'class'
require 'index'
require 'event'
require 'engine'
require 'state'
require 'sketch'

MySketch = class():extends(Sketch)

function MySketch:init()
    Sketch.init(self)
end

function MySketch:draw()
    love.graphics.setFont(font)
    love.graphics.print("hello "..self.index, 100, 100)
end

sketches = {
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch(),
    MySketch()
}

sketch = sketches[1]
