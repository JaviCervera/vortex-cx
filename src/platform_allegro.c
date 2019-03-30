#include "../lib/allegro/include/allegro5/allegro.h"
#include "../lib/allegro/addons/native_dialog/allegro5/allegro_native_dialog.h"
#include "../lib/allegro/addons/audio/allegro5/allegro_audio.h"
#include "input.h"
#include "platform.h"
#include "util.h"
#include <math.h>

struct data_t
{
  ALLEGRO_DISPLAY* display;
  ALLEGRO_EVENT_QUEUE* queue;
  bool_t opened;
  bool_t keys[ALLEGRO_KEY_MAX];
  bool_t buttons[3];
  int mouse_x, mouse_y;
};

bool_t p_init()
{
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

void p_shutdown()
{
}

float p_get_time()
{
  return (float)al_get_time();
}

void p_set_cursor_visible(void* win, bool_t visible)
{
  if (visible)
  {
    al_show_mouse_cursor(((struct data_t*)win)->display);
  }
  else
  {
    al_hide_mouse_cursor(((struct data_t*)win)->display);
  }
}

void p_set_cursor_position(void* win, int x, int y)
{
  al_set_mouse_xy(((struct data_t*)win)->display, x, y);
}

int p_cursor_x(void* win)
{
  return ((struct data_t*)win)->mouse_x;
}

int p_cursor_y(void* win)
{
  return ((struct data_t*)win)->mouse_y;
}

bool_t p_mouse_button_down(void* win, int button)
{
  return ((struct data_t*)win)->buttons[button];
}

bool_t p_key_down(void* win, int key)
{
  return ((struct data_t*)win)->keys[key];
}

int p_desktop_width()
{
  ALLEGRO_MONITOR_INFO info;
  al_get_monitor_info(0, &info);
  return info.x2 - info.x1;
}

int p_desktop_height()
{
  ALLEGRO_MONITOR_INFO info;
  al_get_monitor_info(0, &info);
  return info.y2 - info.y1;
}

void* p_open_screen(int width, int height, bool_t fullscreen, int samples, bool_t vsync, bool_t resizable)
{
  int flags;
  struct data_t* data;
  ALLEGRO_DISPLAY* display;
  ALLEGRO_EVENT_QUEUE* queue;

  /* set flags */
  flags = ALLEGRO_OPENGL;
  flags |= fullscreen ? ALLEGRO_FULLSCREEN : ALLEGRO_WINDOWED;
  if (resizable) flags |= ALLEGRO_RESIZABLE;
  al_set_new_display_flags(flags);
  al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, samples > 0, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_SAMPLES, samples, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_VSYNC, vsync ? 1 : 2, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_DEPTH_SIZE, 16, ALLEGRO_REQUIRE);

  /* create event queue */
  queue = al_create_event_queue();
  if (!queue) return NULL;

  /* create display */
  display = al_create_display(width, height);
  if (!display)
  {
    al_destroy_event_queue(queue);
    return NULL;
  }
  al_register_event_source(queue, al_get_display_event_source(display));
  al_register_event_source(queue, al_get_keyboard_event_source());
  al_register_event_source(queue, al_get_mouse_event_source());
  al_register_event_source(queue, al_get_joystick_event_source());

  /* create data */
  data = _alloc(struct data_t);
  memset(data, 0, sizeof(struct data_t));
  data->display = display;
  data->queue = queue;
  data->opened = TRUE;
  al_set_window_title(display, "Micron");

  return data;
}

void p_close_screen(void* win)
{
  al_destroy_event_queue(((struct data_t*)win)->queue);
  al_destroy_display(((struct data_t*)win)->display);
  free(win);
}

bool_t p_screen_opened(void* win)
{
  return win && ((struct data_t*)win)->opened;
}

void p_refresh_screen(void* win)
{
  ALLEGRO_EVENT event;
  while (al_get_next_event(((struct data_t*)win)->queue, &event))
  {
    switch (event.type)
    {
      case ALLEGRO_EVENT_DISPLAY_CLOSE:
        ((struct data_t*)win)->opened = FALSE;
        break;
      case ALLEGRO_EVENT_DISPLAY_RESIZE:
        al_acknowledge_resize(((struct data_t*)win)->display);
        break;
      case ALLEGRO_EVENT_KEY_DOWN:
        ((struct data_t*)win)->keys[event.keyboard.keycode] = TRUE;
        break;
      case ALLEGRO_EVENT_KEY_UP:
        ((struct data_t*)win)->keys[event.keyboard.keycode] = FALSE;
        break;
      case ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:
        if (event.mouse.button < 3) ((struct data_t*)win)->buttons[event.mouse.button] = TRUE;
        break;
      case ALLEGRO_EVENT_MOUSE_BUTTON_UP:
        if (event.mouse.button < 3) ((struct data_t*)win)->buttons[event.mouse.button] = FALSE;
        break;
      case ALLEGRO_EVENT_MOUSE_AXES:
      case ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY:
        ((struct data_t*)win)->mouse_x = event.mouse.x;
        ((struct data_t*)win)->mouse_y = event.mouse.y;
    }
  }
  al_flip_display();
}

void p_set_screen_title(void* win, const char* title)
{
  al_set_window_title(((struct data_t*)win)->display, title);
}

int p_screen_width(void* win)
{
  return al_get_display_width(((struct data_t*)win)->display);
}

int p_screen_height(void* win)
{
  return al_get_display_height(((struct data_t*)win)->display);
}

void p_messagebox(const char* title, const char* message)
{
  al_show_native_message_box(al_get_current_display(), title, "", message, NULL, 0);
}
