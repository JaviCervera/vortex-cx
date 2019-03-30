#ifndef PLATFORM_H_INCLUDED
#define PLATFORM_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C"
{
#endif

bool_t p_init();
void p_shutdown();

float p_get_time();

void p_set_cursor_visible(void* win, bool_t visible);
void p_set_cursor_position(void* win, int x, int y);
int p_cursor_x(void* win);
int p_cursor_y(void* win);

bool_t p_mouse_button_down(void* win, int button);
bool_t p_key_down(void* win, int key);

int p_desktop_width();
int p_desktop_height();

void* p_open_screen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable);
void p_close_screen(void* win);
bool_t p_screen_opened(void* win);
void p_refresh_screen(void* win);
void p_set_screen_title(void* win, const char* title);
int p_screen_width(void* win);
int p_screen_height(void* win);

void p_messagebox(const char* title, const char* message);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* PLATFORM_H_INCLUDED */
