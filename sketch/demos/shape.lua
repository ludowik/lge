function draw()
    background()

    beginShape()
        vertex(30, 20)
        bezierVertex(80, 0, 80, 75, 30, 75)
    endShape()

    translate(0, 100)

    beginShape()
        vertex(30, 20)
        bezierVertex(80, 0, 80, 75, 30, 75)
        bezierVertex(50, 80, 60, 25, 30, 20)
    endShape()
end
