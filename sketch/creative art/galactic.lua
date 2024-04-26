function setup()
    stars = {}
    for i=1,1000 do
        stars[i] = {
            angle = random(TAU),
            len = random(W),
            width = random(1,5),
            speed = random(-0.001, -0.1),
            clr = Color.random()
        }
    end
    
    parameter:number('speed', 0, 5, 0.05)
end

function draw()
    background(0, 0.05)

    translate(W/2, H/2)

    local position = vec2()
    
    local star
    for i=1,#stars do
        star = stars[i]

        position:set(
            cos(star.angle),
            sin(star.angle))
        :normalizeInPlace(star.len)

        stroke(star.clr)
        strokeSize(star.width)

        point(position.x, position.y)

        star.angle = star.angle + star.speed * speed
    end
end
