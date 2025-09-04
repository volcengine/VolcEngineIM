// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_tls_deprecated.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_TLS_DEPRECATED_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_TLS_DEPRECATED_IDL_C_H_
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_CertVerify Cronet_CertVerify;
typedef struct Cronet_CertVerify* Cronet_CertVerifyPtr;

// Forward declare structs.
typedef struct Cronet_CertData Cronet_CertData;
typedef struct Cronet_CertData* Cronet_CertDataPtr;
typedef struct Cronet_VerifyParamsV2 Cronet_VerifyParamsV2;
typedef struct Cronet_VerifyParamsV2* Cronet_VerifyParamsV2Ptr;
typedef struct Cronet_VerifyResult Cronet_VerifyResult;
typedef struct Cronet_VerifyResult* Cronet_VerifyResultPtr;

// Declare enums

// Declare constants

///////////////////////
// Concrete interface Cronet_CertVerify.

// Create an instance of Cronet_CertVerify.
CRONET_EXPORT Cronet_CertVerifyPtr Cronet_CertVerify_Create(void);
// Destroy an instance of Cronet_CertVerify.
CRONET_EXPORT void Cronet_CertVerify_Destroy(Cronet_CertVerifyPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_CertVerify_SetClientContext(
    Cronet_CertVerifyPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_CertVerify_GetClientContext(Cronet_CertVerifyPtr self);
// Concrete methods of Cronet_CertVerify implemented by Cronet.
// The app calls them to manipulate Cronet_CertVerify.
CRONET_EXPORT
int32_t Cronet_CertVerify_DoVerifyV2(Cronet_CertVerifyPtr self,
                                     Cronet_VerifyParamsV2Ptr params,
                                     Cronet_VerifyResultPtr result_params);
CRONET_EXPORT
void Cronet_CertVerify_Destroy(Cronet_CertVerifyPtr self);
// Concrete interface Cronet_CertVerify is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef int32_t (*Cronet_CertVerify_DoVerifyV2Func)(
    Cronet_CertVerifyPtr self,
    Cronet_VerifyParamsV2Ptr params,
    Cronet_VerifyResultPtr result_params);
typedef void (*Cronet_CertVerify_DestroyFunc)(Cronet_CertVerifyPtr self);
// Concrete interface Cronet_CertVerify is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_CertVerifyPtr
Cronet_CertVerify_CreateWith(Cronet_CertVerify_DoVerifyV2Func DoVerifyV2Func,
                             Cronet_CertVerify_DestroyFunc DestroyFunc);

///////////////////////
// Struct Cronet_CertData.
CRONET_EXPORT Cronet_CertDataPtr Cronet_CertData_Create(void);
CRONET_EXPORT void Cronet_CertData_Destroy(Cronet_CertDataPtr self);
// Cronet_CertData setters.
CRONET_EXPORT
void Cronet_CertData_data_add(Cronet_CertDataPtr self, const uint8_t element);
// Cronet_CertData getters.
CRONET_EXPORT
uint32_t Cronet_CertData_data_size(const Cronet_CertDataPtr self);
CRONET_EXPORT
uint8_t Cronet_CertData_data_at(const Cronet_CertDataPtr self, uint32_t index);
CRONET_EXPORT
void Cronet_CertData_data_clear(Cronet_CertDataPtr self);

///////////////////////
// Struct Cronet_VerifyParamsV2.
CRONET_EXPORT Cronet_VerifyParamsV2Ptr Cronet_VerifyParamsV2_Create(void);
CRONET_EXPORT void Cronet_VerifyParamsV2_Destroy(Cronet_VerifyParamsV2Ptr self);
// Cronet_VerifyParamsV2 setters.
CRONET_EXPORT
void Cronet_VerifyParamsV2_host_set(Cronet_VerifyParamsV2Ptr self,
                                    const Cronet_String host);
CRONET_EXPORT
void Cronet_VerifyParamsV2_port_set(Cronet_VerifyParamsV2Ptr self,
                                    const uint16_t port);
CRONET_EXPORT
void Cronet_VerifyParamsV2_certs_add(Cronet_VerifyParamsV2Ptr self,
                                     const Cronet_CertDataPtr element);
CRONET_EXPORT
void Cronet_VerifyParamsV2_ocsp_add(Cronet_VerifyParamsV2Ptr self,
                                    const uint8_t element);
CRONET_EXPORT
void Cronet_VerifyParamsV2_sct_list_add(Cronet_VerifyParamsV2Ptr self,
                                        const uint8_t element);
CRONET_EXPORT
void Cronet_VerifyParamsV2_flags_set(Cronet_VerifyParamsV2Ptr self,
                                     const int32_t flags);
// Cronet_VerifyParamsV2 getters.
CRONET_EXPORT
Cronet_String Cronet_VerifyParamsV2_host_get(
    const Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint16_t Cronet_VerifyParamsV2_port_get(const Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint32_t Cronet_VerifyParamsV2_certs_size(const Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
Cronet_CertDataPtr Cronet_VerifyParamsV2_certs_at(
    const Cronet_VerifyParamsV2Ptr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_VerifyParamsV2_certs_clear(Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint32_t Cronet_VerifyParamsV2_ocsp_size(const Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint8_t Cronet_VerifyParamsV2_ocsp_at(const Cronet_VerifyParamsV2Ptr self,
                                      uint32_t index);
CRONET_EXPORT
void Cronet_VerifyParamsV2_ocsp_clear(Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint32_t Cronet_VerifyParamsV2_sct_list_size(
    const Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
uint8_t Cronet_VerifyParamsV2_sct_list_at(const Cronet_VerifyParamsV2Ptr self,
                                          uint32_t index);
CRONET_EXPORT
void Cronet_VerifyParamsV2_sct_list_clear(Cronet_VerifyParamsV2Ptr self);
CRONET_EXPORT
int32_t Cronet_VerifyParamsV2_flags_get(const Cronet_VerifyParamsV2Ptr self);

///////////////////////
// Struct Cronet_VerifyResult.
CRONET_EXPORT Cronet_VerifyResultPtr Cronet_VerifyResult_Create(void);
CRONET_EXPORT void Cronet_VerifyResult_Destroy(Cronet_VerifyResultPtr self);
// Cronet_VerifyResult setters.
CRONET_EXPORT
void Cronet_VerifyResult_is_issued_by_known_root_set(
    Cronet_VerifyResultPtr self,
    const bool is_issued_by_known_root);
// Cronet_VerifyResult getters.
CRONET_EXPORT
bool Cronet_VerifyResult_is_issued_by_known_root_get(
    const Cronet_VerifyResultPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_TLS_DEPRECATED_IDL_C_H_
