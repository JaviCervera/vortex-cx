#ifndef FONT_H_INCLUDED
#define FONT_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

struct Font;

struct Font* LoadFont(const char* filename, float height);
struct Font* LoadFontFromMemory(const char* filename, const void* mem, float height);
void FreeFont(struct Font* font);
float GetFontHeight(const struct Font* font);
float GetTextWidth(const struct Font* font, const char* text);
float GetTextHeight(const struct Font* font, const char* text);

#ifndef SWIG
void _LoadDefaultFont();
void _FreeDefaultFont();
void _DrawText(const struct Font* font, const char* text, float x, float y);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* FONT_H_INCLUDED */
