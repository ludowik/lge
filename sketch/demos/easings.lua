function setup()
    parameter:link('What is...', 'https://easings.net')
    parameter:action('restart', restart)

    restart()
end

function restart()
    scene = Scene()

    local r = 25
    local x, y = r, W*0.2

    for name,f in pairs(tween.easing) do
        local obj = Circle(x, y)
        scene:add(obj)
        animate(obj.position, vec2(W-r, obj.position.y), 1, f)
        y = y + 2*r + 5
    end
end

function draw()
    background()
    scene:draw()
end

Circle = class()

function Circle:init(x, y)
    self.position = vec2(x, y)
    self.size = vec2(25, 25)
end

function Circle:draw()
    noStroke()
    fill(colors.blue)
    ellipse(self.position.x, self.position.y, self.size.x, self.size.y)
end
