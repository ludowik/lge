function setup()
    scene = Scene()

    scene:add(pyramid('Khéops', 0, 0, 0, 230.902, 144.93, 201, floor(144.93/0.69)))
    scene:add(pyramid('Khéphren', -340, 0, -370, 215.16, 143.87, 201, floor(144.93/0.69)))
    
    camera(500, 50, 500, 0, 0, 0)

    parameter:boolean('lightMode', true)
end

function pyramid(name, x, y, z, W, H, nw, nh)
    local model = Model.box()

    local object = Mesh(model)
    object.draw = function (self)
        pushMatrix()
        translate(object.position)
        self.uniforms.useNormal = false
        self.uniforms.useMaterial = false
        self.uniforms.useLight = lightMode
        self.uniforms.useLightAmbient = true
        self.uniforms.useLightDiffuse = true
        self.uniforms.useLightSpecular = true
        self.uniforms.lights = {Light()}
        self:drawInstanced(self.instances)
        popMatrix()
    end
    
    object.position = vec3(x, y, z)
    object.instances = Array()

    local w = W/nw
    local h = H/nh
    
    local maxy = nw-10
    
    for y=1,maxy do
        for x=1,(nw+1-y) do
            for z=1,(nw+1-y) do
                if x == 1 or x == (nw+1-y) or z == 1 or z == (nw+1-y) or y == maxy then
                    object.instances:add{
                            (x-(nw+1-y)/2)*w,
                            (y*h),
                            (z-(nw+1-y)/2)*w,
                            w*.95, h*.95, w*.95,
                            229/256, 181/256, 114/256, 1}
                end
            end
        end
    end
    
    return object
end

function draw()
    background(colors.blue)
    perspective()
    
    fill(colors.red)

    light(true)
    
    ground(2000, 1, 2000)
    
    fill(colors.white)
    scene:draw()
end
