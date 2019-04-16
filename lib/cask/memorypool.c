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
    /*for (size_t i = 0; i < CSize(pool->objects); ++i) {
        pool->objects[i*]
    }*/
    CRelease(pool->objects);
    pool->objects = NULL;
}

struct CMemoryPool* CActivePool() {
    return _pools[CSize(_pools) - 1];
}

void _CAddToPool(void* memory, struct CMemoryPool* pool) {
    CPushElement(pool, memory);
}
