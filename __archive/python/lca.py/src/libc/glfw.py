ffi = FFI()
ffi.set_source("bin.glfw",
#               extra_compile_args=[r'-F/Users/lca/Projets/Lib/glfw/include/GLFW'],
               extra_link_args=[r'/Users/lca/Projets/Lib/glfw/lib-macos/libglfw3.a'],
               source="""
    #include "/Users/lca/Projets/Lib/glfw/include/GLFW/glfw3.h"
    
    void test() {
        glfwInit();
    }
""")

ffi.cdef("""
    void test();
""")

ffi.compile(verbose=True)

import bin.glfw as glfw
print(dir(glfw.lib))

def init_glfw():
    # Initialize the library
    if not glfwInit():
        return

    # Create a windowed mode window and its OpenGL context
    w = 2400
    h = int(w/16*9)
    window = glfwCreateWindow(w//2, h//2, b"Hello World", None, None)
    if not window:
        glfwTerminate()
        return

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1)

    glfwWindowHint(0x00023002, GL_FALSE)

    # Make the window's context current
    glfwMakeContextCurrent(window)

    @GLFWkeyfun
    def key(window, key, scancode, action, mods):
        if key == GLFW_KEY_ESCAPE:
            glfwSetWindowShouldClose(window, 1)

    glfwSetKeyCallback(window, key)

    @GLFWcursorposfun
    def cursorPos(window, xpos, ypos):
        pos.x = xpos*2
        pos.y = h-ypos*2

    glfwSetCursorPosCallback(window, cursorPos)

    shader = Shader()
    # Loop until the user closes the window
    while not glfwWindowShouldClose(window):
        # Render here, e.g. using pyOpenGL
        glViewport(0, 0, w, h)

        glClearColor(0, 0, 0, 1)
        glClearDepth(1)
        glClear(
            GL_COLOR_BUFFER_BIT |
            GL_DEPTH_BUFFER_BIT)

        matrix = glm.ortho(0, w, 0, h)
        render.render(shader, matrix, 0, 0, pos.x, pos.y)

        # Swap front and back buffers
        glfwSwapBuffers(window)

        # Poll for and process events
        glfwPollEvents()


    glfwTerminate()
    