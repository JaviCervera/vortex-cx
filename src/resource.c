#include "resource.h"

void InitResource(Resource* resource, void(* free_func)(void*))
{
    resource->refcount = 1;
    resource->free_func = free_func;
}

size_t RetainResource(Resource* resource) {
    return ++resource->refcount;
}

size_t ReleaseResource(Resource* resource) {
    size_t new_count;
    new_count = --resource->refcount;
    if (new_count == 0 && resource->free_func) {
        resource->free_func(resource);
    }
    return new_count;
}
