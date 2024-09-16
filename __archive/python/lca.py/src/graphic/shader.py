from src.libc.opengl import gl, gl_ffi
import io


class Shader(object):
    def __init__(self, name='default'):
        self.name = name
        self.info = None

        self.program = gl.glCreateProgram()

        vertex = io.open('src/graphic/shaders/{0}.vertex'.format(self.name)).read()
        fragment = io.open('src/graphic/shaders/{0}.fragment'.format(self.name)).read()

        self.ids = type('ids', (), {
            'vertex'  : self.buildShader(gl.GL_VERTEX_SHADER, vertex),
            'fragment': self.buildShader(gl.GL_FRAGMENT_SHADER, fragment)
        })

        gl.glLinkProgram(self.program)

        class Attributes:
            locationPosition    = gl.glGetAttribLocation(self.program, 'VertexPosition')
            locationTranslation = gl.glGetAttribLocation(self.program, 'VertexTranslation')
            locationColor       = gl.glGetAttribLocation(self.program, 'VertexColor')
            locationTexCoord    = gl.glGetAttribLocation(self.program, 'VertexTexCoord')
            locationID          = gl.glGetAttribLocation(self.program, 'ID')
            locationModelMatrix = gl.glGetAttribLocation(self.program, 'model_matrix2')

        self.attributes = Attributes()

        class Uniforms:
            uniformModelMatrix      = gl.glGetUniformLocation(self.program, 'model_matrix')
            uniformViewMatrix       = gl.glGetUniformLocation(self.program, 'view_matrix')
            uniformProjectionMatrix = gl.glGetUniformLocation(self.program, 'projection_matrix')

            uniformStrokeColor = gl.glGetUniformLocation(self.program, 'stroke_color')
            uniformFillColor   = gl.glGetUniformLocation(self.program, 'fill_color')
            uniformTintColor   = gl.glGetUniformLocation(self.program, 'tint_color')

            uniformSampler = gl.glGetUniformLocation(self.program, 'texture0')

            uniformPosition = gl.glGetUniformLocation(self.program, 'position')
            uniformSize = gl.glGetUniformLocation(self.program, 'size')

            uniformRenderMode = gl.glGetUniformLocation(self.program, 'render_mode')

        self.uniforms = Uniforms()


    def release(self):
        if self.program != -1 and gl.glIsProgram(self.program) == gl.GL_TRUE:
            if self.ids.vertex != -1 and gl.glIsShader(self.ids.vertex) == gl.GL_TRUE:
                gl.glDetachShader(self.program, self.ids.vertex)
                gl.glDeleteShader(self.ids.vertex)
                self.ids.vertex = -1

            if self.ids.fragment != -1 and gl.glIsShader(self.ids.fragment) == gl.GL_TRUE:
                gl.glDetachShader(self.program, self.ids.fragment)
                gl.glDeleteShader(self.ids.fragment)
                self.ids.fragment = -1

            gl.glDeleteProgram(self.program)
            self.program = -1


    def glGetShaderInfoLog(self, id):
        ptr_int = gl_ffi.new('GLint[]', 1)
        gl.glGetShaderiv(id, gl.GL_INFO_LOG_LENGTH, ptr_int)

        info_len = ptr_int[0]
        if info_len == 0:
            return 'info_len == 0'
        else:
            log = gl_ffi.new('GLchar[]', info_len)
            gl.glGetShaderInfoLog(id, info_len, gl_ffi.NULL, log)
            self.info = gl_ffi.string(log, info_len - 1) #.replace('ERROR: 0', '')
            return self.info


    def buildShader(self, shaderType, code):
        shader_id = gl.glCreateShader(shaderType)

        ptr_code = [gl_ffi.char(code)]

        ptr_string = gl_ffi.new('const GLchar*[]', ptr_code)
        ptr_lenght = gl_ffi.new('GLint[1]', [len(code)])

        gl.glShaderSource(shader_id, 1, ptr_string, ptr_lenght)
        gl.glCompileShader(shader_id)

        ptr_int = gl_ffi.new('GLint[]', 1)
        gl.glGetShaderiv(shader_id, gl.GL_COMPILE_STATUS, ptr_int)
        res = ptr_int[0]

        if res == gl.GL_FALSE:
            print(self.glGetShaderInfoLog(shader_id).decode())

        gl.glAttachShader(self.program, shader_id)

        return shader_id


    def use(self):
        gl.glUseProgram(self.program)


    def send(self, name, val):
        uid = gl.glGetUniformLocation(self.program, name)
        if uid != -1:
            gl.glUniform1i(uid, val)
