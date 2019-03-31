#ifndef VORTEX_H_INCLUDED
#define VORTEX_H_INCLUDED

#include "color.h"
#include "input.h"
#include "pixmap.h"
#include "screen.h"
#include "texture.h"

#ifdef __cplusplus
extern "C" {
#endif

EXPORT bool_t CALL InitVortex();
EXPORT void CALL FinishVortex();

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* VORTEX_H_INCLUDED */
