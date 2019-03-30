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

#define KEY_A 1
#define KEY_B 2
#define KEY_C 3
#define KEY_D 4
#define KEY_E 5
#define KEY_F 6
#define KEY_G 7
#define KEY_H 8
#define KEY_I 9
#define KEY_J 10
#define KEY_K 11
#define KEY_L 12
#define KEY_M 13
#define KEY_N 14
#define KEY_O 15
#define KEY_P 16
#define KEY_Q 17
#define KEY_R 18
#define KEY_S 19
#define KEY_T 20
#define KEY_U 21
#define KEY_V 22
#define KEY_W 23
#define KEY_X 24
#define KEY_Y 25
#define KEY_Z 26
#define KEY_0 27
#define KEY_1 28
#define KEY_2 29
#define KEY_3 30
#define KEY_4 31
#define KEY_5 32
#define KEY_6 33
#define KEY_7 34
#define KEY_8 35
#define KEY_9 36
#define KEY_PAD_0 37
#define KEY_PAD_1 38
#define KEY_PAD_2 39
#define KEY_PAD_3 40
#define KEY_PAD_4 41
#define KEY_PAD_5 42
#define KEY_PAD_6 43
#define KEY_PAD_7 44
#define KEY_PAD_8 45
#define KEY_PAD_9 46
#define KEY_F1 47
#define KEY_F2 48
#define KEY_F3 49
#define KEY_F4 50
#define KEY_F5 51
#define KEY_F6 52
#define KEY_F7 53
#define KEY_F8 54
#define KEY_F9 55
#define KEY_F10 56
#define KEY_F11 57
#define KEY_F12 58
#define KEY_ESC 59
#define KEY_TILDE 60
#define KEY_MINUS 61
#define KEY_EQUALS 62
#define KEY_BACKSPACE 63
#define KEY_TAB 64
#define KEY_OPENBRACE 65
#define KEY_CLOSEBRACE 66
#define KEY_ENTER 67
#define KEY_SEMICOLON 68
#define KEY_QUOTE 69
#define KEY_BACKSLASH 70
#define KEY_BACKSLASH2 71
#define KEY_COMMA 72
#define KEY_FULLSTOP 73
#define KEY_SLASH 74
#define KEY_SPACE 75
#define KEY_INSERT 76
#define KEY_DELETE 77
#define KEY_HOME 78
#define KEY_END 79
#define KEY_PGUP 80
#define KEY_PGDN 81
#define KEY_LEFT 82
#define KEY_RIGHT 83
#define KEY_UP 84
#define KEY_DOWN 85
#define KEY_PAD_SLASH 86
#define KEY_PAD_ASTERISK 87
#define KEY_PAD_MINUS 88
#define KEY_PAD_PLUS 89
#define KEY_PAD_DELETE 90
#define KEY_PAD_ENTER 91
#define KEY_PRINTSCREEN 92
#define KEY_PAUSE 93
#define KEY_ABNT_C1 94
#define KEY_YEN 95
#define KEY_KANA 96
#define KEY_CONVERT 97
#define KEY_NOCONVERT 98
#define KEY_AT 99
#define KEY_CIRCUMFLEX 100
#define KEY_COLON2 101
#define KEY_KANJI 102
#define KEY_PAD_EQUALS 103
#define KEY_BACKQUOTE 104
#define KEY_SEMICOLON2 105
#define KEY_COMMAND 106
#define KEY_BACK 107
#define KEY_VOLUME_UP 108
#define KEY_VOLUME_DOWN 109
#define KEY_SEARCH 110
#define KEY_DPAD_CENTER 111
#define KEY_BUTTON_X 112
#define KEY_BUTTON_Y 113
#define KEY_DPAD_UP 114
#define KEY_DPAD_DOWN 115
#define KEY_DPAD_LEFT 116
#define KEY_DPAD_RIGHT 117
#define KEY_SELECT 118
#define KEY_START 119
#define KEY_BUTTON_L1 120
#define KEY_BUTTON_R1 121
#define KEY_BUTTON_L2 122
#define KEY_BUTTON_R2 123
#define KEY_BUTTON_A 124
#define KEY_BUTTON_B 125
#define KEY_THUMBL 126
#define KEY_THUMBR 127
#define KEY_UNKNOWN 128
#define KEY_MODIFIERS 215
#define KEY_LSHIFT 215
#define KEY_RSHIFT 216
#define KEY_LCTRL 217
#define KEY_RCTRL 218
#define KEY_ALT 219
#define KEY_ALTGR 220
#define KEY_LWIN 221
#define KEY_RWIN 222
#define KEY_MENU 223
#define KEY_SCROLLLOCK 224
#define KEY_NUMLOCK 225
#define KEY_CAPSLOCK 226

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
