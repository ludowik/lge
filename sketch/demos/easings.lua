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
    for x=0,1,0.1 do
        vertex(
            x*self.size.x,
            self.position.y + self.size.x-self.easing(x)*self.size.x)
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
