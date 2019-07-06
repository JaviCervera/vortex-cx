#include "vortex_config.h"
#ifdef USE_DEFAULT_FONT
#include "../lib/base64/base64.h"
#endif
#include "../lib/litelibs/litegfx.h"
#include "../lib/stb/stb_truetype.h"
#include "font.h"
#include "resource.h"
#include "util.h"
#include <stdio.h>
#include <string.h>

struct Font {
    Resource resource;
    char filename[STRING_SIZE];
    ltex_t* tex;
    stbtt_bakedchar glyphs[94];
    float height;
    float maxheight;
};

static void FontDeleter(struct Font* font) {
    ltex_free(font->tex);
    free(font);
}

struct Font* LoadFont(const char* filename, float height) {
    FILE* f;
    long len;
    unsigned char* buffer;
    struct Font* font;

    /* Read file */
    f = fopen(filename, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    len = ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = AllocNum(unsigned char, len);
    fread(buffer, sizeof(char), len, f);
    fclose(f);

    /* Load data */
    font = LoadFontFromMemory(filename, buffer, height);
    free(buffer);

    return font;
}

struct Font* LoadFontFromMemory(const char* filename, const void* mem, float height) {
    struct Font* font;
    int w, h;
    unsigned char* alphabuffer;
    unsigned char* colorbuffer;
    size_t len, i;
    float x = 0, y = 0;
    float miny = 999999, maxy = -999999;
    stbtt_aligned_quad q;

    /* Create font object */
    font = Alloc(struct Font);
    InitResource(&font->resource, (void(*)(void*))FontDeleter);
    strncpy(font->filename, filename, STRING_SIZE);
    font->filename[STRING_SIZE-1] = 0;
    font->height = height;

    /* Bake font into alpha buffer */
    w = h = 256;
    alphabuffer = AllocNum(unsigned char, w * h);
    while (stbtt_BakeFontBitmap((const unsigned char*)mem, 0, height, alphabuffer, w, h, 32, sizeof(font->glyphs) / sizeof(font->glyphs[0]), font->glyphs) <= 0) {
        if (w == h) w *= 2;
        else h *= 2;
        alphabuffer = (unsigned char*)realloc(alphabuffer, w * h);
    }

    /* Copy into color buffer */
    colorbuffer = AllocNum(unsigned char, w*h*4);
    memset(colorbuffer, 255, w*h*4);
    for (i = 0; i < w*h; ++i) colorbuffer[i*4 + 3] = alphabuffer[i];
    free(alphabuffer);

    /* Create texture */
    font->tex = ltex_alloc(w, h, FALSE);
    ltex_setpixels(font->tex, colorbuffer);
    free(colorbuffer);

    /* Get max char height */
    font->maxheight = -999999;
    len = sizeof(font->glyphs) / sizeof(font->glyphs[0]);
    for (i = 0; i < len; ++i) {
        stbtt_GetBakedQuad(font->glyphs, font->tex->width, font->tex->height, i, &x, &y, &q, TRUE);
        miny = Min(miny, q.y0);
        maxy = Max(maxy, q.y1);
    }
    font->maxheight = maxy - miny;

    return font;
}

void FreeFont(struct Font* font) {
    ReleaseResource(&font->resource);
}

float GetFontHeight(const struct Font* font) { return font->height; }

void DrawTextWithFont(const struct Font* font, const char* text, float x, float y) {
    size_t len, i;

    y += font->maxheight;
    len = strlen(text);
    for (i = 0; i < len; ++i) {
        stbtt_aligned_quad q;
        stbtt_GetBakedQuad(font->glyphs, font->tex->width, font->tex->height, Min(text[i] - 32, 94), &x, &y, &q, TRUE);
        ltex_drawrotsized(font->tex, q.x0, q.y0, 0, 0, 0, q.x1 - q.x0, q.y1 - q.y0, q.s0, q.t0, q.s1, q.t1);
    }
}

float GetFontTextWidth(const struct Font* font, const char* text) {
    float x = 0, y = 0;
    stbtt_aligned_quad q = { 0 };
    size_t len, i;

    len = strlen(text);
    for (i = 0; i < len; ++i) {
        stbtt_GetBakedQuad(font->glyphs, font->tex->width, font->tex->height, Min(text[i] - 32, 94), &x, &y, &q, TRUE);
    }
    return q.x1;
}

float GetFontTextHeight(const struct Font* font, const char* text) {
    float x = 0, y = 0, miny = 999999, maxy = -999999;
    stbtt_aligned_quad q = { 0 };
    size_t len, i;

    len = strlen(text);
    for (i = 0; i < len; ++i) {
        stbtt_GetBakedQuad(font->glyphs, font->tex->width, font->tex->height, Min(text[i] - 32, 94), &x, &y, &q, TRUE);
        miny = Min(miny, q.y0);
        maxy = Max(maxy, q.y1);
    }
    return maxy - miny;
}

struct Font* _LoadFontBase64(const char* data, size_t size, float height) {
#ifdef USE_DEFAULT_FONT
    unsigned char* buffer;
    struct Font* font;

    /* Get data from base64 block */
    buffer = AllocNum(unsigned char, BASE64_DECODE_OUT_SIZE(size));
    base64_decode(data, size, buffer);

    /* Load data */
    font = LoadFontFromMemory("", buffer, height);
    free(buffer);

    return font;
#else
    return NULL;
#endif
}
