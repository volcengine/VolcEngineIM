// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_encrypt.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_ENCRYPT_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_ENCRYPT_IDL_C_H_
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_TTNetCrypto Cronet_TTNetCrypto;
typedef struct Cronet_TTNetCrypto* Cronet_TTNetCryptoPtr;

// Forward declare structs.
typedef struct Cronet_ChaCha20_Key Cronet_ChaCha20_Key;
typedef struct Cronet_ChaCha20_Key* Cronet_ChaCha20_KeyPtr;

// Declare enums

// Declare constants

///////////////////////
// Concrete interface Cronet_TTNetCrypto.

// Create an instance of Cronet_TTNetCrypto.
CRONET_EXPORT Cronet_TTNetCryptoPtr Cronet_TTNetCrypto_Create(void);
// Destroy an instance of Cronet_TTNetCrypto.
CRONET_EXPORT void Cronet_TTNetCrypto_Destroy(Cronet_TTNetCryptoPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TTNetCrypto_SetClientContext(
    Cronet_TTNetCryptoPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TTNetCrypto_GetClientContext(Cronet_TTNetCryptoPtr self);
// Concrete methods of Cronet_TTNetCrypto implemented by Cronet.
// The app calls them to manipulate Cronet_TTNetCrypto.
CRONET_EXPORT
void Cronet_TTNetCrypto_ChaCha20_Encrypt(Cronet_TTNetCryptoPtr self,
                                         Cronet_RawDataPtr out,
                                         Cronet_RawDataPtr in,
                                         int32_t in_len,
                                         Cronet_ChaCha20_KeyPtr key);
// Concrete interface Cronet_TTNetCrypto is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_TTNetCrypto_ChaCha20_EncryptFunc)(
    Cronet_TTNetCryptoPtr self,
    Cronet_RawDataPtr out,
    Cronet_RawDataPtr in,
    int32_t in_len,
    Cronet_ChaCha20_KeyPtr key);
// Concrete interface Cronet_TTNetCrypto is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_TTNetCryptoPtr Cronet_TTNetCrypto_CreateWith(
    Cronet_TTNetCrypto_ChaCha20_EncryptFunc ChaCha20_EncryptFunc);

///////////////////////
// Struct Cronet_ChaCha20_Key.
CRONET_EXPORT Cronet_ChaCha20_KeyPtr Cronet_ChaCha20_Key_Create(void);
CRONET_EXPORT void Cronet_ChaCha20_Key_Destroy(Cronet_ChaCha20_KeyPtr self);
// Cronet_ChaCha20_Key setters.
CRONET_EXPORT
void Cronet_ChaCha20_Key_key_add(Cronet_ChaCha20_KeyPtr self,
                                 const uint8_t element);
CRONET_EXPORT
void Cronet_ChaCha20_Key_nonce_add(Cronet_ChaCha20_KeyPtr self,
                                   const uint8_t element);
CRONET_EXPORT
void Cronet_ChaCha20_Key_counter_set(Cronet_ChaCha20_KeyPtr self,
                                     const uint32_t counter);
// Cronet_ChaCha20_Key getters.
CRONET_EXPORT
uint32_t Cronet_ChaCha20_Key_key_size(const Cronet_ChaCha20_KeyPtr self);
CRONET_EXPORT
uint8_t Cronet_ChaCha20_Key_key_at(const Cronet_ChaCha20_KeyPtr self,
                                   uint32_t index);
CRONET_EXPORT
void Cronet_ChaCha20_Key_key_clear(Cronet_ChaCha20_KeyPtr self);
CRONET_EXPORT
uint32_t Cronet_ChaCha20_Key_nonce_size(const Cronet_ChaCha20_KeyPtr self);
CRONET_EXPORT
uint8_t Cronet_ChaCha20_Key_nonce_at(const Cronet_ChaCha20_KeyPtr self,
                                     uint32_t index);
CRONET_EXPORT
void Cronet_ChaCha20_Key_nonce_clear(Cronet_ChaCha20_KeyPtr self);
CRONET_EXPORT
uint32_t Cronet_ChaCha20_Key_counter_get(const Cronet_ChaCha20_KeyPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_ENCRYPT_IDL_C_H_
