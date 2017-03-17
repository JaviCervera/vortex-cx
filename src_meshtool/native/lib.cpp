#if defined(__APPLE__) || defined(__linux__)
#include <dlfcn.h>
#endif
#include <vector>

static std::vector<void*> __monk_libStack__;					// Array with stack variables to use when calling function
static std::vector<String::CString<char> > __monk_strStack__;	// Array with stack of strings

#ifdef _WIN32
#define CALLCONV __stdcall
#else
#define CALLCONV
#endif

typedef void (CALLCONV *__monk_voidfunc0__)();
typedef void (CALLCONV *__monk_voidfunc1__)(void*);
typedef void (CALLCONV *__monk_voidfunc2__)(void*, void*);
typedef void (CALLCONV *__monk_voidfunc3__)(void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc4__)(void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc5__)(void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc6__)(void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (CALLCONV *__monk_voidfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc0__)();
typedef int (CALLCONV *__monk_intfunc1__)(void*);
typedef int (CALLCONV *__monk_intfunc2__)(void*, void*);
typedef int (CALLCONV *__monk_intfunc3__)(void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc4__)(void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc5__)(void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc6__)(void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (CALLCONV *__monk_intfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc0__)();
typedef float (CALLCONV *__monk_floatfunc1__)(void*);
typedef float (CALLCONV *__monk_floatfunc2__)(void*, void*);
typedef float (CALLCONV *__monk_floatfunc3__)(void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc4__)(void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc5__)(void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc6__)(void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (CALLCONV *__monk_floatfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc0__)();
typedef char* (CALLCONV *__monk_stringfunc1__)(void*);
typedef char* (CALLCONV *__monk_stringfunc2__)(void*, void*);
typedef char* (CALLCONV *__monk_stringfunc3__)(void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc4__)(void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc5__)(void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc6__)(void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (CALLCONV *__monk_stringfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc0__)();
typedef void* (CALLCONV *__monk_objectfunc1__)(void*);
typedef void* (CALLCONV *__monk_objectfunc2__)(void*, void*);
typedef void* (CALLCONV *__monk_objectfunc3__)(void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc4__)(void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc5__)(void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc6__)(void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (CALLCONV *__monk_objectfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc0__)();
typedef void (*__monk_voidcfunc1__)(void*);
typedef void (*__monk_voidcfunc2__)(void*, void*);
typedef void (*__monk_voidcfunc3__)(void*, void*, void*);
typedef void (*__monk_voidcfunc4__)(void*, void*, void*, void*);
typedef void (*__monk_voidcfunc5__)(void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc6__)(void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void (*__monk_voidcfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc0__)();
typedef int (*__monk_intcfunc1__)(void*);
typedef int (*__monk_intcfunc2__)(void*, void*);
typedef int (*__monk_intcfunc3__)(void*, void*, void*);
typedef int (*__monk_intcfunc4__)(void*, void*, void*, void*);
typedef int (*__monk_intcfunc5__)(void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc6__)(void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef int (*__monk_intcfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc0__)();
typedef float (*__monk_floatcfunc1__)(void*);
typedef float (*__monk_floatcfunc2__)(void*, void*);
typedef float (*__monk_floatcfunc3__)(void*, void*, void*);
typedef float (*__monk_floatcfunc4__)(void*, void*, void*, void*);
typedef float (*__monk_floatcfunc5__)(void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc6__)(void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef float (*__monk_floatcfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc0__)();
typedef char* (*__monk_stringcfunc1__)(void*);
typedef char* (*__monk_stringcfunc2__)(void*, void*);
typedef char* (*__monk_stringcfunc3__)(void*, void*, void*);
typedef char* (*__monk_stringcfunc4__)(void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc5__)(void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc6__)(void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef char* (*__monk_stringcfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc0__)();
typedef void* (*__monk_objectcfunc1__)(void*);
typedef void* (*__monk_objectcfunc2__)(void*, void*);
typedef void* (*__monk_objectcfunc3__)(void*, void*, void*);
typedef void* (*__monk_objectcfunc4__)(void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc5__)(void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc6__)(void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc7__)(void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc8__)(void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc9__)(void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc10__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc11__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc12__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc13__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc14__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc15__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);
typedef void* (*__monk_objectcfunc16__)(void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*, void*);

static void __monk_callvoidfunc0__(__monk_voidfunc0__ func) {
	func();
}

static void __monk_callvoidfunc1__(__monk_voidfunc1__ func, void* p0) {
	func(p0);
}

static void __monk_callvoidfunc2__(__monk_voidfunc2__ func, void* p0, void* p1) {
	func(p0, p1);
}

static void __monk_callvoidfunc3__(__monk_voidfunc3__ func, void* p0, void* p1, void* p2) {
	func(p0, p1, p2);
}

static void __monk_callvoidfunc4__(__monk_voidfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	func(p0, p1, p2, p3);
}

static void __monk_callvoidfunc5__(__monk_voidfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	func(p0, p1, p2, p3, p4);
}

static void __monk_callvoidfunc6__(__monk_voidfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	func(p0, p1, p2, p3, p4, p5);
}

static void __monk_callvoidfunc7__(__monk_voidfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	func(p0, p1, p2, p3, p4, p5, p6);
}

static void __monk_callvoidfunc8__(__monk_voidfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static void __monk_callvoidfunc9__(__monk_voidfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static void __monk_callvoidfunc10__(__monk_voidfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static void __monk_callvoidfunc11__(__monk_voidfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static void __monk_callvoidfunc12__(__monk_voidfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static void __monk_callvoidfunc13__(__monk_voidfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static void __monk_callvoidfunc14__(__monk_voidfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static void __monk_callvoidfunc15__(__monk_voidfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static void __monk_callvoidfunc16__(__monk_voidfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static int __monk_callintfunc0__(__monk_intfunc0__ func) {
	return func();
}

static int __monk_callintfunc1__(__monk_intfunc1__ func, void* p0) {
	return func(p0);
}

static int __monk_callintfunc2__(__monk_intfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static int __monk_callintfunc3__(__monk_intfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static int __monk_callintfunc4__(__monk_intfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static int __monk_callintfunc5__(__monk_intfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static int __monk_callintfunc6__(__monk_intfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static int __monk_callintfunc7__(__monk_intfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static int __monk_callintfunc8__(__monk_intfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static int __monk_callintfunc9__(__monk_intfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static int __monk_callintfunc10__(__monk_intfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static int __monk_callintfunc11__(__monk_intfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static int __monk_callintfunc12__(__monk_intfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static int __monk_callintfunc13__(__monk_intfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static int __monk_callintfunc14__(__monk_intfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static int __monk_callintfunc15__(__monk_intfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static int __monk_callintfunc16__(__monk_intfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static float __monk_callfloatfunc0__(__monk_floatfunc0__ func) {
	return func();
}

static float __monk_callfloatfunc1__(__monk_floatfunc1__ func, void* p0) {
	return func(p0);
}

static float __monk_callfloatfunc2__(__monk_floatfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static float __monk_callfloatfunc3__(__monk_floatfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static float __monk_callfloatfunc4__(__monk_floatfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static float __monk_callfloatfunc5__(__monk_floatfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static float __monk_callfloatfunc6__(__monk_floatfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static float __monk_callfloatfunc7__(__monk_floatfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static float __monk_callfloatfunc8__(__monk_floatfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static float __monk_callfloatfunc9__(__monk_floatfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static float __monk_callfloatfunc10__(__monk_floatfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static float __monk_callfloatfunc11__(__monk_floatfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static float __monk_callfloatfunc12__(__monk_floatfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static float __monk_callfloatfunc13__(__monk_floatfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static float __monk_callfloatfunc14__(__monk_floatfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static float __monk_callfloatfunc15__(__monk_floatfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static float __monk_callfloatfunc16__(__monk_floatfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static char* __monk_callstringfunc0__(__monk_stringfunc0__ func) {
	return func();
}

static char* __monk_callstringfunc1__(__monk_stringfunc1__ func, void* p0) {
	return func(p0);
}

static char* __monk_callstringfunc2__(__monk_stringfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static char* __monk_callstringfunc3__(__monk_stringfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static char* __monk_callstringfunc4__(__monk_stringfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static char* __monk_callstringfunc5__(__monk_stringfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static char* __monk_callstringfunc6__(__monk_stringfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static char* __monk_callstringfunc7__(__monk_stringfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static char* __monk_callstringfunc8__(__monk_stringfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static char* __monk_callstringfunc9__(__monk_stringfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static char* __monk_callstringfunc10__(__monk_stringfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static char* __monk_callstringfunc11__(__monk_stringfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static char* __monk_callstringfunc12__(__monk_stringfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static char* __monk_callstringfunc13__(__monk_stringfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static char* __monk_callstringfunc14__(__monk_stringfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static char* __monk_callstringfunc15__(__monk_stringfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static char* __monk_callstringfunc16__(__monk_stringfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static void* __monk_callobjectfunc0__(__monk_objectfunc0__ func) {
	return func();
}

static void* __monk_callobjectfunc1__(__monk_objectfunc1__ func, void* p0) {
	return func(p0);
}

static void* __monk_callobjectfunc2__(__monk_objectfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static void* __monk_callobjectfunc3__(__monk_objectfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static void* __monk_callobjectfunc4__(__monk_objectfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static void* __monk_callobjectfunc5__(__monk_objectfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static void* __monk_callobjectfunc6__(__monk_objectfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static void* __monk_callobjectfunc7__(__monk_objectfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static void* __monk_callobjectfunc8__(__monk_objectfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static void* __monk_callobjectfunc9__(__monk_objectfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static void* __monk_callobjectfunc10__(__monk_objectfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static void* __monk_callobjectfunc11__(__monk_objectfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static void* __monk_callobjectfunc12__(__monk_objectfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static void* __monk_callobjectfunc13__(__monk_objectfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static void* __monk_callobjectfunc14__(__monk_objectfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static void* __monk_callobjectfunc15__(__monk_objectfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static void* __monk_callobjectfunc16__(__monk_objectfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static void __monk_callvoidcfunc0__(__monk_voidcfunc0__ func) {
	func();
}

static void __monk_callvoidcfunc1__(__monk_voidcfunc1__ func, void* p0) {
	func(p0);
}

static void __monk_callvoidcfunc2__(__monk_voidcfunc2__ func, void* p0, void* p1) {
	func(p0, p1);
}

static void __monk_callvoidcfunc3__(__monk_voidcfunc3__ func, void* p0, void* p1, void* p2) {
	func(p0, p1, p2);
}

static void __monk_callvoidcfunc4__(__monk_voidcfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	func(p0, p1, p2, p3);
}

static void __monk_callvoidcfunc5__(__monk_voidcfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	func(p0, p1, p2, p3, p4);
}

static void __monk_callvoidcfunc6__(__monk_voidcfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	func(p0, p1, p2, p3, p4, p5);
}

static void __monk_callvoidcfunc7__(__monk_voidcfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	func(p0, p1, p2, p3, p4, p5, p6);
}

static void __monk_callvoidcfunc8__(__monk_voidcfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static void __monk_callvoidcfunc9__(__monk_voidcfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static void __monk_callvoidcfunc10__(__monk_voidcfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static void __monk_callvoidcfunc11__(__monk_voidcfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static void __monk_callvoidcfunc12__(__monk_voidcfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static void __monk_callvoidcfunc13__(__monk_voidcfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static void __monk_callvoidcfunc14__(__monk_voidcfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static void __monk_callvoidcfunc15__(__monk_voidcfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static void __monk_callvoidcfunc16__(__monk_voidcfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static int __monk_callintcfunc0__(__monk_intcfunc0__ func) {
	return func();
}

static int __monk_callintcfunc1__(__monk_intcfunc1__ func, void* p0) {
	return func(p0);
}

static int __monk_callintcfunc2__(__monk_intcfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static int __monk_callintcfunc3__(__monk_intcfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static int __monk_callintcfunc4__(__monk_intcfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static int __monk_callintcfunc5__(__monk_intcfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static int __monk_callintcfunc6__(__monk_intcfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static int __monk_callintcfunc7__(__monk_intcfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static int __monk_callintcfunc8__(__monk_intcfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static int __monk_callintcfunc9__(__monk_intcfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static int __monk_callintcfunc10__(__monk_intcfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static int __monk_callintcfunc11__(__monk_intcfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static int __monk_callintcfunc12__(__monk_intcfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static int __monk_callintcfunc13__(__monk_intcfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static int __monk_callintcfunc14__(__monk_intcfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static int __monk_callintcfunc15__(__monk_intcfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static int __monk_callintcfunc16__(__monk_intcfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static float __monk_callfloatcfunc0__(__monk_floatcfunc0__ func) {
	return func();
}

static float __monk_callfloatcfunc1__(__monk_floatcfunc1__ func, void* p0) {
	return func(p0);
}

static float __monk_callfloatcfunc2__(__monk_floatcfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static float __monk_callfloatcfunc3__(__monk_floatcfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static float __monk_callfloatcfunc4__(__monk_floatcfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static float __monk_callfloatcfunc5__(__monk_floatcfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static float __monk_callfloatcfunc6__(__monk_floatcfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static float __monk_callfloatcfunc7__(__monk_floatcfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static float __monk_callfloatcfunc8__(__monk_floatcfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static float __monk_callfloatcfunc9__(__monk_floatcfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static float __monk_callfloatcfunc10__(__monk_floatcfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static float __monk_callfloatcfunc11__(__monk_floatcfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static float __monk_callfloatcfunc12__(__monk_floatcfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static float __monk_callfloatcfunc13__(__monk_floatcfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static float __monk_callfloatcfunc14__(__monk_floatcfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static float __monk_callfloatcfunc15__(__monk_floatcfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static float __monk_callfloatcfunc16__(__monk_floatcfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static char* __monk_callstringcfunc0__(__monk_stringcfunc0__ func) {
	return func();
}

static char* __monk_callstringcfunc1__(__monk_stringcfunc1__ func, void* p0) {
	return func(p0);
}

static char* __monk_callstringcfunc2__(__monk_stringcfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static char* __monk_callstringcfunc3__(__monk_stringcfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static char* __monk_callstringcfunc4__(__monk_stringcfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static char* __monk_callstringcfunc5__(__monk_stringcfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static char* __monk_callstringcfunc6__(__monk_stringcfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static char* __monk_callstringcfunc7__(__monk_stringcfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static char* __monk_callstringcfunc8__(__monk_stringcfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static char* __monk_callstringcfunc9__(__monk_stringcfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static char* __monk_callstringcfunc10__(__monk_stringcfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static char* __monk_callstringcfunc11__(__monk_stringcfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static char* __monk_callstringcfunc12__(__monk_stringcfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static char* __monk_callstringcfunc13__(__monk_stringcfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static char* __monk_callstringcfunc14__(__monk_stringcfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static char* __monk_callstringcfunc15__(__monk_stringcfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static char* __monk_callstringcfunc16__(__monk_stringcfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}

static void* __monk_callobjectcfunc0__(__monk_objectcfunc0__ func) {
	return func();
}

static void* __monk_callobjectcfunc1__(__monk_objectcfunc1__ func, void* p0) {
	return func(p0);
}

static void* __monk_callobjectcfunc2__(__monk_objectcfunc2__ func, void* p0, void* p1) {
	return func(p0, p1);
}

static void* __monk_callobjectcfunc3__(__monk_objectcfunc3__ func, void* p0, void* p1, void* p2) {
	return func(p0, p1, p2);
}

static void* __monk_callobjectcfunc4__(__monk_objectcfunc4__ func, void* p0, void* p1, void* p2, void* p3) {
	return func(p0, p1, p2, p3);
}

static void* __monk_callobjectcfunc5__(__monk_objectcfunc5__ func, void* p0, void* p1, void* p2, void* p3, void* p4) {
	return func(p0, p1, p2, p3, p4);
}

static void* __monk_callobjectcfunc6__(__monk_objectcfunc6__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5) {
	return func(p0, p1, p2, p3, p4, p5);
}

static void* __monk_callobjectcfunc7__(__monk_objectcfunc7__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6) {
	return func(p0, p1, p2, p3, p4, p5, p6);
}

static void* __monk_callobjectcfunc8__(__monk_objectcfunc8__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7);
}

static void* __monk_callobjectcfunc9__(__monk_objectcfunc9__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8);
}

static void* __monk_callobjectcfunc10__(__monk_objectcfunc10__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9);
}

static void* __monk_callobjectcfunc11__(__monk_objectcfunc11__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}

static void* __monk_callobjectcfunc12__(__monk_objectcfunc12__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}

static void* __monk_callobjectcfunc13__(__monk_objectcfunc13__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
}

static void* __monk_callobjectcfunc14__(__monk_objectcfunc14__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
}

static void* __monk_callobjectcfunc15__(__monk_objectcfunc15__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
}

static void* __monk_callobjectcfunc16__(__monk_objectcfunc16__ func, void* p0, void* p1, void* p2, void* p3, void* p4, void* p5, void* p6, void* p7, void* p8, void* p9, void* p10, void* p11, void* p12, void* p13, void* p14, void* p15) {
	return func(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
}




























int LoadLib(String libname) {
	String::CString<char> cstr = libname.ToCString<char>();
	const char* ptr = cstr;
#if defined(_WIN32)
	return (int)LoadLibraryA(ptr);
#elif defined(__APPLE__)
	return (int)dlopen(ptr, 101);
#elif defined(__linux__)
	return (int)dlopen(ptr, 101);
#endif
}

void FreeLib(int lib) {
#if defined(_WIN32)
    FreeLibrary((HMODULE)lib);
#else
    dlclose((void*)lib);
#endif
}

int LibFunction(int lib, String funcname) {
	String::CString<char> cstr = funcname.ToCString<char>();
	const char* ptr = cstr;
#if defined(_WIN32)
	return (int)GetProcAddress((HMODULE)lib, ptr);
#else
	return (int)dlsym((void*)lib, ptr);
#endif
}

void PushLibInt(int val) {
    __monk_libStack__.push_back((void*)val);
}

void PushLibFloat(float val) {
	void* p;
	memcpy(&p, &val, sizeof(float));
    __monk_libStack__.push_back(p);
}

void PushLibString(String str) {
	__monk_strStack__.push_back(str.ToCString<char>());
    __monk_libStack__.push_back((void*)(const char*)__monk_strStack__.back());
}

/*
void PushLibObject(int obj) {
	__monk_libStack__.push_back((void*)val);
}
*/

void CallVoidFunction(int func) {
    int i;
    void* p[16];

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        __monk_callvoidfunc0__((__monk_voidfunc0__)func);
        break;
    case 1:
        __monk_callvoidfunc1__((__monk_voidfunc1__)func, p[0]);
        break;
    case 2:
        __monk_callvoidfunc2__((__monk_voidfunc2__)func, p[0], p[1]);
        break;
    case 3:
        __monk_callvoidfunc3__((__monk_voidfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        __monk_callvoidfunc4__((__monk_voidfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        __monk_callvoidfunc5__((__monk_voidfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        __monk_callvoidfunc6__((__monk_voidfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        __monk_callvoidfunc7__((__monk_voidfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        __monk_callvoidfunc8__((__monk_voidfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        __monk_callvoidfunc9__((__monk_voidfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        __monk_callvoidfunc10__((__monk_voidfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        __monk_callvoidfunc11__((__monk_voidfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        __monk_callvoidfunc12__((__monk_voidfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        __monk_callvoidfunc13__((__monk_voidfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        __monk_callvoidfunc14__((__monk_voidfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        __monk_callvoidfunc15__((__monk_voidfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        __monk_callvoidfunc16__((__monk_voidfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();
}

int CallIntFunction(int func) {
    int i;
    void* p[16];
	int ret = 0;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callintfunc0__((__monk_intfunc0__)func);
        break;
    case 1:
        ret = __monk_callintfunc1__((__monk_intfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callintfunc2__((__monk_intfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callintfunc3__((__monk_intfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callintfunc4__((__monk_intfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callintfunc5__((__monk_intfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callintfunc6__((__monk_intfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callintfunc7__((__monk_intfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callintfunc8__((__monk_intfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callintfunc9__((__monk_intfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callintfunc10__((__monk_intfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callintfunc11__((__monk_intfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callintfunc12__((__monk_intfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callintfunc13__((__monk_intfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callintfunc14__((__monk_intfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callintfunc15__((__monk_intfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callintfunc16__((__monk_intfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

    return ret;
}

float CallFloatFunction(int func) {
    int i;
    void* p[16];
	float ret = 0.0f;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callfloatfunc0__((__monk_floatfunc0__)func);
        break;
    case 1:
        ret = __monk_callfloatfunc1__((__monk_floatfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callfloatfunc2__((__monk_floatfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callfloatfunc3__((__monk_floatfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callfloatfunc4__((__monk_floatfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callfloatfunc5__((__monk_floatfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callfloatfunc6__((__monk_floatfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callfloatfunc7__((__monk_floatfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callfloatfunc8__((__monk_floatfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callfloatfunc9__((__monk_floatfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callfloatfunc10__((__monk_floatfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callfloatfunc11__((__monk_floatfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callfloatfunc12__((__monk_floatfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callfloatfunc13__((__monk_floatfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callfloatfunc14__((__monk_floatfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callfloatfunc15__((__monk_floatfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callfloatfunc16__((__monk_floatfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

    return ret;
}

String CallStringFunction(int func) {
    int i;
    void* p[16];
	char* ret = NULL;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callstringfunc0__((__monk_stringfunc0__)func);
        break;
    case 1:
        ret = __monk_callstringfunc1__((__monk_stringfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callstringfunc2__((__monk_stringfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callstringfunc3__((__monk_stringfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callstringfunc4__((__monk_stringfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callstringfunc5__((__monk_stringfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callstringfunc6__((__monk_stringfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callstringfunc7__((__monk_stringfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callstringfunc8__((__monk_stringfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callstringfunc9__((__monk_stringfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callstringfunc10__((__monk_stringfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callstringfunc11__((__monk_stringfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callstringfunc12__((__monk_stringfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callstringfunc13__((__monk_stringfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callstringfunc14__((__monk_stringfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callstringfunc15__((__monk_stringfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callstringfunc16__((__monk_stringfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

	return String(ret);
}

int CallObjectFunction(int func) {
    int i;
    void* p[16];
	void* ret = NULL;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callobjectfunc0__((__monk_objectfunc0__)func);
        break;
    case 1:
        ret = __monk_callobjectfunc1__((__monk_objectfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callobjectfunc2__((__monk_objectfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callobjectfunc3__((__monk_objectfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callobjectfunc4__((__monk_objectfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callobjectfunc5__((__monk_objectfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callobjectfunc6__((__monk_objectfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callobjectfunc7__((__monk_objectfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callobjectfunc8__((__monk_objectfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callobjectfunc9__((__monk_objectfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callobjectfunc10__((__monk_objectfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callobjectfunc11__((__monk_objectfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callobjectfunc12__((__monk_objectfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callobjectfunc13__((__monk_objectfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callobjectfunc14__((__monk_objectfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callobjectfunc15__((__monk_objectfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callobjectfunc16__((__monk_objectfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

	return (int)ret;
}

void CallVoidCFunction(int func) {
    int i;
    void* p[16];

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        __monk_callvoidcfunc0__((__monk_voidcfunc0__)func);
        break;
    case 1:
        __monk_callvoidcfunc1__((__monk_voidcfunc1__)func, p[0]);
        break;
    case 2:
        __monk_callvoidcfunc2__((__monk_voidcfunc2__)func, p[0], p[1]);
        break;
    case 3:
        __monk_callvoidcfunc3__((__monk_voidcfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        __monk_callvoidcfunc4__((__monk_voidcfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        __monk_callvoidcfunc5__((__monk_voidcfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        __monk_callvoidcfunc6__((__monk_voidcfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        __monk_callvoidcfunc7__((__monk_voidcfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        __monk_callvoidcfunc8__((__monk_voidcfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        __monk_callvoidcfunc9__((__monk_voidcfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        __monk_callvoidcfunc10__((__monk_voidcfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        __monk_callvoidcfunc11__((__monk_voidcfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        __monk_callvoidcfunc12__((__monk_voidcfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        __monk_callvoidcfunc13__((__monk_voidcfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        __monk_callvoidcfunc14__((__monk_voidcfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        __monk_callvoidcfunc15__((__monk_voidcfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        __monk_callvoidcfunc16__((__monk_voidcfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();
}

int CallIntCFunction(int func) {
    int i;
    void* p[16];
	int ret = 0;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callintcfunc0__((__monk_intcfunc0__)func);
        break;
    case 1:
        ret = __monk_callintcfunc1__((__monk_intcfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callintcfunc2__((__monk_intcfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callintcfunc3__((__monk_intcfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callintcfunc4__((__monk_intcfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callintcfunc5__((__monk_intcfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callintcfunc6__((__monk_intcfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callintcfunc7__((__monk_intcfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callintcfunc8__((__monk_intcfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callintcfunc9__((__monk_intcfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callintcfunc10__((__monk_intcfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callintcfunc11__((__monk_intcfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callintcfunc12__((__monk_intcfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callintcfunc13__((__monk_intcfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callintcfunc14__((__monk_intcfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callintcfunc15__((__monk_intcfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callintcfunc16__((__monk_intcfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

    return ret;
}

float CallFloatCFunction(int func) {
    int i;
    void* p[16];
	float ret = 0.0f;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callfloatcfunc0__((__monk_floatcfunc0__)func);
        break;
    case 1:
        ret = __monk_callfloatcfunc1__((__monk_floatcfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callfloatcfunc2__((__monk_floatcfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callfloatcfunc3__((__monk_floatcfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callfloatcfunc4__((__monk_floatcfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callfloatcfunc5__((__monk_floatcfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callfloatcfunc6__((__monk_floatcfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callfloatcfunc7__((__monk_floatcfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callfloatcfunc8__((__monk_floatcfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callfloatcfunc9__((__monk_floatcfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callfloatcfunc10__((__monk_floatcfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callfloatcfunc11__((__monk_floatcfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callfloatcfunc12__((__monk_floatcfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callfloatcfunc13__((__monk_floatcfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callfloatcfunc14__((__monk_floatcfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callfloatcfunc15__((__monk_floatcfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callfloatcfunc16__((__monk_floatcfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

    return ret;
}

String CallStringCFunction(int func) {
    int i;
    void* p[16];
	char* ret = NULL;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callstringcfunc0__((__monk_stringcfunc0__)func);
        break;
    case 1:
        ret = __monk_callstringcfunc1__((__monk_stringcfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callstringcfunc2__((__monk_stringcfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callstringcfunc3__((__monk_stringcfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callstringcfunc4__((__monk_stringcfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callstringcfunc5__((__monk_stringcfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callstringcfunc6__((__monk_stringcfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callstringcfunc7__((__monk_stringcfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callstringcfunc8__((__monk_stringcfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callstringcfunc9__((__monk_stringcfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callstringcfunc10__((__monk_stringcfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callstringcfunc11__((__monk_stringcfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callstringcfunc12__((__monk_stringcfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callstringcfunc13__((__monk_stringcfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callstringcfunc14__((__monk_stringcfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callstringcfunc15__((__monk_stringcfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callstringcfunc16__((__monk_stringcfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

	return String(ret);
}

int CallObjectCFunction(int func) {
    int i;
    void* p[16];
	void* ret = NULL;

    // Pop params from stack
    for ( i = 0; i < __monk_libStack__.size(); i++ ) {
		p[i] =__monk_libStack__[i];
    }

    // Call proper function
    switch ( __monk_libStack__.size() ) {
    case 0:
        ret = __monk_callobjectcfunc0__((__monk_objectcfunc0__)func);
        break;
    case 1:
        ret = __monk_callobjectcfunc1__((__monk_objectcfunc1__)func, p[0]);
        break;
    case 2:
        ret = __monk_callobjectcfunc2__((__monk_objectcfunc2__)func, p[0], p[1]);
        break;
    case 3:
        ret = __monk_callobjectcfunc3__((__monk_objectcfunc3__)func, p[0], p[1], p[2]);
        break;
    case 4:
        ret = __monk_callobjectcfunc4__((__monk_objectcfunc4__)func, p[0], p[1], p[2], p[3]);
        break;
    case 5:
        ret = __monk_callobjectcfunc5__((__monk_objectcfunc5__)func, p[0], p[1], p[2], p[3], p[4]);
        break;
    case 6:
        ret = __monk_callobjectcfunc6__((__monk_objectcfunc6__)func, p[0], p[1], p[2], p[3], p[4], p[5]);
        break;
    case 7:
        ret = __monk_callobjectcfunc7__((__monk_objectcfunc7__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
        break;
    case 8:
        ret = __monk_callobjectcfunc8__((__monk_objectcfunc8__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
        break;
    case 9:
        ret = __monk_callobjectcfunc9__((__monk_objectcfunc9__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
        break;
    case 10:
        ret = __monk_callobjectcfunc10__((__monk_objectcfunc10__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
        break;
    case 11:
        ret = __monk_callobjectcfunc11__((__monk_objectcfunc11__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
        break;
    case 12:
        ret = __monk_callobjectcfunc12__((__monk_objectcfunc12__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
        break;
    case 13:
        ret = __monk_callobjectcfunc13__((__monk_objectcfunc13__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]);
        break;
    case 14:
        ret = __monk_callobjectcfunc14__((__monk_objectcfunc14__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
        break;
    case 15:
        ret = __monk_callobjectcfunc15__((__monk_objectcfunc15__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]);
        break;
    case 16:
        ret = __monk_callobjectcfunc16__((__monk_objectcfunc16__)func, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15]);
        break;
    }

    // Clear library stack
    __monk_libStack__.clear();
    __monk_strStack__.clear();

	return (int)ret;
}
