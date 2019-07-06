#ifndef FILE_SYSTEM_H_INCLUDED
#define FILE_SYSTEM_H_INCLUDED

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

bool_t AddPak(const char* pakname);
bool_t IsFileInPak(const char* filename);
size_t GetFileSize(const char* filename);
bool_t GetFileContents(const char* filename, void* buffer);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* FILE_SYSTEM_H_INCLUDED */
