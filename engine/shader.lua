Shader = class('')

function Shader:init(name)
    self.name = name
    self.pathName = 'sketch/shader/'..self.name
    
    self.vertexShader = {pathFile = self.pathName..'.vertex.glsl'}
    self.pixelShader  = {pathFile = self.pathName..'.pixel.glsl'}

    self:loadProgram()
end

function Shader:loadProgram()
    local vs = self:loadShaderCode(self.vertexShader)
    local ps = self:loadShaderCode(self.pixelShader)
    if vs or ps then
        self.errorMsg = nil
        
        local status, result = xpcall(function () return love.graphics.newShader(self.pixelShader.code, self.vertexShader.code) end,
        function (msg)
            print(msg)
            self.errorMsg = msg
        end)

        if status then
            self.program = result
        end
    end
end

function Shader:loadShaderCode(shader)
    local modtime = love.filesystem.getInfo(shader.pathFile).modtime
    if shader.modtime == nil or modtime > shader.modtime then
        shader.modtime = modtime
        shader.code = love.filesystem.read(shader.pathFile)
        return true
    end
end

function Shader:update(dt)
    self:loadProgram()
end
