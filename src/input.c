#include "input.h"
#include "platform.h"
#include "screen.h"

EXPORT void CALL SetMouseVisible(bool_t visible) {
    p_SetCursorVisible(_GetScreenPointer(), visible);
}

EXPORT void CALL SetMousePosition(int x, int y) {
    p_SetCursorPosition(_GetScreenPointer(), x, y);
}

EXPORT int CALL GetMouseX() {
    return p_GetCursorX(_GetScreenPointer());
}

EXPORT int CALL GetMouseY() {
    return p_GetCursorY(_GetScreenPointer());
}

EXPORT bool_t CALL IsMouseDown(int b) {
    return p_IsMouseButtonDown(_GetScreenPointer(), b);
}

EXPORT bool_t CALL IsKeyDown(int k) {
    return p_IsKeyDown(_GetScreenPointer(), k);
}
