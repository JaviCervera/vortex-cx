#ifndef RESOURCE_H_INCLUDED
#define RESOURCE_H_INCLUDED

#include <stddef.h>

typedef struct {
    size_t refcount;
    void (* free_func)(void*);
} Resource;

void InitResource(Resource* resource, void(* free_func)(void*));
size_t RetainResource(Resource* resource);
size_t ReleaseResource(Resource* resource);

#endif /* RESOURCE_H_INCLUDED */
