FlowFields = class():extends(Sketch)

function FlowFields:init()
    Sketch.init(self)

    self.parameter:action('reset', function() self:initGrid() end)
    self.parameter:boolean('lines', false, redraw)

    self.parameter:number('step', 0.001, 0.1, 0.01)
    self.parameter:integer('pixelRatio', 4, 16, 6, function () self:reset() end)
end

function FlowFields:resize()
    self:reset()
end

function FlowFields:reset()
    self.sketchPixelRatio = pixelRatio

    self.num_columns = round(W / self.sketchPixelRatio)
    self.num_rows = round(H / self.sketchPixelRatio)

    self.img = FrameBuffer(self.num_columns, self.num_rows)

    self.grid = Array()
    for i = 1, self.num_columns do
        self.grid[i] = Array()
        for j = 1, self.num_rows do
            self.grid[i][j] = 0
        end
    end
    self:initGrid()
end

function FlowFields:initGrid()
    local scaled_x, scaled_y, noise_val, angle

    noiseSeed(0)

    local scale = step * self.sketchPixelRatio

    local time = elapsedTime / 10
    for i = 1, self.num_columns do
        local grid = self.grid[i]
        for j = 1, self.num_rows do
            -- Processing's noise() works best when the step between
            -- points is approximately 0.005, so scale down to that
            scaled_x = i * scale
            scaled_y = j * scale

            -- get our noise value, between 0.0 and 1.0
            noise_val = noise(scaled_x, scaled_y, time)

            -- translate the noise value to an angle (betwen 0 and 2 * PI)
            angle = map(noise_val, 0, 1, 0, TAU)

            grid[j] = angle
        end
    end
end

function FlowFields:draw()
    self:initGrid()

    background(colors.white)

    local vec = vec2()

    scale(self.sketchPixelRatio)

    if lines then        
        strokeSize(1)
        
        translate(-1, -0.5)

        for x = 1, self.num_columns do
            for y = 1, self.num_rows do
                vec:set(self.sketchPixelRatio, 0):rotate(self.grid[x][y])
                stroke(hsb2rgb(self.grid[x][y] / TAU, 0.5, 0.5))

                line(
                    x, y,
                    x + vec.x, y + vec.y)
            end
        end

    else
        self.img:mapPixel(function(x, y)
            x = x + 1
            y = y + 1

            if self.grid[x] == nil or self.grid[x][y] == nil then return 1, 1, 1, 1 end
            return hsb2rgb(self.grid[x][y] / TAU, 0.5, 0.5)
        end)
        self.img.texture:setFilter('nearest', 'nearest')

        sprite(self.img)
    end
end
