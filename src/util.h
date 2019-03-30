#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

#define Min(A, B)       (A < B ? A : B)
#define Max(A, B)       (A > B ? A : B)
#define Clamp(A, B, C)  Min(Max(A, B), C)
#define Alloc(T)        ((T*)malloc(sizeof(T)))
#define AllocNum(T,N)   ((T*)malloc(N*sizeof(T)))

void StripExt(const char* filename, char* out, size_t len);
void ExtractExt(const char* filename, char* out, size_t len);
void StripDir(const char* filename, char* out, size_t len);
void ExtractDir(const char* filename, char* out, size_t len);
bool_t DirContents(const char* path, char* out, size_t len);
void CurrentDir(char* out, size_t len);
bool_t ChangeDir(const char* path);
int CompareStringInsensitive(char const *a, char const *b);
void WriteString(const char* str, const char* filename, bool_t append);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* UTIL_H_INCLUDED */
