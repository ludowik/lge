TV = class() : extends(Sketch)

function TV:draw()
	background()

	local safeX, safeY, safeW, safeH = 0, 0, W, H

	love.graphics.translate(safeX, safeY)
	love.graphics.rectangle("line", 0, 0, safeW, safeH)
	love.graphics.line(0, 0, safeW, safeH)
	love.graphics.line(0, safeH, safeW, 0)
	love.graphics.circle('line', safeW/2, safeH/2, safeW/2)
	love.graphics.circle('line', safeW/2, safeH/2, safeH/2)
end
