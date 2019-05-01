#ifndef INPUT_H_INCLUDED
#define INPUT_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* this is defined on macos, so undefine it */
#ifdef KEY_T
#undef KEY_T
#endif

#define MOUSE_LEFT 1
#define MOUSE_RIGHT 2
#define MOUSE_MIDDLE 3

/* These files won't define anything unless the proper macro is defined */
#include "input_allegro.h"
#include "input_glfw.h"
#include "input_sdl.h"

EXPORT void CALL SetMouseVisible(bool_t visible);
EXPORT void CALL SetMousePosition(int x, int y);
EXPORT int CALL GetMouseX();
EXPORT int CALL GetMouseY();
EXPORT bool_t CALL IsMouseDown(int b);
EXPORT bool_t CALL IsKeyDown(int k);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* INPUT_H_INCLUDED */
