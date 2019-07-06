#include "../lib/litelibs/litegfx.h"
#include "pixmap.h"
#include "resource.h"
#include "texture.h"
#include "util.h"

static bool_t _texture_filtering = TRUE;

struct Texture {
    Resource resource;
    ltex_t* ptr;
};

static void TextureDeleter(struct Texture* texture)
{
    ltex_free(texture->ptr);
    free(texture);
}

EXPORT struct Texture* CALL CreateTexture(int width, int height) {
    struct Texture* tex = Alloc(struct Texture);
    InitResource(&tex->resource, (void(*)(void*))TextureDeleter);
    tex->ptr = ltex_alloc(width, height, _texture_filtering);
    return tex;
}

EXPORT struct Texture* CALL CreateTextureFromPixmap(const struct Pixmap* pixmap) {
    struct Texture* tex;
    tex = CreateTexture(GetPixmapWidth(pixmap), GetPixmapHeight(pixmap));
    if (tex) SetTexturePixels(tex, pixmap);
    return tex;
}

EXPORT struct Texture* CALL LoadTexture(const char* filename) {
    struct Pixmap* pixmap;
    struct Texture* tex;

    /* Load pixmap */
    pixmap = LoadPixmap(filename);
    if (!pixmap) return NULL;

    /* Create texture */
    tex = CreateTextureFromPixmap(pixmap);

    /* Delete pixmap */
    FreePixmap(pixmap);

    return tex;
}

EXPORT struct Texture* CALL LoadTextureFromMemory(const void* mem, size_t size) {
    struct Pixmap* pixmap;
    struct Texture* tex;

    /* Load pixmap */
    pixmap = LoadPixmapFromMemory(mem, size);
    if (!pixmap) return NULL;

    /* Create texture */
    tex = CreateTextureFromPixmap(pixmap);

    /* Delete pixmap */
    FreePixmap(pixmap);

    return tex;
}

EXPORT void CALL FreeTexture(struct Texture* texture) {
    ReleaseResource(&texture->resource);
}

EXPORT int CALL GetTextureWidth(const struct Texture* texture) { return texture->ptr->width; }

EXPORT int CALL GetTextureHeight(const struct Texture* texture) { return texture->ptr->height; }

EXPORT void CALL SetTexturePixels(struct Texture* texture, const struct Pixmap* pixmap) {
    if (texture->ptr->width == GetPixmapWidth(pixmap)
            && texture->ptr->height == GetPixmapHeight(pixmap)) {
        ltex_setpixels(texture->ptr, _GetPixmapPtr(pixmap));
    }
}

EXPORT void CALL SetTextureFilter(bool_t filter) { _texture_filtering = filter; }

const void* _GetTexturePtr(const struct Texture* texture) { return texture ? texture->ptr : NULL; }
