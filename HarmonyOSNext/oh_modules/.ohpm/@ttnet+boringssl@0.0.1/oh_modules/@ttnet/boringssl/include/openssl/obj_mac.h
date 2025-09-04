/* Copyright (c) 2016, Google Inc.
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

#include "nid.h"

#if defined(TTNET_IMPLEMENT)
#define SN_sm3          "SM3"
#define LN_sm3          "sm3"
#define NID_sm3         1143
#define OBJ_sm3         OBJ_sm_scheme,401L

#define SN_sm3WithRSAEncryption         "RSA-SM3"
#define LN_sm3WithRSAEncryption         "sm3WithRSAEncryption"
#define NID_sm3WithRSAEncryption                1144
#define OBJ_sm3WithRSAEncryption                OBJ_sm_scheme,504L

#define SN_sm4_ecb              "SM4-ECB"
#define LN_sm4_ecb              "sm4-ecb"
#define NID_sm4_ecb             1133
#define OBJ_sm4_ecb             OBJ_sm_scheme,104L,1L

#define SN_sm4_cbc              "SM4-CBC"
#define LN_sm4_cbc              "sm4-cbc"
#define NID_sm4_cbc             1134
#define OBJ_sm4_cbc             OBJ_sm_scheme,104L,2L

#define SN_sm4_ofb128           "SM4-OFB"
#define LN_sm4_ofb128           "sm4-ofb"
#define NID_sm4_ofb128          1135
#define OBJ_sm4_ofb128          OBJ_sm_scheme,104L,3L

#define SN_sm4_cfb128           "SM4-CFB"
#define LN_sm4_cfb128           "sm4-cfb"
#define NID_sm4_cfb128          1137
#define OBJ_sm4_cfb128          OBJ_sm_scheme,104L,4L

#define SN_sm4_cfb1             "SM4-CFB1"
#define LN_sm4_cfb1             "sm4-cfb1"
#define NID_sm4_cfb1            1136
#define OBJ_sm4_cfb1            OBJ_sm_scheme,104L,5L

#define SN_sm4_cfb8             "SM4-CFB8"
#define LN_sm4_cfb8             "sm4-cfb8"
#define NID_sm4_cfb8            1138
#define OBJ_sm4_cfb8            OBJ_sm_scheme,104L,6L

#define SN_sm4_ctr              "SM4-CTR"
#define LN_sm4_ctr              "sm4-ctr"
#define NID_sm4_ctr             1139
#define OBJ_sm4_ctr             OBJ_sm_scheme,104L,7L
#endif
