typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

typedef uint32_t GLbitfield;
typedef uint8_t GLboolean;
typedef int8_t GLbyte;
typedef float GLclampf;
typedef uint32_t GLenum;
typedef float GLfloat;
typedef int32_t GLint;
typedef int16_t GLshort;
typedef int32_t GLsizei;
typedef uint8_t GLubyte;
typedef uint32_t GLuint;
typedef uint16_t GLushort;
typedef void GLvoid;
typedef char GLchar;
typedef double GLdouble;
typedef double GLclampd;

typedef intptr_t GLintptr;
typedef intptr_t GLsizeiptr;

#define GL_NO_ERROR 0

#define GL_TRUE 1
#define GL_FALSE 0

#define GL_LINE_SMOOTH 0x0B20

#define GL_VERTEX_SHADER 0x8B31
#define GL_FRAGMENT_SHADER 0x8B30

#define GL_COMPILE_STATUS 0x8B81
#define GL_INFO_LOG_LENGTH 0x8B84

#define GL_ARRAY_BUFFER 0x8892
#define GL_ELEMENT_ARRAY_BUFFER 0x8893

#define GL_STATIC_DRAW 0x88E4
#define GL_DYNAMIC_DRAW 0x88E8
#define GL_STREAM_DRAW 0x88E0

#define GL_POINTS 0x0000

#define GL_LINES 0x0001
#define GL_LINES_ADJACENCY 0x000A
#define GL_LINE_LOOP 0x0002
#define GL_LINE_STRIP 0x0003
#define GL_LINE_STRIP_ADJACENCY 0x000B

#define GL_TRIANGLES 0x0004
#define GL_TRIANGLES_ADJACENCY 0x000C
#define GL_TRIANGLE_FAN 0x0006
#define GL_TRIANGLE_STRIP 0x0005
#define GL_TRIANGLE_STRIP_ADJACENCY 0x000D

#define GL_UNSIGNED_BYTE 0x1401
#define GL_SHORT 0x1402
#define GL_UNSIGNED_SHORT 0x1403
#define GL_INT 0x1404
#define GL_UNSIGNED_INT 0x1405
#define GL_FLOAT 0x1406

#define GL_COLOR_BUFFER_BIT 0x00004000
#define GL_DEPTH_BUFFER_BIT 0x00000100

#define GL_TEXTURE_2D 0x0DE1

#define GL_TEXTURE0 0x84C0
#define GL_TEXTURE1 0x84C1

#define GL_TEXTURE_MIN_FILTER 0x2801
#define GL_TEXTURE_MAG_FILTER 0x2800

#define GL_TEXTURE_WRAP_R 0x8072
#define GL_TEXTURE_WRAP_S 0x2802
#define GL_TEXTURE_WRAP_T 0x2803

#define GL_LINEAR 0x2601

#define GL_CLAMP_TO_BORDER 0x812D
#define GL_CLAMP_TO_EDGE 0x812F

#define GL_ALPHA 0x1906

#define GL_RGB 0x1907
#define GL_BGR 0x80E0

#define GL_RGBA 0x1908
#define GL_BGRA 0x80E1

#define GL_UNPACK_ALIGNMENT 0x0CF5

#define GL_BLEND 0x0BE2
#define GL_FUNC_ADD 0x8006

#define GL_ONE 1
#define GL_SRC_ALPHA 0x0302
#define GL_ONE_MINUS_SRC_ALPHA 0x0303

#define GL_CULL_FACE 0x0B44

#define GL_DEPTH_TEST 0x0B71

#define GL_LEQUAL 0x0203
#define GL_LESS 0x0201

GLenum glGetError(void);

void glEnable(GLenum cap);
void glDisable(GLenum cap);

GLboolean glIsProgram(GLuint program);
GLuint glCreateProgram(void);
void glDeleteProgram(GLuint program);

GLboolean glIsShader(GLuint shader);
GLuint glCreateShader(GLenum type);
void glShaderSource(GLuint shader, GLsizei count, const GLchar* const *string, const GLint *length);
void glCompileShader(GLuint shader);
void glGetShaderiv(GLuint shader, GLenum pname, GLint *params);
void glAttachShader(GLuint program, GLuint shader);
void glDetachShader(GLuint shader);
void glDeleteShader(GLuint shader);
void glGetShaderInfoLog(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
void glLinkProgram(GLuint program);
void glUseProgram(GLuint program);

GLboolean glIsBuffer(GLuint buffer);
void glGenBuffers(GLsizei n, GLuint *buffers);
void glDeleteBuffers(GLsizei n, const GLuint *buffers);
void glBindBuffer(GLenum target, GLuint buffer);
void glBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
void glBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);

GLboolean glIsTexture(GLuint texture);
void glGenTextures(GLsizei n, GLuint *textures);
void glDeleteTextures(GLsizei n, const GLuint *textures);
void glBindTexture(GLenum target, GLuint texture);
void glActiveTexture(GLenum texture);
void glTexImage2D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glPixelStorei(GLenum pname, GLint param);
void glTexParameteri(GLenum target, GLenum pname, GLint param);

GLint glGetAttribLocation(GLuint program, const GLchar *name);
GLint glGetUniformLocation(GLuint program, const GLchar *name);

void glUniform1f(GLint location, GLfloat v0);
void glUniform2f(GLint location, GLfloat v0, GLfloat v1);
void glUniform3f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
void glUniform4f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
void glUniform1i(GLint location, GLint v0);
void glUniform2i(GLint location, GLint v0, GLint v1);
void glUniform3i(GLint location, GLint v0, GLint v1, GLint v2);
void glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
void glUniform1fv(GLint location, GLsizei count, const GLfloat *value);
void glUniform2fv(GLint location, GLsizei count, const GLfloat *value);
void glUniform3fv(GLint location, GLsizei count, const GLfloat *value);
void glUniform4fv(GLint location, GLsizei count, const GLfloat *value);
void glUniform1iv(GLint location, GLsizei count, const GLint *value);
void glUniform2iv(GLint location, GLsizei count, const GLint *value);
void glUniform3iv(GLint location, GLsizei count, const GLint *value);
void glUniform4iv(GLint location, GLsizei count, const GLint *value);
void glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);

void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
void glVertexAttribDivisor(GLuint index, GLuint divisor);

void glEnableVertexAttribArray(GLuint index);
void glDisableVertexAttribArray(GLuint index);

void glClear(GLbitfield mask);
void glClearColor(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void glClearStencil(GLint s);
void glClearDepth(GLclampd depth);

void glDepthFunc(GLenum func);

void glBlendEquation(GLenum mode);
void glBlendFuncSeparate(GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);

void glDrawArrays(GLenum mode, GLint first, GLsizei count);
void glDrawElements(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);

void glDrawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei instancecount);
void glDrawElementsInstanced(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei instancecount);

typedef GLenum (*PFN_glGetError)(void);

typedef void (*PFN_glEnable)(GLenum cap);
typedef void (*PFN_glDisable)(GLenum cap);

typedef GLboolean (*PFN_glIsProgram)(GLuint program);
typedef GLuint (*PFN_glCreateProgram)(void);
typedef void (*PFN_glDeleteProgram)(GLuint program);

typedef GLboolean (*PFN_glIsShader)(GLuint shader);
typedef GLuint (*PFN_glCreateShader)(GLenum type);
typedef void (*PFN_glShaderSource)(GLuint shader, GLsizei count, const GLchar* const *string, const GLint *length);
typedef void (*PFN_glCompileShader)(GLuint shader);
typedef void (*PFN_glGetShaderiv)(GLuint shader, GLenum pname, GLint *params);
typedef void (*PFN_glAttachShader)(GLuint program, GLuint shader);
typedef void (*PFN_glDetachShader)(GLuint program, GLuint shader);
typedef void (*PFN_glDeleteShader)(GLuint shader);
typedef void (*PFN_glGetShaderInfoLog)(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
typedef void (*PFN_glLinkProgram)(GLuint program);
typedef void (*PFN_glUseProgram)(GLuint program);

typedef GLboolean (*PFN_glIsBuffer)(GLuint buffer);
typedef void (*PFN_glGenBuffers)(GLsizei n, GLuint *buffers);
typedef void (*PFN_glDeleteBuffers)(GLsizei n, const GLuint *buffers);
typedef void (*PFN_glBindBuffer)(GLenum target, GLuint buffer);
typedef void (*PFN_glBufferData)(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
typedef void (*PFN_glBufferSubData)(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);

typedef GLboolean (*PFN_glIsTexture)(GLuint texture);
typedef void (*PFN_glGenTextures)(GLsizei n, GLuint *textures);
typedef void (*PFN_glDeleteTextures)(GLsizei n, const GLuint *textures);
typedef void (*PFN_glBindTexture)(GLenum target, GLuint texture);
typedef void (*PFN_glActiveTexture)(GLenum texture);
typedef void (*PFN_glTexImage2D)(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (*PFN_glPixelStorei)(GLenum pname, GLint param);
typedef void (*PFN_glTexParameteri)(GLenum target, GLenum pname, GLint param);

typedef GLint (*PFN_glGetAttribLocation)(GLuint program, const GLchar *name);
typedef GLint (*PFN_glGetUniformLocation)(GLuint program, const GLchar *name);

typedef void (*PFN_glUniform1f)(GLint location, GLfloat v0);
typedef void (*PFN_glUniform2f)(GLint location, GLfloat v0, GLfloat v1);
typedef void (*PFN_glUniform3f)(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
typedef void (*PFN_glUniform4f)(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
typedef void (*PFN_glUniform1i)(GLint location, GLint v0);
typedef void (*PFN_glUniform2i)(GLint location, GLint v0, GLint v1);
typedef void (*PFN_glUniform3i)(GLint location, GLint v0, GLint v1, GLint v2);
typedef void (*PFN_glUniform4i)(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
typedef void (*PFN_glUniform1fv)(GLint location, GLsizei count, const GLfloat *value);
typedef void (*PFN_glUniform2fv)(GLint location, GLsizei count, const GLfloat *value);
typedef void (*PFN_glUniform3fv)(GLint location, GLsizei count, const GLfloat *value);
typedef void (*PFN_glUniform4fv)(GLint location, GLsizei count, const GLfloat *value);
typedef void (*PFN_glUniform1iv)(GLint location, GLsizei count, const GLint *value);
typedef void (*PFN_glUniform2iv)(GLint location, GLsizei count, const GLint *value);
typedef void (*PFN_glUniform3iv)(GLint location, GLsizei count, const GLint *value);
typedef void (*PFN_glUniform4iv)(GLint location, GLsizei count, const GLint *value);
typedef void (*PFN_glUniformMatrix2fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (*PFN_glUniformMatrix3fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
typedef void (*PFN_glUniformMatrix4fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);

typedef void (*PFN_glVertexAttribPointer)(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
typedef void (*PFN_glVertexAttribDivisor)(GLuint index, GLuint divisor);

typedef void (*PFN_glEnableVertexAttribArray)(GLuint index);
typedef void (*PFN_glDisableVertexAttribArray)(GLuint index);

typedef void (*PFN_glClear)(GLbitfield mask);
typedef void (*PFN_glClearColor)(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
typedef void (*PFN_glClearStencil)(GLint s);
typedef void (*PFN_glClearDepth)(GLclampd depth);

typedef void (*PFN_glDepthFunc)(GLenum func);

typedef void (*PFN_glBlendEquation)(GLenum mode);
typedef void (*PFN_glBlendFuncSeparate)(GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);

typedef void (*PFN_glDrawArrays)(GLenum mode, GLint first, GLsizei count);
typedef void (*PFN_glDrawElements)(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);

typedef void (*PFN_glDrawArraysInstanced)(GLenum mode, GLint first, GLsizei count, GLsizei instancecount);
typedef void (*PFN_glDrawElementsInstanced)(GLenum mode, GLsizei count, GLenum type, const GLvoid *indices, GLsizei instancecount);

