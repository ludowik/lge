function draw()
    stroke(colors.red)
    strokeSize(20)
    noFill()

    local marge = 20

    local m = 8
    local n = even(32 * (H/W))

    local size = ((W-marge) / m) - marge

    for i = 0, m-1 do
        for j = 0, n-1 do
            stroke(Color.hsb(i*j+elapsedTime*50))
            rect(marge+i*(size+marge), marge+j*(size+marge), size, size)
        end
    end
end
