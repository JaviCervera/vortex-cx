#ifndef FONT_H_INCLUDED
#define FONT_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef SWIG

struct Font;

struct Font* CreateFont(const unsigned char* data, float height);
struct Font* LoadFont(const char* filename, float height);
struct Font* LoadFontBase64(const char* data, size_t size, float height);
void FreeFont(struct Font* font);
float GetFontHeight(const struct Font* font);

void DrawTextWithFont(const struct Font* font, const char* text, float x, float y);
float GetFontTextWidth(const struct Font* font, const char* text);
float GetFontTextHeight(const struct Font* font, const char* text);

#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* FONT_H_INCLUDED */
