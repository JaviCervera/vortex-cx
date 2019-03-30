#ifndef TEXTURE_H_INCLUDED
#define TEXTURE_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

struct Pixmap;
struct Texture;

EXPORT struct Texture* CALL CreateTexture(int width, int height);
EXPORT struct Texture* CALL CreateTextureFromPixmap(const struct Pixmap* pixmap);
EXPORT struct Texture* CALL LoadTexture(const char* filename);
EXPORT void CALL FreeTexture(struct Texture* texture);
EXPORT int CALL GetTextureWidth(const struct Texture* texture);
EXPORT int CALL GetTextureHeight(const struct Texture* texture);
EXPORT void CALL SetTexturePixels(struct Texture* texture, const struct Pixmap* pixmap);
EXPORT void CALL SetTextureFilter(bool_t filter);

#ifndef SWIG
const void* _GetTexturePtr(const struct Texture* texture);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* TEXTURE_H_INCLUDED */
