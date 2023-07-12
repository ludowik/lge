TestPattern = class() : extends(Sketch)

function TestPattern:draw()
	background()

	rect(0, 0, W, H)

	line(0, 0, W, H)
	line(0, H, W, 0)
	
	circle(W/2, H/2, W/2)
	circle(W/2, H/2, H/2)
end
