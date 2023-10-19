
FlowFields = class() : extends(Sketch)

function FlowFields:init()
    Sketch.init(self)
    
    self.resolution = 1 -- devicePixelRatio

    self.num_columns = round(W/4)
    self.num_rows = round(H/4)

    self.grid = Array()

    local default_angle = PI * 0.25
    for i=0,self.num_columns-1 do
        self.grid[i] = Array()
        for j=0,self.num_rows-1 do
            self.grid[i][j] = default_angle
        end
    end

    self:initGrid()

    self.parameter:action('reset', function () self:initGrid() end)
    self.parameter:boolean('lines', true)

    self.img = FrameBuffer(self.num_columns, self.num_rows)
end

function FlowFields:initGrid()
    local scaled_x, scaled_y, noise_val, angle

    noiseSeed(0)

    local time = ElapsedTime / 10
    for i=0,self.num_columns-1 do
        for j=0,self.num_rows-1 do
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

    local ires, jres
    local vec = vec2()

    if lines then
        for i=0,self.num_columns-1 do
            ires = i * self.resolution

            for j=0,self.num_rows-1 do
                jres = j * self.resolution

                vec:set(self.resolution, 0):rotate(self.grid[i][j])

                stroke(hsb2rgb(self.grid[i][j] / (PI * 2.), 0.5, 0.5))
                line(
                    ires, jres,
                    ires + vec.x, jres + vec.y)                
            end
        end
    else
        self.img:getImageData()
        self.img.imageData:mapPixel(function (x, y)
            return hsb2rgb(self.grid[x][y] / TAU, 0.5, 0.5)
        end)
        sprite(self.img)
    end
end
