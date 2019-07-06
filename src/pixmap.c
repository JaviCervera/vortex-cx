#include "../lib/stb/stb_image.h"
#include "file_system.h"
#include "pixmap.h"
#include "util.h"

struct Pixmap {
    int* pixels;
    int width;
    int height;
};

EXPORT struct Pixmap* CALL CreatePixmap(int width, int height) {
    struct Pixmap* pixmap = Alloc(struct Pixmap);
    pixmap->pixels = AllocNum(int, width * height);
    pixmap->width = width;
    pixmap->height = height;
    return pixmap;
}

EXPORT struct Pixmap* CALL LoadPixmap(const char* filename) {
    long len;
    unsigned char* buffer;
    struct Pixmap* pixmap;

    /* Read file */
    len = GetFileSize(filename);
    if (len == 0) return NULL;
    buffer = AllocNum(unsigned char, len);
    GetFileContents(filename, buffer);

    /* Load pixmap */
    pixmap = LoadPixmapFromMemory(buffer, len);
    free(buffer);

    return pixmap;
}

EXPORT struct Pixmap* CALL LoadPixmapFromMemory(const void* mem, size_t size) {
    unsigned char* buffer;
    int w, h;
    struct Pixmap* pixmap;

    /* Load buffer */
    buffer = stbi_load_from_memory((const unsigned char*)mem, size, &w, &h, NULL, 4);
    if (!buffer) return NULL;

    /* Create pixmap */
    pixmap = Alloc(struct Pixmap);
    pixmap->pixels = (int*)buffer;
    pixmap->width = w;
    pixmap->height = h;

    return pixmap;
}

EXPORT void CALL FreePixmap(struct Pixmap* pixmap) {
    free(pixmap->pixels);
    free(pixmap);
}

EXPORT int CALL GetPixmapWidth(const struct Pixmap* pixmap) { return pixmap->width; }

EXPORT int CALL GetPixmapHeight(const struct Pixmap* pixmap) { return pixmap->height; }

EXPORT int CALL GetPixmapColor(const struct Pixmap* pixmap, int x, int y) {
    return pixmap->pixels[y*pixmap->width + x];
}

EXPORT void CALL SetPixmapColor(struct Pixmap* pixmap, int x, int y, int color) {
    pixmap->pixels[y*pixmap->width + x] = color;
}

const void* _GetPixmapPtr(const struct Pixmap* pixmap) { return pixmap->pixels; }
