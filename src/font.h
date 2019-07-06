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

void DrawTextWithFont(const struct Font* font, const char* text, float x, float y);
float GetFontTextWidth(const struct Font* font, const char* text);
float GetFontTextHeight(const struct Font* font, const char* text);

#ifndef SWIG
struct Font* _LoadFontBase64(const char* data, size_t size, float height);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* FONT_H_INCLUDED */
