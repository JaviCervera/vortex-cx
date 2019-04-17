#ifndef MEMORYPOOL_H_INCLUDED
#define MEMORYPOOL_H_INCLUDED

#include <stdlib.h>

#define CAutorelease(A) (_CAutorelease(A), A)

#ifdef __cplusplus
extern "C" {
#endif

void CPushPool();

void CPopPool();

void CDrainPool();

void _CAutorelease(void* memory);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MEMORYPOOL_H_INCLUDED */
