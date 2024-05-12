function setup()
    stars = {}
    for i=1,2000 do
        stars[i] = {
            angle = random(TAU),
            angularSpeed = random(-0.1, -0.1),

            len = 0,
            linearSpeed = random(2, 15),

            width = random(1, 15),

            clr = Color.random()
        }
    end

    parameter:number('speed', 0, 50, 20)
end

function draw(dt)
    background(0, 0, 0, 0.05)

    translate(CX, CY)

    area = Rect(-CX, -CY, W, H)

    local position = vec2()

    local star
    for i=1,#stars do
        star = stars[i]

        position
        :set(
            cos(star.angle),
            sin(star.angle))
        :normalizeInPlace(star.len)

        stroke(star.clr)
        strokeSize(star.width)

        point(position.x, position.y)

        star.angle = star.angle + star.angularSpeed * speed * deltaTime
        star.len = star.len + star.linearSpeed * speed * deltaTime

        if not area:contains(position) then
            star.len = 0
        end
    end
end
