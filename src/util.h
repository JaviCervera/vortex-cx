#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define _min(A, B)       (A < B ? A : B)
#define _max(A, B)       (A > B ? A : B)
#define _clamp(A, B, C)  _min(_max(A, B), C)
#define _alloc(T)        ((T*)malloc(sizeof(T)))
#define _allocnum(T,S)   ((T*)malloc(S*sizeof(T)))

void ext_strip(const char* filename, char* out, size_t len);
void ext_extract(const char* filename, char* out, size_t len);
void dir_strip(const char* filename, char* out, size_t len);
void dir_extract(const char* filename, char* out, size_t len);
bool_t dir_contents(const char* path, char* out, size_t len);
void dir_current(char* out, size_t len);
bool_t dir_change(const char* path);
int str_casecmp(char const *a, char const *b);
void str_write(const char* str, const char* filename, bool_t append);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* UTIL_H_INCLUDED */
