#ifndef PIXMAP_H_INCLUDED
#define PIXMAP_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

struct Pixmap;

EXPORT struct Pixmap* CALL CreatePixmap(int width, int height);
EXPORT struct Pixmap* CALL CreatePixmapFromPixels(const int* pixels, size_t num_pixels);
EXPORT struct Pixmap* CALL LoadPixmap(const char* filename);
EXPORT void CALL FreePixmap(struct Pixmap* pixmap);
EXPORT int CALL GetPixmapWidth(const struct Pixmap* pixmap);
EXPORT int CALL GetPixmapHeight(const struct Pixmap* pixmap);
EXPORT int CALL GetPixmapColor(const struct Pixmap* pixmap, int x, int y);
EXPORT void CALL SetPixmapColor(struct Pixmap* pixmap, int x, int y, int color);

#ifndef SWIG
const void* _GetPixmapPtr(const struct Pixmap* pixmap);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* PIXMAP_H_INCLUDED */
