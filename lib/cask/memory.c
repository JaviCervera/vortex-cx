#include "memory.h"
#include "memorypool.h"

typedef struct {
    size_t refcount;
    size_t size;
    size_t stub_size;
    void (* dealloc_callback)(void*);
} CMemoryInfo;

CMemoryInfo* _GetInfo(void* mem);


size_t CRetain(void* memory) {
    return ++memory->refcount;
}

size_t CRelease(void* memory) {
    size_t new_count;
    
    new_count = --memory->refcount;
    if (new_count == 0) {
        if (memory->dealloc_callback) {
            memory->dealloc_callback(memory);
        }
        free(_CGetStub(memory));
    }
    return new_count;
}

void* CAutorelease(void* mem) {
}

void* _CAlloc(size_t size, void (* dealloc_callback)(void*)) {
    char dummy;
    return _CAllocEx(size, &dummy, 0, dealloc_callback);
}

void* _CAllocEx(
        size_t size,
        void* stub,
        size_t stub_size,
        void (* dealloc_callback)(void*)) {
    void* block;
    MemoryInfo* info;
    
    /* Allocate block */
    block = malloc(size + stub_size + sizeof(CMemoryInfo));
    
    /* Copy stub */
    memcpy(block, stub, stub_size);
    
    /* Setup info */
    info = (CMemoryInfo*)(block + stub_size);
    info->refcount = 1;
    info->size = size;
    info->stub_size = stub_size;
    info->dealloc_callback = dealloc_callback;
    
    return block + stub_size + sizeof(CMemoryInfo);
}

CMemoryInfo* _GetInfo(void* mem) {
    return (CMemoryInfo*)(mem - sizeof(CMemoryInfo));
}

void* _CGetStub(void* mem) {
    return mem - sizeof(CMemoryInfo) - _GetInfo(mem)->stub_size;
}
