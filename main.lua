require 'lua.debug'
require 'lua.string'
require 'class'
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
    love.graphics.print("hello "..sketchIndex, 100, 100)
end

sketch = MySketch()
