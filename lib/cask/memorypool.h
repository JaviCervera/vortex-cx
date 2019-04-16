#ifndef MEMORYPOOL_H_INCLUDED
#define MEMORYPOOL_H_INCLUDED

#include <stdlib.h>

#define CAlloc(T) ((T*)_CAlloc(sizeof(T), 0, 0))
#define CAllocEx(T,S,F) ((T*)_CAllocEx(sizeof(T), &S, sizeof(S), F))
#define CGetStub(T,M) ((T*)_CGetStub(M))

#ifdef __cplusplus
extern "C" {
#endif

struct CMemoryPool;

struct CMemoryPool* CAllocPool();

void CDrainPool(struct CMemoryPool* pool);

struct CMemoryPool* CActivePool();

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MEMORYPOOL_H_INCLUDED */
