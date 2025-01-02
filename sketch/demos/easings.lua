function setup()
    parameter:link('What is...', 'https://easings.net')
    parameter:action('restart', init)

    init()
end

function init()
    scene = Scene()

    local r = 25
    local x, y = r, CY-r*#tween.easingFunctions

    for name,f in pairs(tween.easing) do
        local obj = Circle(name, f, x, y, r)
        scene:add(obj)
        obj.tween = animate(obj.position, vec2(W-r, obj.position.y), 1, f)        
        y = y + 2*r + 5
    end
end

function draw()
    background()
    scene:draw()
end

Circle = class()

function Circle:init(name, easing, x, y, r)
    self.name = name
    self.easing = easing
    self.position = vec2(x, y)
    self.size = vec2(r, r)
end

function Circle:draw()
    stroke(colors.gray)
    strokeSize(1)
    beginShape()
    for x=0,1,0.05 do
        vertex(
            x*self.size.x,
            self.position.y + self.easing(x, 0, self.size.x, 1)
        )
    end
    endShape()

    text(self.name, self.size.x, self.position.y)

    noStroke()
    if self.tween.state == 'running' then
        fill(colors.blue)
    else
        fill(colors.red)
    end
    ellipse(self.position.x, self.position.y, self.size.x, self.size.y)
end
