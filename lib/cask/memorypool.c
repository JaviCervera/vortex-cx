#include "array.h"
#include "memory.h"
#include "memorypool.h"

/* A pool is just an array of objects */
typedef CArray(void*) CMemoryPool;

/* Internal stack of pools */
static CArray(CMemoryPool) _pools = NULL;


void CPushPool() {
    CPushMany(_pools, 1);
}

void CPopPool() {
	CPop(_pools);
}

void CDrainPool() {
	/*  */
    CRelease(CBack(_pools));
}

void _CAutorelease(void* memory) {
    CPush(CBack(_pools), memory);
}
