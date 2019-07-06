#include "vortex_config.h"
#include "../lib/litelibs/litegfx.h"
#include "../lib/litelibs/litemath3d.h"
#include "color.h"
#include "font.h"
#include "platform.h"
#define VORTEX_NO_BLEND_MODES
#include "screen.h"
#include "texture.h"
#include "util.h"
#include <string.h>

static void* _screen_ptr = NULL;
static float _screen_delta = 0;
static float _screen_lasttime = 0;
static int _screen_fps = 0;
static int _screen_fpscounter = 0;
static float _screen_fpstime = 0;

EXPORT bool_t CALL OpenScreen(int width, int height, bool_t fullscreen, bool_t resizable) {
    /* Close previous screen */
    CloseScreen();

    /* Open screen */
    _screen_ptr = p_OpenScreen(width, height, fullscreen, 0, TRUE, resizable);

    /* Reload default font */
    if (_screen_ptr) {
        _LoadDefaultFont();
    }

    return _screen_ptr != NULL;
}

EXPORT void CALL CloseScreen() {
    /* Unload default font */
    _FreeDefaultFont();

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

EXPORT void CALL SetBlendMode(int mode) {
    lgfx_setblend(mode);
}

EXPORT void CALL SetColor(int color) {
    lgfx_setcolor(
        Red(color) / 255.0f,
        Green(color) / 255.0f,
        Blue(color) / 255.0f,
        Alpha(color) / 255.0f);
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

EXPORT void CALL DrawTexture(const struct Texture* tex, float x, float y) {
    const ltex_t* ltex = (const ltex_t*)_GetTexturePtr(tex);
    ltex_bindcolor(ltex);
    ltex_draw(ltex, x, y);
}

EXPORT void CALL DrawTextureRot(const struct Texture* tex, float x, float y, float angle) {
    const ltex_t* ltex = (const ltex_t*)_GetTexturePtr(tex);
    ltex_bindcolor(ltex);
    ltex_drawrot(ltex, x, y, angle, 0.5f, 0.5f);
}

EXPORT void CALL DrawTextureSized(const struct Texture* tex, float x, float y, float width, float height) {
    const ltex_t* ltex = (const ltex_t*)_GetTexturePtr(tex);
    ltex_bindcolor(ltex);
    ltex_drawrotsized(ltex, x, y, 0, 0, 0, width != 0 ? width : ltex->width, height != 0 ? height : ltex->height, 0, 0, 1, 1);
}

EXPORT void CALL DrawTextureSizedRot(const struct Texture* tex, float x, float y, float width, float height, float angle) {
    const ltex_t* ltex = (const ltex_t*)_GetTexturePtr(tex);
    ltex_bindcolor(ltex);
    ltex_drawrotsized(ltex, x, y, angle, 0.5f, 0.5f, width != 0 ? width : ltex->width, height != 0 ? height : ltex->height, 0, 0, 1, 1);
}

EXPORT void CALL DrawText(const struct Font* font, const char* text, float x, float y) {
    _DrawText(font, text, x, y);
}

EXPORT float CALL GetDeltaTime() {
    return _screen_delta;
}

void* _GetScreenPointer() {
    return _screen_ptr;
}
