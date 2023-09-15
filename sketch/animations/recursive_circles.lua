function setup()
    angle = 0
--    colorMode(HSB, 1)
    parameter:boolean('color', 'color', true)
end

function update(dt)
    angle = angle + dt
end

function render(x, y, radius, level)
    if radius <= 3 then return end
    level = level or 0

    pushMatrix()
    do
        translate(x, y)
        rotate(angle * (level % 2 and -1.5 or 1))
        if color then
            fill(Color.hsl((level % 2 == 1) and (radius / (W / 2)) or (1 - radius / (W / 2)), 0.5, 0.5))
        else
            fill((level % 2 == 1) and colors.white or colors.black)
        end
        circle(0, 0, radius)
        level = level + 1
        render(-radius / 2, 0, radius / 2, level)
        render( radius / 2, 0, radius / 2, level)
        render(0, -radius * 2 / 3, radius / 3, level)
        render(0,  radius * 2 / 3, radius / 3, level)
    end
    popMatrix()
end

function draw()
    background(colors.green)
    noStroke()
    render(W / 2, H / 2, W / 2)
end
