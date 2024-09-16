from array import array

from src.math.transform import *
from src.math.vector import *

from src.libc.opengl import gl, gl_ffi

size_float = gl_ffi.sizeof('GLfloat')


class MeshRender(object):
    n_render_calls = 0
    n_draw_arrays_calls = 0
    n_draw_arrays_instances_call = 0

    depth = 2500

    renderers = []

    def __init__(self):
        self.buffer = None
        self.buffer_instance = None

        self.graphic = None
        self.shader = None

        self.n_instances = 0
        self.max_instances = 100

        self.size_struct = 0

        MeshRender.renderers.append(self)

    @classmethod
    def render_all(cls):
        for renderer in MeshRender.renderers:
            renderer.render_batch()

    def render(self, graphic, shader, x=0, y=0, w=1, h=1, draw_mode=gl.GL_TRIANGLES):
        MeshRender.n_render_calls += 1

        self.graphic = graphic
        self.shader = shader

        if not self.buffer:
            self.create_buffer(graphic)

        self.render_buffer(graphic, shader, [vec2(x, y)], w, h, draw_mode)

    def render_instances(self, graphic, shader, vertices, w=1, h=1, draw_mode=gl.GL_TRIANGLES):
        MeshRender.n_render_calls += 1

        self.graphic = graphic
        self.shader = shader

        if not self.buffer:
            self.create_buffer(graphic)

        self.render_buffer(graphic, shader, vertices, w, h, draw_mode)

    def create_buffer(self, graphic):
        if self.buffer:
            gl.glDeleteBuffer(self.buffer)

        self.buffer = gl.glGenBuffer()
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer)

        self.nvertices = len(self.vertices) // 3
        self.ntranslations = len(self.translations) // 3
        self.ncolors = len(self.colors) // 4
        self.ntexcoords = len(self.textCoords) // 2

        self.data = self.vertices + self.translations + self.colors + self.textCoords

        gl.glBufferData(gl.GL_ARRAY_BUFFER, len(self.data) * 4, self.data.tobytes(), gl.GL_STATIC_DRAW)

    def attrib_buffer(self, graphic, shader):
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer)

        def vertex_attrib(buffer_id, nelements, ncomponents, offset):
            if buffer_id != -1:
                gl.glVertexAttribPointer(buffer_id, ncomponents, gl.GL_FLOAT, gl.GL_FALSE, 0,
                                         gl_ffi.cast('void*', offset))
            return nelements * ncomponents * 4

        attributes = shader.attributes

        offset = 0
        offset += vertex_attrib(attributes.locationPosition, self.nvertices, 3, offset)
        offset += vertex_attrib(attributes.locationTranslation, self.ntranslations, 3, offset)
        offset += vertex_attrib(attributes.locationColor, self.ncolors, 4, offset)
        offset += vertex_attrib(attributes.locationTexCoord, self.ntexcoords, 2, offset)

    def enable_buffer(self, graphic, shader):
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer)

        def vertex_enable(buffer_id):
            if buffer_id != -1:
                gl.glEnableVertexAttribArray(buffer_id)

        attributes = shader.attributes

        vertex_enable(attributes.locationPosition)
        vertex_enable(attributes.locationTranslation)
        vertex_enable(attributes.locationColor)
        vertex_enable(attributes.locationTexCoord)

    def render_buffer(self, graphic, shader, vertices, w, h, draw_mode=gl.GL_TRIANGLES):
        uniforms = shader.uniforms
        attributes = shader.attributes

        MeshRender.depth -= 0.0001

        shader.use()

        model_matrix = Transform.modelMatrix
        #                 * glm.translate(glm.mat4(), glm.vec3(x, y, MeshRender.depth)) \
        #                 * glm.scale(glm.mat4(), glm.vec3(w, h, 1))

        view_matrix = Transform.viewMatrix
        projection_matrix = Transform.projectionMatrix

        if uniforms.uniformModelMatrix != -1:
            gl.glUniformMatrix4fv(uniforms.uniformModelMatrix, 1, gl.GL_FALSE, model_matrix)
        if uniforms.uniformViewMatrix != -1:
            gl.glUniformMatrix4fv(uniforms.uniformViewMatrix, 1, gl.GL_FALSE, view_matrix)
        if uniforms.uniformProjectionMatrix != -1:
            gl.glUniformMatrix4fv(uniforms.uniformProjectionMatrix, 1, gl.GL_FALSE, projection_matrix)

        if uniforms.uniformSampler != -1:
            gl.glUniform1i(uniforms.uniformSampler, 0)

        if uniforms.uniformStrokeColor != -1:
            gl.glUniform4fv(uniforms.uniformStrokeColor, 1, *graphic.stroke_color)
        if uniforms.uniformFillColor != -1:
            gl.glUniform4fv(uniforms.uniformFillColor, 1, *graphic.fill_color)
        if uniforms.uniformTintColor != -1:
            gl.glUniform4fv(uniforms.uniformTintColor, 1, *graphic.tint_color)

        if uniforms.uniformPosition != -1:
            gl.glUniform3f(uniforms.uniformPosition, vertices[0].x, vertices[0].y, MeshRender.depth)

        if uniforms.uniformSize != -1:
            gl.glUniform3f(uniforms.uniformSize, w, h, 1)

        if uniforms.uniformRenderMode != -1:
            gl.glUniform1i(uniforms.uniformRenderMode,
                           (config.render_mode == 'batch' and self.max_instances > 1) and 1 or 0)

        if config.draw_mode == 'lines':
            draw_mode = gl.GL_LINE_LOOP

        if config.render_mode == 'batch' and self.max_instances > 1:
            self.size_struct = 1 * size_float + 16 * size_float
            offset = self.size_struct * self.n_instances

            if not self.buffer_instance:
                self.buffer_instance = gl.glGenBuffer()
                gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer_instance)
                gl.glBufferData(gl.GL_ARRAY_BUFFER, self.max_instances * self.size_struct, gl_ffi.NULL,
                                gl.GL_DYNAMIC_DRAW)

                self.data = array('f', list(range(17*self.max_instances)))
            else:
                gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer_instance)

            self.data[17*self.n_instances] = self.n_instances
            for i in range(16):
                self.data[17*self.n_instances+1+i] = glm.value_ptr(model_matrix)[i]

            self.n_instances += 1
            if self.n_instances == self.max_instances:
                self.render_batch(draw_mode)

        else:
            self.attrib_buffer(graphic, shader)
            self.enable_buffer(graphic, shader)

            gl.glDrawArrays(draw_mode, 0, self.nvertices)
            MeshRender.n_draw_arrays_calls += 1

    def render_batch(self, draw_mode=gl.GL_TRIANGLES):
        if self.n_instances > 0:
            uniforms = self.shader.uniforms
            attributes = self.shader.attributes

            self.shader.use()

            self.attrib_buffer(self.graphic, self.shader)
            self.enable_buffer(self.graphic, self.shader)

            gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.buffer_instance)
            gl.glBufferSubData(gl.GL_ARRAY_BUFFER, 0, 17 * size_float * self.n_instances, self.data.tobytes())

            if attributes.locationID != -1:
                gl.glVertexAttribPointer(attributes.locationID, 1, gl.GL_FLOAT, gl.GL_FALSE, self.size_struct,
                                         gl_ffi.NULL)
                gl.glVertexAttribDivisor(attributes.locationID, 1)
                gl.glEnableVertexAttribArray(attributes.locationID)

            if attributes.locationModelMatrix != -1:
                for i in range(4):
                    gl.glVertexAttribPointer(attributes.locationModelMatrix + i, 4, gl.GL_FLOAT, gl.GL_FALSE,
                                             self.size_struct, gl_ffi.cast('void*', (1 + i * 4) * size_float))
                    gl.glVertexAttribDivisor(attributes.locationModelMatrix + i, 1)
                    gl.glEnableVertexAttribArray(attributes.locationModelMatrix + i)

            gl.glDrawArraysInstanced(draw_mode, 0, self.nvertices, self.n_instances)
            MeshRender.n_draw_arrays_instances_call += 1

            self.n_instances = 0
