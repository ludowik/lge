    #include <ft2build.h>
    #include <freetype/freetype.h>

    #ifndef min
    #define min(a,b) (((a) < (b)) ? (a) : (b))
    #define max(a,b) (((a) > (b)) ? (a) : (b))
    #endif

    FT_Error error;

    typedef unsigned char GLubyte;

    FT_Library init_module() {
        FT_Library library;
        error = FT_Init_FreeType(&library);
        if (error)
            return NULL;
        return (FT_Library)library;
    }

    void release_module(FT_Library library) {
        FT_Done_FreeType(library);
    }

    FT_Face load_font(FT_Library library, const char* font_name, int font_size) {
        FT_Face face;
        error = FT_New_Face(library, font_name, 0 , &face);
        if (error)
            return NULL;
        FT_Set_Char_Size(
          face,             /* handle to face object           */
          0,                /* char_width in 1/64th of points  */
          font_size * 64,   /* char_height in 1/64th of points */
          300,              /* horizontal device resolution    */
          300 );            /* vertical device resolution      */
        return (FT_Face)face;
    }

    void release_font(FT_Face face) {
        FT_Done_Face(face);
    }

    typedef struct {
        int w;
        int h;
        int size;
        GLubyte* pixels;
        struct {
            int BytesPerPixel;
            unsigned int Rmask;
        } format;
    } Glyph;

    #define bitmap_left ((int)slot->bitmap_left)
    #define bitmap_top  ((int)slot->bitmap_top)

    #define bitmap_width ((int)slot->bitmap.width)
    #define bitmap_rows  ((int)slot->bitmap.rows)

    #define bitmap_buffer slot->bitmap.buffer

    Glyph load_text(FT_Face face, const char* text) {
        Glyph glyph = {0, 0, 0, NULL};
        if (face == NULL || text == NULL)
            return glyph;

        FT_GlyphSlot slot = face->glyph;

        int x=0, w=0, h=0, top=0, bottom=0;
        int space_width = 5;

        size_t len = strlen(text);
        for ( size_t n = 0; n < len; ++n ) {
            error = FT_Load_Char(face, text[n], FT_LOAD_RENDER);
            if (error)
                continue;

            if (text[n] == ' ')
                w = w + space_width + bitmap_left;
            else
                w = w + bitmap_width + bitmap_left;

            top = max(top, bitmap_top);
            bottom = max(bottom, bitmap_rows - bitmap_top);
        }

        top *= 1.25;
        h = top + bottom;

        int size = w * h * sizeof(GLubyte);
        GLubyte* pixels = malloc(size);
        memset(pixels, 0, size);

        for ( size_t n = 0; n < len; ++n ) {
            error = FT_Load_Char(face, text[n], FT_LOAD_RENDER);
            if (error)
                continue;

            int index_bitmap = 0;
            for ( int j = 0; j < bitmap_rows; ++j ) {
                int index = (j + top - bitmap_top) * w + x + bitmap_left;
                memcpy(&pixels[index], &bitmap_buffer[index_bitmap], bitmap_width);
                index_bitmap += bitmap_width;
            }

            if (text[n] == ' ')
                x = x + space_width + bitmap_left;
            else
                x = x + bitmap_width + bitmap_left;
        }

        glyph.w = w;
        glyph.h = h;
        glyph.size = size;
        glyph.pixels = pixels;

        glyph.format.BytesPerPixel = 1;
        glyph.format.Rmask = 0xff;

        return glyph;
    }

    void release_text(Glyph glyph) {
        if (glyph.pixels)
            free(glyph.pixels);
    }
