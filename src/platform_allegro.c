#include "vortex_config.h"

#ifdef USE_ALLEGRO

#include "../lib/allegro/include/allegro5/allegro.h"
#include "../lib/allegro/addons/native_dialog/allegro5/allegro_native_dialog.h"
#include "../lib/allegro/addons/audio/allegro5/allegro_audio.h"
#include "platform.h"
#include "util.h"
#include <math.h>

typedef struct {
    ALLEGRO_DISPLAY* display;
    ALLEGRO_EVENT_QUEUE* queue;
    bool_t opened;
    bool_t keys[ALLEGRO_KEY_MAX];
    bool_t buttons[3];
    int mouse_x, mouse_y;
} AllegroData;

bool_t p_Init() {
    bool_t ret;
    ret = al_init();
    if (!ret) return FALSE;
    ret = al_install_keyboard();
    if (!ret) return FALSE;
    ret = al_install_mouse();
    if (!ret) return FALSE;
    ret = al_install_joystick();
    if (!ret) return FALSE;
    ret = al_install_audio();
    if (!ret) return FALSE;
    return ret != FALSE;
}

void p_Shutdown() {}

float p_GetTime() {
    return (float)al_get_time();
}

void p_SetCursorVisible(void* win, bool_t visible) {
    if (visible) {
        al_show_mouse_cursor(((AllegroData*)win)->display);
    } else {
        al_hide_mouse_cursor(((AllegroData*)win)->display);
    }
}

void p_SetCursorPosition(void* win, int x, int y) {
    al_set_mouse_xy(((AllegroData*)win)->display, x, y);
}

int p_GetCursorX(void* win) {
    return ((AllegroData*)win)->mouse_x;
}

int p_GetCursorY(void* win) {
    return ((AllegroData*)win)->mouse_y;
}

bool_t p_IsMouseButtonDown(void* win, int button) {
    return ((AllegroData*)win)->buttons[button];
}

bool_t p_IsKeyDown(void* win, int key) {
    return ((AllegroData*)win)->keys[key];
}

int p_GetDesktopWidth() {
    ALLEGRO_MONITOR_INFO info;
    al_get_monitor_info(0, &info);
    return info.x2 - info.x1;
}

int p_GetDesktopHeight() {
    ALLEGRO_MONITOR_INFO info;
    al_get_monitor_info(0, &info);
    return info.y2 - info.y1;
}

void* p_OpenScreen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable) {
    int flags;
    AllegroData* data;
    ALLEGRO_DISPLAY* display;
    ALLEGRO_EVENT_QUEUE* queue;

    /* Set flags */
    flags = ALLEGRO_OPENGL;
    flags |= fullscreen ? ALLEGRO_FULLSCREEN : ALLEGRO_WINDOWED;
    if (resizable) flags |= ALLEGRO_RESIZABLE;
    al_set_new_display_flags(flags);
    al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, samples > 0, ALLEGRO_SUGGEST);
    al_set_new_display_option(ALLEGRO_SAMPLES, samples, ALLEGRO_SUGGEST);
    al_set_new_display_option(ALLEGRO_VSYNC, vsync ? 1 : 2, ALLEGRO_SUGGEST);
    al_set_new_display_option(ALLEGRO_DEPTH_SIZE, 16, ALLEGRO_SUGGEST);
    al_set_new_display_option(ALLEGRO_FLOAT_DEPTH, 1, ALLEGRO_SUGGEST);

    /* Create event queue */
    queue = al_create_event_queue();
    if (!queue) return NULL;

    /* Create display */
    display = al_create_display(width, height);
    if (!display) {
        al_destroy_event_queue(queue);
        return NULL;
    }
    al_register_event_source(queue, al_get_display_event_source(display));
    al_register_event_source(queue, al_get_keyboard_event_source());
    al_register_event_source(queue, al_get_mouse_event_source());
    al_register_event_source(queue, al_get_joystick_event_source());

    /* Create data */
    data = Alloc(AllegroData);
    memset(data, 0, sizeof(AllegroData));
    data->display = display;
    data->queue = queue;
    data->opened = TRUE;
    al_set_window_title(display, "Micron");

    return data;
}

void p_CloseScreen(void* win) {
    al_destroy_event_queue(((AllegroData*)win)->queue);
    al_destroy_display(((AllegroData*)win)->display);
    free(win);
}

bool_t p_IsScreenOpened(void* win) {
    return win && ((AllegroData*)win)->opened;
}

void p_RefreshScreen(void* win) {
    ALLEGRO_EVENT event;
    while (al_get_next_event(((AllegroData*)win)->queue, &event)) {
        switch (event.type) {
            case ALLEGRO_EVENT_DISPLAY_CLOSE:
                ((AllegroData*)win)->opened = FALSE;
                break;
            case ALLEGRO_EVENT_DISPLAY_RESIZE:
                al_acknowledge_resize(((AllegroData*)win)->display);
                break;
            case ALLEGRO_EVENT_KEY_DOWN:
                ((AllegroData*)win)->keys[event.keyboard.keycode] = TRUE;
                break;
            case ALLEGRO_EVENT_KEY_UP:
                ((AllegroData*)win)->keys[event.keyboard.keycode] = FALSE;
                break;
            case ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:
                if (event.mouse.button < 3) ((AllegroData*)win)->buttons[event.mouse.button] = TRUE;
                break;
            case ALLEGRO_EVENT_MOUSE_BUTTON_UP:
                if (event.mouse.button < 3) ((AllegroData*)win)->buttons[event.mouse.button] = FALSE;
                break;
            case ALLEGRO_EVENT_MOUSE_AXES:
            case ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY:
                ((AllegroData*)win)->mouse_x = event.mouse.x;
                ((AllegroData*)win)->mouse_y = event.mouse.y;
        }
    }
    al_flip_display();
}

void p_SetScreenTitle(void* win, const char* title) {
    al_set_window_title(((AllegroData*)win)->display, title);
}

int p_GetScreenWidth(void* win) {
    return al_get_display_width(((AllegroData*)win)->display);
}

int p_GetScreenHeight(void* win) {
    return al_get_display_height(((AllegroData*)win)->display);
}

void p_MessageBox(const char* title, const char* message) {
    al_show_native_message_box(al_get_current_display(), title, "", message, NULL, 0);
}

#endif /* USE_ALLEGRO */
