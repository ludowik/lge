FlowFields = class():extends(Sketch)

function FlowFields:init()
    Sketch.init(self)

    self.sketchPixelRatio = 4

    self.num_columns = round(W / self.sketchPixelRatio)
    self.num_rows = round(H / self.sketchPixelRatio)

    self.grid = Array()

    local default_angle = PI * 0.25
    for i = 0, self.num_columns - 1 do
        self.grid[i] = Array()
        for j = 0, self.num_rows - 1 do
            self.grid[i][j] = default_angle
        end
    end

    self:initGrid()

    self.parameter:action('reset', function() self:initGrid() end)
    self.parameter:boolean('lines', true)

    self.img = FrameBuffer(self.num_columns, self.num_rows)
end

function FlowFields:initGrid()
    local scaled_x, scaled_y, noise_val, angle

    noiseSeed(0)

    local time = ElapsedTime / 10
    for i = 0, self.num_columns - 1 do
        for j = 0, self.num_rows - 1 do
            -- Processing's noise() works best when the step between
            -- points is approximately 0.005, so scale down to that
            scaled_x = i * 0.01
            scaled_y = j * 0.01

            -- get our noise value, between 0.0 and 1.0
            noise_val = noise(scaled_x, scaled_y, time)

            -- translate the noise value to an angle (betwen 0 and 2 * PI)
            angle = map(noise_val, 0, 1, 0, PI * 2)

            self.grid[i][j] = angle
        end
    end
end

function FlowFields:draw()
    self:initGrid()

    background(colors.white)

    local vec = vec2()

    if lines then
        for i = 0, self.num_columns - 1 do
            for j = 0, self.num_rows - 1 do
                vec:set(1, 0):rotate(self.grid[i][j])

                stroke(hsb2rgb(self.grid[i][j] / (PI * 2.), 0.5, 0.5))
                line(
                    i, j,
                    i + vec.x, j + vec.y)
            end
        end
    else
        self.fb:getImageData()
        self.fb.imageData:mapPixel(function(x, y)
            if self.grid[x] == nil or self.grid[x][y] == nil then return 1, 1, 1, 1 end
            return hsb2rgb(self.grid[x][y] / TAU, 0.5, 0.5)
        end)
    end
end
