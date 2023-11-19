function setup()
    parameter:integer('r', 20, W, 50)
end

function draw()
    background()

    translate(W/2, H/2)
    print(W/2, H/2)

    --r = 50
    rectMode(CENTER)
    rect(0, 0, r, r)
    
    circleMode(CENTER)
    circle(0, 0, r/2)
end