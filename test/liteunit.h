/*
LiteUnit
Public domain unit testing library
Created by Javier San Juan Cervera
No warranty implied. Use as you wish and at your own risk
*/

#ifndef LITE_UNIT_H
#define LITE_UNIT_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

struct ltestcase_s;
typedef void(* ltest_f)(struct ltestcase_s*);

typedef void(* ltestprint_f)(const char*);

typedef struct
{
  char str[128];
} lteststr_t;

typedef struct
{
  ltest_f test;
  lteststr_t msg;
} ltest_t;

typedef struct ltestcase_s
{
  lteststr_t name;
  ltest_f initcase;
  ltest_f deinitcase;
  ltest_f inittest;
  ltest_f deinittest;
  ltest_t* tests;
  size_t num_tests;
  size_t capacity;
  int assert_ok;
  int skip;
  size_t ok_asserts;
  size_t fail_asserts;
} ltestcase_t;

void ltestcase_init(ltestcase_t* case_, const char* name, ltest_f initcase, ltest_f deinitcase, ltest_f inittest, ltest_f deinittest);
void ltestcase_addtest(ltestcase_t* case_, ltest_f func, const char* msg);
void ltestcase_run(ltestcase_t* case_);

void ltest_skip(ltestcase_t* case_);
int ltest_assert(ltestcase_t* case_, int expression);
void ltest_printfunc(ltestprint_f func);




/* IMPLEMENTATION */




#ifdef LITE_UNIT_IMPLEMENTATION

#include <stdio.h>
#include <stdlib.h>

static void _ltest_printstd(const char* msg)
{
  printf("%s\n", msg);
}

static ltestprint_f _ltest_printfunc = _ltest_printstd;

void ltestcase_init(ltestcase_t* case_, const char* name, ltest_f initcase, ltest_f deinitcase, ltest_f inittest, ltest_f deinittest)
{
  snprintf(case_->name.str, sizeof(lteststr_t), "%s", name);
  case_->initcase = initcase;
  case_->deinitcase = deinitcase;
  case_->inittest = inittest;
  case_->deinittest = deinittest;
  case_->tests = NULL;
  case_->num_tests = 0;
  case_->capacity = 0;
  case_->assert_ok = 0;
  case_->skip = 0;
  case_->ok_asserts = 0;
  case_->fail_asserts = 0;
}

void ltestcase_addtest(ltestcase_t* case_, ltest_f func, const char* msg)
{
  if (case_->num_tests == case_->capacity)
  {
    case_->capacity += 10;
    case_->tests = (ltest_t*)realloc(case_->tests, case_->capacity * sizeof(ltest_t));
  }
  case_->tests[case_->num_tests].test = func;
  snprintf(case_->tests[case_->num_tests].msg.str, sizeof(lteststr_t), "%s", msg);
  case_->num_tests++;
}

void ltestcase_run(ltestcase_t* case_)
{
  lteststr_t str;
  size_t i;
  
  /* init tests */
  snprintf(str.str, sizeof(lteststr_t), "# Testing %s", case_->name.str);
  _ltest_printfunc(str.str);
  if (case_->initcase) case_->initcase(case_);
  case_->ok_asserts = 0;
  case_->fail_asserts = 0;

  /* run tests */
  for (i = 0; i < case_->num_tests; ++i)
  {
    /* init environment */
    if (case_->inittest) case_->inittest(case_);
    case_->assert_ok = 1;
    case_->skip = 0;

    /* run test */
    case_->tests[i].test(case_);
    if (case_->deinittest) case_->deinittest(case_);

    /* print output */
    snprintf(str.str, sizeof(lteststr_t), "* %s -> %s",
      case_->tests[i].msg.str,
      (case_->skip ? "SKIP" : (case_->assert_ok ? "OK" : "FAIL")));
    _ltest_printfunc(str.str);
  }
  if (case_->deinitcase) case_->deinitcase(case_);

  /* print results */
  snprintf(str.str, sizeof(lteststr_t), "> Finished %i tests", case_->num_tests);
  _ltest_printfunc(str.str);
  snprintf(str.str, sizeof(lteststr_t), "> * %i passed assertions", case_->ok_asserts);
  _ltest_printfunc(str.str);
  snprintf(str.str, sizeof(lteststr_t), "> * %i failed assertions", case_->fail_asserts);
  _ltest_printfunc(str.str);
  _ltest_printfunc("");
}

void ltest_skip(ltestcase_t* case_)
{
  case_->skip = 1;
}

int ltest_assert(ltestcase_t* case_, int expression)
{
  case_->assert_ok = expression;
  if (expression) case_->ok_asserts++;
  else case_->fail_asserts++;
  return expression;
}

void ltest_printfunc(ltestprint_f func)
{
  _ltest_printfunc = func;
}

#endif /* LITE_UNIT_IMPLEMENTATION */

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* LITE_UNIT_H */
