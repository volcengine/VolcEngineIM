/* Copyright (c) 2014, Google Inc.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. */

/* This header is provided in order to make compiling against code that expects
   OpenSSL easier. */

#ifndef HEADER_SAFESTACK_H
# define HEADER_SAFESTACK_H

# include <openssl/stack.h>
# include <openssl/e_os2.h>

#ifdef __cplusplus
extern "C" {
#endif

# define STACK_OF(type) struct stack_st_##type

# define SKM_DEFINE_STACK_OF(t1, t2, t3) \
    STACK_OF(t1); \
    typedef int (*sk_##t1##_compfunc)(const t3 * const *a, const t3 *const *b); \
    typedef void (*sk_##t1##_freefunc)(t3 *a); \
    typedef t3 * (*sk_##t1##_copyfunc)(const t3 *a); \
    static ossl_unused ossl_inline int sk_##t1##_num(const STACK_OF(t1) *sk) \
    { \
        return OPENSSL_sk_num((const OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_value(const STACK_OF(t1) *sk, int idx) \
    { \
        return (t2 *)OPENSSL_sk_value((const OPENSSL_STACK *)sk, idx); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new(sk_##t1##_compfunc compare) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_new((OPENSSL_sk_compfunc)compare); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_null(void) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_new_null(); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_reserve(sk_##t1##_compfunc compare, int n) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_new_reserve((OPENSSL_sk_compfunc)compare, n); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_reserve(STACK_OF(t1) *sk, int n) \
    { \
        return OPENSSL_sk_reserve((OPENSSL_STACK *)sk, n); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_free(STACK_OF(t1) *sk) \
    { \
        OPENSSL_sk_free((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_zero(STACK_OF(t1) *sk) \
    { \
        OPENSSL_sk_zero((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_delete(STACK_OF(t1) *sk, int i) \
    { \
        return (t2 *)OPENSSL_sk_delete((OPENSSL_STACK *)sk, i); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_delete_ptr(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return (t2 *)OPENSSL_sk_delete_ptr((OPENSSL_STACK *)sk, \
                                           (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_push(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_push((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_unshift(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_unshift((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_pop(STACK_OF(t1) *sk) \
    { \
        return (t2 *)OPENSSL_sk_pop((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_shift(STACK_OF(t1) *sk) \
    { \
        return (t2 *)OPENSSL_sk_shift((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_pop_free(STACK_OF(t1) *sk, sk_##t1##_freefunc freefunc) \
    { \
        OPENSSL_sk_pop_free((OPENSSL_STACK *)sk, (OPENSSL_sk_freefunc)freefunc); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_insert(STACK_OF(t1) *sk, t2 *ptr, int idx) \
    { \
        return OPENSSL_sk_insert((OPENSSL_STACK *)sk, (const void *)ptr, idx); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_set(STACK_OF(t1) *sk, int idx, t2 *ptr) \
    { \
        return (t2 *)OPENSSL_sk_set((OPENSSL_STACK *)sk, idx, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_find(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_find((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_find_ex(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_find_ex((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_sort(STACK_OF(t1) *sk) \
    { \
        OPENSSL_sk_sort((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_is_sorted(const STACK_OF(t1) *sk) \
    { \
        return OPENSSL_sk_is_sorted((const OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) * sk_##t1##_dup(const STACK_OF(t1) *sk) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_dup((const OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_deep_copy(const STACK_OF(t1) *sk, \
                                                    sk_##t1##_copyfunc copyfunc, \
                                                    sk_##t1##_freefunc freefunc) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_deep_copy((const OPENSSL_STACK *)sk, \
                                            (OPENSSL_sk_copyfunc)copyfunc, \
                                            (OPENSSL_sk_freefunc)freefunc); \
    } \
    static ossl_unused ossl_inline sk_##t1##_compfunc sk_##t1##_set_cmp_func(STACK_OF(t1) *sk, sk_##t1##_compfunc compare) \
    { \
        return (sk_##t1##_compfunc)OPENSSL_sk_set_cmp_func((OPENSSL_STACK *)sk, (OPENSSL_sk_compfunc)compare); \
    }

# define DEFINE_STACK_OF_CONST(t) SKM_DEFINE_STACK_OF(t, const t, t)

/*-
 * Strings are special: normally an lhash entry will point to a single
 * (somewhat) mutable object. In the case of strings:
 *
 * a) Instead of a single char, there is an array of chars, NUL-terminated.
 * b) The string may have be immutable.
 *
 * So, they need their own declarations. Especially important for
 * type-checking tools, such as Deputy.
 *
 * In practice, however, it appears to be hard to have a const
 * string. For now, I'm settling for dealing with the fact it is a
 * string at all.
 */
typedef char *OPENSSL_STRING;
typedef const char *OPENSSL_CSTRING;

# ifdef  __cplusplus
}
# endif
#endif
