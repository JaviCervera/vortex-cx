#include "array.h"
#include "memory.h"
#include "memorypool.h"

struct CMemoryPool {
    CArray(void*) objects;
};

static CArray(struct CMemoryPool*) _pools = NULL;

struct CMemoryPool* CAllocPool() {
    struct CMemoryPool* pool = CAllocFunc(struct CMemoryPool, CDrainPool);
    CPushElement(_pools, pool);
    return pool;
}

void CDrainPool(struct CMemoryPool* pool) {
}

struct CMemoryPool* CActivePool() {
    if (!_pools) {
        
    }
    return _pools[CSize(_pools) - 1];
}
