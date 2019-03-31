#ifndef TYPES_H_INCLUDED
#define TYPES_H_INCLUDED

#define FALSE 0
#define TRUE 1
#define STRING_SIZE 64
#define NUM_LIGHTS 8
#ifdef _WIN32
#if defined(DLLEXPORT)
#define EXPORT __declspec(dllexport)
#elif defined(DLLIMPORT)
#define EXPORT __declspec(dllimport)
#else
#define EXPORT
#endif
#define CALL __stdcall
#else
#define EXPORT
#define CALL
#endif

typedef char bool_t;

#include <stdlib.h>

#endif /* TYPES_H_INCLUDED */
