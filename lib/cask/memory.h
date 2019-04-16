#ifndef MEMORY_H_INCLUDED
#define MEMORY_H_INCLUDED

#include <stdlib.h>

#define CAlloc(T) ((T*)_CAlloc(sizeof(T), 0))
#define CAllocFunc(T,F) ((T*)_CAlloc(sizeof(T), F))
#define CAllocEx(T,S,F) ((T*)_CAllocEx(sizeof(T), &S, sizeof(S), F))
#define CGetStub(T,M) ((T*)_CGetStub(M))

#ifdef __cplusplus
extern "C" {
#endif

size_t CRetain(void* memory);

size_t CRelease(void* memory);

void* CAutorelease(void* mem);

void* _CAlloc(size_t size, void (* dealloc_callback)(void*));

void* _CAllocEx(
        size_t size,
        void* stub,
        size_t stub_size,
        void (* dealloc_callback)(void*));

void* _CGetStub(void* mem);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MEMORY_H_INCLUDED */
