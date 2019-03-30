#ifndef INPUT_H_INCLUDED
#define INPUT_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C"
{
#endif

/* this is defined on macos, so undefine it */
#ifdef _KEY_T
#undef _KEY_T
#endif

#define _MOUSE_LEFT 1
#define _MOUSE_RIGHT 2
#define _MOUSE_MIDDLE 3

#define _KEY_A 1
#define _KEY_B 2
#define _KEY_C 3
#define _KEY_D 4
#define _KEY_E 5
#define _KEY_F 6
#define _KEY_G 7
#define _KEY_H 8
#define _KEY_I 9
#define _KEY_J 10
#define _KEY_K 11
#define _KEY_L 12
#define _KEY_M 13
#define _KEY_N 14
#define _KEY_O 15
#define _KEY_P 16
#define _KEY_Q 17
#define _KEY_R 18
#define _KEY_S 19
#define _KEY_T 20
#define _KEY_U 21
#define _KEY_V 22
#define _KEY_W 23
#define _KEY_X 24
#define _KEY_Y 25
#define _KEY_Z 26
#define _KEY_0 27
#define _KEY_1 28
#define _KEY_2 29
#define _KEY_3 30
#define _KEY_4 31
#define _KEY_5 32
#define _KEY_6 33
#define _KEY_7 34
#define _KEY_8 35
#define _KEY_9 36
#define _KEY_PAD_0 37
#define _KEY_PAD_1 38
#define _KEY_PAD_2 39
#define _KEY_PAD_3 40
#define _KEY_PAD_4 41
#define _KEY_PAD_5 42
#define _KEY_PAD_6 43
#define _KEY_PAD_7 44
#define _KEY_PAD_8 45
#define _KEY_PAD_9 46
#define _KEY_F1 47
#define _KEY_F2 48
#define _KEY_F3 49
#define _KEY_F4 50
#define _KEY_F5 51
#define _KEY_F6 52
#define _KEY_F7 53
#define _KEY_F8 54
#define _KEY_F9 55
#define _KEY_F10 56
#define _KEY_F11 57
#define _KEY_F12 58
#define _KEY_ESC 59
#define _KEY_TILDE 60
#define _KEY_MINUS 61
#define _KEY_EQUALS 62
#define _KEY_BACKSPACE 63
#define _KEY_TAB 64
#define _KEY_OPENBRACE 65
#define _KEY_CLOSEBRACE 66
#define _KEY_ENTER 67
#define _KEY_SEMICOLON 68
#define _KEY_QUOTE 69
#define _KEY_BACKSLASH 70
#define _KEY_BACKSLASH2 71
#define _KEY_COMMA 72
#define _KEY_FULLSTOP 73
#define _KEY_SLASH 74
#define _KEY_SPACE 75
#define _KEY_INSERT 76
#define _KEY_DELETE 77
#define _KEY_HOME 78
#define _KEY_END 79
#define _KEY_PGUP 80
#define _KEY_PGDN 81
#define _KEY_LEFT 82
#define _KEY_RIGHT 83
#define _KEY_UP 84
#define _KEY_DOWN 85
#define _KEY_PAD_SLASH 86
#define _KEY_PAD_ASTERISK 87
#define _KEY_PAD_MINUS 88
#define _KEY_PAD_PLUS 89
#define _KEY_PAD_DELETE 90
#define _KEY_PAD_ENTER 91
#define _KEY_PRINTSCREEN 92
#define _KEY_PAUSE 93
#define _KEY_ABNT_C1 94
#define _KEY_YEN 95
#define _KEY_KANA 96
#define _KEY_CONVERT 97
#define _KEY_NOCONVERT 98
#define _KEY_AT 99
#define _KEY_CIRCUMFLEX 100
#define _KEY_COLON2 101
#define _KEY_KANJI 102
#define _KEY_PAD_EQUALS 103
#define _KEY_BACKQUOTE 104
#define _KEY_SEMICOLON2 105
#define _KEY_COMMAND 106
#define _KEY_BACK 107
#define _KEY_VOLUME_UP 108
#define _KEY_VOLUME_DOWN 109
#define _KEY_SEARCH 110
#define _KEY_DPAD_CENTER 111
#define _KEY_BUTTON_X 112
#define _KEY_BUTTON_Y 113
#define _KEY_DPAD_UP 114
#define _KEY_DPAD_DOWN 115
#define _KEY_DPAD_LEFT 116
#define _KEY_DPAD_RIGHT 117
#define _KEY_SELECT 118
#define _KEY_START 119
#define _KEY_BUTTON_L1 120
#define _KEY_BUTTON_R1 121
#define _KEY_BUTTON_L2 122
#define _KEY_BUTTON_R2 123
#define _KEY_BUTTON_A 124
#define _KEY_BUTTON_B 125
#define _KEY_THUMBL 126
#define _KEY_THUMBR 127
#define _KEY_UNKNOWN 128
#define _KEY_MODIFIERS 215
#define _KEY_LSHIFT 215
#define _KEY_RSHIFT 216
#define _KEY_LCTRL 217
#define _KEY_RCTRL 218
#define _KEY_ALT 219
#define _KEY_ALTGR 220
#define _KEY_LWIN 221
#define _KEY_RWIN 222
#define _KEY_MENU 223
#define _KEY_SCROLLLOCK 224
#define _KEY_NUMLOCK 225
#define _KEY_CAPSLOCK 226

void input_setmousevisible(bool_t visible);
void input_setmouseposition(int x, int y);
int input_mousex();
int input_mousey();
bool_t input_mousedown(int b);
bool_t input_keydown(int k);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* INPUT_H_INCLUDED */
