Shader = class()

function Shader:init(name, path)
    self.path = path or 'resources'

    self.name = name
    self.pathName = self.path..'/'..self.name
    
    self.vertexShader = {pathFile = self.pathName..'.vertex.glsl'}
    self.pixelShader  = {pathFile = self.pathName..'.pixel.glsl'}

    self:loadProgram()
end

function Shader:loadProgram()
    local vs = self:loadShaderCode(self.vertexShader)
    local ps = self:loadShaderCode(self.pixelShader)
    
    if vs or ps then
        self.errorMsg = nil
        
        local status, result = xpcall(
            function ()
                return love.graphics.newShader(self.pixelShader.code, self.vertexShader.code)
            end,
            function (msg)
                log(msg)
                self.errorMsg = msg
            end)

        if status then
            self.program = result
        end
    end
end

function Shader:loadShaderCode(shader)
    if not shader.pathFile then return false end

    local info = love.filesystem.getInfo(shader.pathFile)
    if not info then return false end

    local modtime = info.modtime
    if shader.modtime == nil or modtime > shader.modtime then
        shader.modtime = modtime
        local noise2d = love.filesystem.read(self.path..'/noise2d.glsl')
        local noise3d = love.filesystem.read(self.path..'/noise3d.glsl')
        shader.code = '#pragma language glsl3'..NL..
            noise2d..NL..
            noise3d..NL..
            '#line 1'..NL..
            love.filesystem.read(shader.pathFile)
        return true
    end
end

function Shader:update(dt)
    self:loadProgram()
end

function Shader:send(name, value)
    if self.program:hasUniform(name) then
        self.program:send(name, value)
    end
end

ShaderToy = class() : extends(Shader)

function ShaderToy:init(...)
    Shader.init(self, ...)

    self.vertexShader = {}
    self.pixelShader  = {pathFile = self.pathName..'.glsl'}
end

function ShaderToy:loadShaderCode(shader)
    local ok = Shader.loadShaderCode(self, shader)
    if ok then
        local declarations = [[
            vec4 iResolution;
            //uniform vec3      iResolution;           // viewport resolution (in pixels)
            uniform float     iTime;                 // shader playback time (in seconds)
            uniform float     iTimeDelta;            // render time (in seconds)
            uniform float     iFrameRate;            // shader frame rate
            uniform int       iFrame;                // shader playback frame
            uniform float     iChannelTime[4];       // channel playback time (in seconds)
            uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
            uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
            uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel1;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel2;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel3;             // input channel. XX = 2D/Cube
            uniform vec4      iDate;                 // (year, month, day, time in seconds)

            varying vec3 vPosition;
            varying vec2 vTexCoords;

            #define PI 3.14159265359
            
            #define love_texture Texel
            #define texture2D Texel
            #define precision
            #define highp
            
            #line 0
        ]]

        local mainFunction = [[
            vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
                iResolution = love_ScreenSize;
                
                vec4 fragColor;
                mainImage(fragColor, screen_coords);
                return fragColor;
            }
        ]]
        shader.code = declarations..shader.code..mainFunction
        return ok
    end
end
