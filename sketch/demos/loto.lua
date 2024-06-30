function setup()
	parameter:action('random', function ()
		seedValue = time()
		setSetting('seedValue', seedValue)
		reset()
	end)

	reset()
end

function reset()
	local seedValue = getSetting('seedValue', time())
	seed(seedValue)	

    balls = Array():forn(50, function (i)
        return i
    end)
	
	pronosticList = Array()
	for n in range(10) do
		local pronostic = {
			balls = Array(),
			stars = Array(),
		}

		for i in range(5) do
			local index = randomInt(#balls)
			pronostic.balls:add(balls[index])
			balls:remove(index)
		end

		for i in range(2) do
			pronostic.stars:add(randomInt(12))
		end

		pronostic.balls:sort()
		pronostic.stars:sort()
		
		pronosticList:add(pronostic)

		assert(#balls == 50 - n*5)
	end
	
	assert(#balls == 0)
end

function draw()
	background()
	
	local y = 100
	local w, h = textSize('50')
	local marge = w/2
	
	for i,pronostic in ipairs(pronosticList) do
		local x = 0

		for _,number in ipairs(pronostic.balls) do
			local wn = textSize(number)
			text(number, x+w-wn, y)
			x = x + w + marge
		end
		
		x = x + marge
		for _,number in ipairs(pronostic.stars) do
			local wn = textSize(number)
			text(number, x+w-wn, y)
			x = x + w + marge			
		end

		y = y + h
	end
end
