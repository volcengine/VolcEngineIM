//
// Created on 2023/5/18.
//

#ifndef VCBASEKIT_DEBUG_H
#define VCBASEKIT_DEBUG_H

#include <assert.h>

#if defined(__DEBUG__)
#define assertm(exp, msg) assert(((void)msg, exp))
#define debugexpr(exp) exp
#else
#define assertm(exp, msg)
#define debugexpr(exp) static_assert(true, "")
#endif

/**
 * throw assert of exp is not true in debug mode
 */
#define assertm_true(exp)    assertm( static_cast<bool>(exp), #exp " should be true")

/**
 * throw assert of exp is not false in debug mode
 */
#define assertm_false(exp)   assertm(!static_cast<bool>(exp), #exp " should be false")

/**
 * throw assert of exp is null in debug mode
 */
#define assertm_nonnull(exp) assertm(                  (exp), #exp " should not null")

#endif // VCBASEKIT_DEBUG_H
