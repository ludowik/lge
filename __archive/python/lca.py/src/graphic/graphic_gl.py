from src.graphic.image import *
from src.graphic.mesh import *
from src.engine.style import *
from src.math.vector import *
from src.graphic.shader import *


class GraphicGL(Style):
    def __init__(self):
        self.shaders = {}
        self.meshes = {}

    def setup(self):
        self.init_meshes()
        self.init_shaders()

    def init_meshes(self):
        self.meshes['line'] = Mesh()
        self.meshes['line'].vertices, self.meshes['line'].translations = Geometry.line()

        self.meshes['rect'] = Mesh(Geometry.rect())

        self.meshes['text'] = Mesh(Geometry.rect())
        self.meshes['text'].max_instances = 1

        self.meshes['sprite'] = Mesh(Geometry.rect())

        self.meshes['circle'] = Mesh(Geometry.circle())

        self.meshes['box'] = Mesh(Geometry.box())

        self.mesh_circle = self.meshes['circle']

    def init_shaders(self):
        self.shaders['default'] = Shader('default')

        self.shaders['line'] = Shader('default')
        self.shaders['line'].use()
        self.shaders['line'].send('useTranslation', 1)

        self.shaders['texture_alpha'] = Shader('default')
        self.shaders['texture_alpha'].use()
        self.shaders['texture_alpha'].send('useTextureAlpha', 1)

        self.shaders['texture'] = Shader('default')
        self.shaders['texture'].use()
        self.shaders['texture'].send('useTexture', 1)

        self.shaders['box'] = Shader('default')

        self.shader_default = self.shaders['default']

    def release(self):
        for shader in self.shaders.values():
            shader.release()

    def reset(self):
        self.reset_style()

        MeshRender.n_render_calls = 0
        MeshRender.n_draw_arrays_calls = 0
        MeshRender.n_draw_arrays_instances_call = 0
        MeshRender.depth = 100

    def draw_mode(self):
        gl.glEnable(gl.GL_DEPTH_TEST)
        gl.glDepthFunc(gl.GL_LEQUAL)

        gl.glDisable(gl.GL_CULL_FACE)

        gl.glEnable(gl.GL_BLEND)
        gl.glBlendEquation(gl.GL_FUNC_ADD)
        gl.glBlendFuncSeparate(
            gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA,
            gl.GL_ONE, gl.GL_ONE_MINUS_SRC_ALPHA)

        gl.glEnable(gl.GL_TEXTURE_2D)

    def render_batch(self):
        MeshRender.render_all()

    def background(self, clr):
        gl.glClearColor(*clr)
        gl.glClearDepth(1)

        gl.glClear(
            gl.GL_COLOR_BUFFER_BIT +
            gl.GL_DEPTH_BUFFER_BIT)

    def point(self, x, y):
        self.circle(x, y, self._stroke_width)

    def points(self, vertices):
        self.meshes['circle'].render_instances(self, self.shaders['default'], vertices, self._stroke_width, self._stroke_width)
        #for vertex in vertices:
        #    self.point(vertex.x, vertex.y)

    def line(self, x1, y1, x2, y2):
        self.shaders['line'].use()
        gl.glUniform2fv(self.shaders['line'].uniforms.uniformPosition, 1, x1, y1)
        gl.glUniform2fv(self.shaders['line'].uniforms.uniformSize, 1, x2 - x1, y2 - y1)
        self.meshes['line'].render(self, self.shaders['line'], x1, y1, x2 - x1, y2 - y1, gl.GL_TRIANGLE_STRIP)

    def lines(self, vertices):
        first_vertex = vertices[0]
        for second_vertex in vertices[1:]:
            self.line(first_vertex.x, first_vertex.y, second_vertex.x, second_vertex.y)
            first_vertex = second_vertex

    def rect(self, x, y, w, h):
        self.meshes['rect'].render(self, self.shaders['default'], x, y, w, h)

    def circle(self, x, y, r):
        self.mesh_circle.render(self, self.shader_default, x, y, r, r)

    def ellipse(self, x, y, w, h):
        self.meshes['circle'].render(self, self.shaders['default'], x, y, w, h)

    def sprite(self, image, x, y):
        image.use()
        self.meshes['sprite'].render(self, self.shaders['texture'], x, y, image.surface.w, -image.surface.h)

    def text(self, txt, x, y):
        glyph = Text(self.face, str(txt))
        glyph.use()
        self.meshes['text'].render(self, self.shaders['texture_alpha'], x, y, glyph.surface.w, -glyph.surface.h)
        return vec2(glyph.surface.w, glyph.surface.h)

    def text_size(self, txt):
        glyph = Text(self.face, str(txt))
        return vec2(glyph.surface.w, glyph.surface.h)

    def box(self):
        self.meshes['box'].render(self, self.shaders['box'])
