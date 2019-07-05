#ifndef SCREEN_H_INCLUDED
#define SCREEN_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

struct Texture;

// Screen
EXPORT bool_t CALL OpenScreen(int width, int height, bool_t fullscreen, bool_t resizable);
EXPORT void CALL CloseScreen();
EXPORT void CALL RefreshScreen();
EXPORT void CALL SetScreenTitle(const char* title);
EXPORT int CALL GetScreenWidth();
EXPORT int CALL GetScreenHeight();
EXPORT int CALL GetScreenFPS();
EXPORT bool_t CALL IsScreenOpened();

// Desktop
EXPORT int CALL GetDesktopWidth();
EXPORT int CALL GetDesktopHeight();

// Drawing
EXPORT void CALL Setup2D();
EXPORT void CALL SetViewport(int x, int y, int w, int h);
EXPORT void CALL SetResolution(int w, int h);
EXPORT void CALL SetColor(int color);
EXPORT void CALL SetFont(const char* filename, float height);
EXPORT void CALL SetDefaultFont();
EXPORT void CALL ClearScreen(int color);
EXPORT void CALL DrawPoint(float x, float y);
EXPORT void CALL DrawLine(float x1, float y1, float x2, float y2);
EXPORT void CALL DrawEllipse(float x, float y, float width, float height);
EXPORT void CALL DrawRect(float x, float y, float width, float height);
EXPORT void CALL DrawTexture(const struct Texture* tex, float x, float y);
EXPORT void CALL DrawTextureRot(const struct Texture* tex, float x, float y, float angle);
EXPORT void CALL DrawTextureSized(const struct Texture* tex, float x, float y, float width, float height);
EXPORT void CALL DrawTextureSizedRot(const struct Texture* tex, float x, float y, float width, float height, float angle);
EXPORT void CALL DrawText(const char* text, float x, float y);
EXPORT float CALL GetTextWidth(const char* text);
EXPORT float CALL GetTextHeight(const char* text);

// Misc
EXPORT float CALL GetDeltaTime();

#ifndef SWIG
void* _GetScreenPointer();
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* SCREEN_H_INCLUDED */
