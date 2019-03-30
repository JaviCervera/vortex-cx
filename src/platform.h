#ifndef PLATFORM_H_INCLUDED
#define PLATFORM_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

bool_t p_Init();
void p_Shutdown();

float p_GetTime();

void p_SetCursorVisible(void* win, bool_t visible);
void p_SetCursorPosition(void* win, int x, int y);
int p_GetCursorX(void* win);
int p_GetCursorY(void* win);

bool_t p_IsMouseButtonDown(void* win, int button);
bool_t p_IsKeyDown(void* win, int key);

int p_GetDesktopWidth();
int p_GetDesktopHeight();

void* p_OpenScreen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable);
void p_CloseScreen(void* win);
bool_t p_IsScreenOpened(void* win);
void p_RefreshScreen(void* win);
void p_SetScreenTitle(void* win, const char* title);
int p_GetScreenWidth(void* win);
int p_GetScreenHeight(void* win);

void p_MessageBox(const char* title, const char* message);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* PLATFORM_H_INCLUDED */
