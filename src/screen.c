#include "../lib/litelibs/litegfx.h"
#include "../lib/litelibs/litemath3d.h"
#include "../lib/stb/stretchy_buffer.h"
#include "color.h"
#include "default_font.h"
#include "font.h"
#include "platform.h"
#include "screen.h"
#include "texture.h"
#include "util.h"
#include <string.h>

typedef struct {
    char name[STRING_SIZE];
    float height;
    struct Font* font;
} LoadedFont;

static void* _screen_ptr = NULL;
static float _screen_delta = 0;
static float _screen_lasttime = 0;
static int _screen_fps = 0;
static int _screen_fpscounter = 0;
static float _screen_fpstime = 0;
static LoadedFont* _screen_loadedfonts = NULL;
static struct Font* _screen_font = NULL;
#ifdef USE_DEFAULT_FONT
static struct Font* _default_font = NULL;
#endif

EXPORT void CALL OpenScreen(int width, int height, bool_t fullscreen, bool_t resizable) {
    /* Close previous screen */
    CloseScreen();

    /* open screen */
    _screen_ptr = p_OpenScreen(width, height, fullscreen, 0, TRUE, resizable);

    /* load default font */
#ifdef USE_DEFAULT_FONT
    _default_font = LoadFontBase64(DEFAULT_FONT, DEFAULT_FONT_BLOCKSIZE, 12);
    _screen_font = _default_font;
#endif
}

EXPORT void CALL CloseScreen() {
    int i;

    /* Unload fonts */
    for (i = 0; i < sb_count(_screen_loadedfonts); ++i) {
        FreeFont(_screen_loadedfonts[i].font);
    }
    sb_free(_screen_loadedfonts);
    _screen_font = NULL;
    
    /* Unload default font */
#ifdef USE_DEFAULT_FONT
    if (_default_font) FreeFont(_default_font);
    _default_font = NULL;
#endif

    /* Close screen if opened */
    if (_screen_ptr) p_CloseScreen(_screen_ptr);
    _screen_ptr = NULL;
}

EXPORT void CALL RefreshScreen() {
    /* Refresh screen */
    p_RefreshScreen(_screen_ptr);

    /* Update delta time */
    _screen_delta = p_GetTime() - _screen_lasttime;
    _screen_lasttime = p_GetTime();

    /* Update FPS */
    ++_screen_fpscounter;
    _screen_fpstime += _screen_delta;
    if (_screen_fpstime >= 1) {
        _screen_fps = _screen_fpscounter;
        _screen_fpscounter = 0;
        _screen_fpstime -= 1;
    }
}

EXPORT void CALL SetScreenTitle(const char* title) { p_SetScreenTitle(_screen_ptr, title); }

EXPORT int CALL GetScreenWidth() { return p_GetScreenWidth(_screen_ptr); }

EXPORT int CALL GetScreenHeight() { return p_GetScreenHeight(_screen_ptr); }

EXPORT int CALL GetScreenFPS() { return _screen_fps; }

EXPORT bool_t CALL IsScreenOpened() { return p_IsScreenOpened(_screen_ptr); }

EXPORT int CALL GetDesktopWidth() { return p_GetDesktopWidth(); }

EXPORT int CALL GetDesktopHeight() { return p_GetDesktopHeight(); }

EXPORT void CALL Setup2D() {
    lgfx_setup2d(GetScreenWidth(), GetScreenHeight());
}

EXPORT void CALL SetViewport(int x, int y, int w, int h) {
    lgfx_setviewport(x, y, w, h);
}

EXPORT void CALL SetResolution(int w, int h) {
    lgfx_setresolution(w, h);
}

EXPORT void CALL SetColor(int color) {
    lgfx_setcolor(
        Red(color) / 255.0f,
        Green(color) / 255.0f,
        Blue(color) / 255.0f,
        Alpha(color) / 255.0f);
}

EXPORT void CALL SetFont(const char* filename, float height) {
    struct Font* font = NULL;
    int i;

    /* Search for already loaded font */
    for (i = 0; i < sb_count(_screen_loadedfonts); ++i) {
        if (strcmp(_screen_loadedfonts[i].name, filename) == 0
                && _screen_loadedfonts[i].height == height) {
            _screen_font = _screen_loadedfonts[i].font;
            return;
        }
    }

    /* Load font */
    font = LoadFont(filename, height);
    if (font) {
        LoadedFont data;

        strncpy(data.name, filename, STRING_SIZE);
        data.name[STRING_SIZE-1] = 0;
        data.height = height;
        data.font = font;
        sb_push(_screen_loadedfonts, data);
        _screen_font = font;
    }
}

EXPORT void CALL SetDefaultFont() {
#ifdef USE_DEFAULT_FONT
    _screen_font = _default_font;
#endif
}

EXPORT void CALL ClearScreen(int color) {
    lgfx_clearcolorbuffer(
        Red(color) / 255.0f,
        Green(color) / 255.0f,
        Blue(color) / 255.0f
    );
}

EXPORT void CALL DrawPoint(float x, float y) {
    lgfx_drawpoint(x, y);
}

EXPORT void CALL DrawLine(float x1, float y1, float x2, float y2) {
    lgfx_drawline(x1, y1, x2, y2);
}

EXPORT void CALL DrawEllipse(float x, float y, float width, float height) {
    lgfx_drawoval(x, y, width, height);
}

EXPORT void CALL DrawRect(float x, float y, float width, float height) {
    lgfx_drawrect(x, y, width, height);
}

EXPORT void CALL DrawTexture(const struct Texture* tex, float x, float y, float width, float height) {
    const ltex_t* ltex = (const ltex_t*)_GetTexturePtr(tex);
    ltex_bindcolor(ltex);
    lgfx_drawrect(x, y, width != 0 ? width : ltex->width, height != 0 ? height : ltex->height);
}

EXPORT void CALL DrawText(const char* text, float x, float y) {
    DrawTextWithFont(_screen_font, text, x, y);
}

EXPORT float CALL GetTextWidth(const char* text) {
    return GetFontTextWidth(_screen_font, text);
}

EXPORT float CALL GetTextHeight(const char* text) {
    return GetFontTextHeight(_screen_font, text);
}

EXPORT float CALL GetDeltaTime() {
    return _screen_delta;
}

void* _GetScreenPointer() {
    return _screen_ptr;
}
