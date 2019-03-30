#ifndef TYPES_H_INCLUDED
#define TYPES_H_INCLUDED

#define FALSE 0
#define TRUE 1
#define STRING_SIZE 64
#define NUM_LIGHTS 8
#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#define CALL __stdcall
#else
#define EXPORT
#define CALL
#endif

typedef char bool_t;

#include <stdlib.h>

#endif /* TYPES_H_INCLUDED */
