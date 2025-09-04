// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_diagnosis.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DIAGNOSIS_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DIAGNOSIS_IDL_C_H_
#include "cronet.idl_c.h"
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_DiagnosisCallback Cronet_DiagnosisCallback;
typedef struct Cronet_DiagnosisCallback* Cronet_DiagnosisCallbackPtr;
typedef struct Cronet_DiagnosisRequest Cronet_DiagnosisRequest;
typedef struct Cronet_DiagnosisRequest* Cronet_DiagnosisRequestPtr;
typedef struct Cronet_DiagnosisHelper Cronet_DiagnosisHelper;
typedef struct Cronet_DiagnosisHelper* Cronet_DiagnosisHelperPtr;

// Forward declare structs.
typedef struct Cronet_RequestParams Cronet_RequestParams;
typedef struct Cronet_RequestParams* Cronet_RequestParamsPtr;

// Declare enums
typedef enum Cronet_RequestType {
  Cronet_RequestType_DNS_RESOLVE_TARGET = 0,
  Cronet_RequestType_RACE_TARGETS = 1,
  Cronet_RequestType_ACCELERATE_TARGET = 2,
  Cronet_RequestType_DIAGNOSE_TARGET = 3,
  Cronet_RequestType_DIAGNOSE_V2_TARGET = 4,
  Cronet_RequestType_RAW_DETECT_TARGET = 5,
} Cronet_RequestType;

typedef enum Cronet_NetDetectType {
  Cronet_NetDetectType_INVALID = 0,
  Cronet_NetDetectType_HTTP_GET = 1,
  Cronet_NetDetectType_ICMP_PING = 2,
  Cronet_NetDetectType_ICMP_TRACEROUTE = 4,
  Cronet_NetDetectType_LOCAL_DNS = 8,
  Cronet_NetDetectType_DNS_HTTP = 16,
  Cronet_NetDetectType_DNS_SERVER = 32,
  Cronet_NetDetectType_UDP_PING = 64,
  Cronet_NetDetectType_FULL_DNS = 128,
  Cronet_NetDetectType_TCP_CONNECT = 256,
  Cronet_NetDetectType_TCP_ECHO = 512,
  Cronet_NetDetectType_UDP_PERF = 1024,
  Cronet_NetDetectType_TCP_PERF = 2048,
  Cronet_NetDetectType_HTTP_ISP = 4096,
} Cronet_NetDetectType;

typedef enum Cronet_HostResolverType {
  Cronet_HostResolverType_UNSPECIFIED = 0,
  Cronet_HostResolverType_LOCAL_DNS_ONLY = 1,
} Cronet_HostResolverType;

// Declare constants

///////////////////////
// Abstract interface Cronet_DiagnosisCallback is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_DiagnosisCallback.
CRONET_EXPORT void Cronet_DiagnosisCallback_Destroy(
    Cronet_DiagnosisCallbackPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_DiagnosisCallback_SetClientContext(
    Cronet_DiagnosisCallbackPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_DiagnosisCallback_GetClientContext(Cronet_DiagnosisCallbackPtr self);
// Abstract interface Cronet_DiagnosisCallback is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_DiagnosisCallback_OnDiagnosisComplete(
    Cronet_DiagnosisCallbackPtr self,
    Cronet_String report);
// The app implements abstract interface Cronet_DiagnosisCallback by defining
// custom functions for each method.
typedef void (*Cronet_DiagnosisCallback_OnDiagnosisCompleteFunc)(
    Cronet_DiagnosisCallbackPtr self,
    Cronet_String report);
// The app creates an instance of Cronet_DiagnosisCallback by providing custom
// functions for each method.
CRONET_EXPORT Cronet_DiagnosisCallbackPtr Cronet_DiagnosisCallback_CreateWith(
    Cronet_DiagnosisCallback_OnDiagnosisCompleteFunc OnDiagnosisCompleteFunc);

///////////////////////
// Concrete interface Cronet_DiagnosisRequest.

// Create an instance of Cronet_DiagnosisRequest.
CRONET_EXPORT Cronet_DiagnosisRequestPtr
Cronet_DiagnosisRequest_Create(Cronet_RequestParamsPtr request_param);
// Destroy an instance of Cronet_DiagnosisRequest.
CRONET_EXPORT void Cronet_DiagnosisRequest_Destroy(
    Cronet_DiagnosisRequestPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_DiagnosisRequest_SetClientContext(
    Cronet_DiagnosisRequestPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_DiagnosisRequest_GetClientContext(Cronet_DiagnosisRequestPtr self);
// Concrete methods of Cronet_DiagnosisRequest implemented by Cronet.
// The app calls them to manipulate Cronet_DiagnosisRequest.
CRONET_EXPORT
void Cronet_DiagnosisRequest_Start(Cronet_DiagnosisRequestPtr self,
                                   Cronet_DiagnosisCallbackPtr callback,
                                   Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_DiagnosisRequest_Cancel(Cronet_DiagnosisRequestPtr self);
CRONET_EXPORT
void Cronet_DiagnosisRequest_DoExtraCommand(Cronet_DiagnosisRequestPtr self,
                                            Cronet_String command,
                                            Cronet_String extra_message);
CRONET_EXPORT
void Cronet_DiagnosisRequest_SetUserExtraInfo(Cronet_DiagnosisRequestPtr self,
                                              Cronet_String extra_info);
// Concrete interface Cronet_DiagnosisRequest is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_DiagnosisRequest_StartFunc)(
    Cronet_DiagnosisRequestPtr self,
    Cronet_DiagnosisCallbackPtr callback,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_DiagnosisRequest_CancelFunc)(
    Cronet_DiagnosisRequestPtr self);
typedef void (*Cronet_DiagnosisRequest_DoExtraCommandFunc)(
    Cronet_DiagnosisRequestPtr self,
    Cronet_String command,
    Cronet_String extra_message);
typedef void (*Cronet_DiagnosisRequest_SetUserExtraInfoFunc)(
    Cronet_DiagnosisRequestPtr self,
    Cronet_String extra_info);
typedef void (*Cronet_DiagnosisRequest_DestroyFunc)(
    Cronet_DiagnosisRequestPtr self);
// Concrete interface Cronet_DiagnosisRequest is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_DiagnosisRequestPtr Cronet_DiagnosisRequest_CreateWith(
    Cronet_DiagnosisRequest_StartFunc StartFunc,
    Cronet_DiagnosisRequest_CancelFunc CancelFunc,
    Cronet_DiagnosisRequest_DoExtraCommandFunc DoExtraCommandFunc,
    Cronet_DiagnosisRequest_SetUserExtraInfoFunc SetUserExtraInfoFunc,
    Cronet_DiagnosisRequest_DestroyFunc DestroyFunc);

///////////////////////
// Concrete interface Cronet_DiagnosisHelper.

// Create an instance of Cronet_DiagnosisHelper.
CRONET_EXPORT Cronet_DiagnosisHelperPtr Cronet_DiagnosisHelper_Create(void);
// Destroy an instance of Cronet_DiagnosisHelper.
CRONET_EXPORT void Cronet_DiagnosisHelper_Destroy(
    Cronet_DiagnosisHelperPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_DiagnosisHelper_SetClientContext(
    Cronet_DiagnosisHelperPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_DiagnosisHelper_GetClientContext(Cronet_DiagnosisHelperPtr self);
// Concrete methods of Cronet_DiagnosisHelper implemented by Cronet.
// The app calls them to manipulate Cronet_DiagnosisHelper.
CRONET_EXPORT
void Cronet_DiagnosisHelper_SetDiagnosisDefaultEnabled(
    Cronet_DiagnosisHelperPtr self,
    bool enable);
CRONET_EXPORT
void Cronet_DiagnosisHelper_ReportNetworkEnvironment(
    Cronet_DiagnosisHelperPtr self,
    Cronet_String user_log);
CRONET_EXPORT
void Cronet_DiagnosisHelper_Destroy(Cronet_DiagnosisHelperPtr self);
// Concrete interface Cronet_DiagnosisHelper is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_DiagnosisHelper_SetDiagnosisDefaultEnabledFunc)(
    Cronet_DiagnosisHelperPtr self,
    bool enable);
typedef void (*Cronet_DiagnosisHelper_ReportNetworkEnvironmentFunc)(
    Cronet_DiagnosisHelperPtr self,
    Cronet_String user_log);
typedef void (*Cronet_DiagnosisHelper_DestroyFunc)(
    Cronet_DiagnosisHelperPtr self);
// Concrete interface Cronet_DiagnosisHelper is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_DiagnosisHelperPtr Cronet_DiagnosisHelper_CreateWith(
    Cronet_DiagnosisHelper_SetDiagnosisDefaultEnabledFunc
        SetDiagnosisDefaultEnabledFunc,
    Cronet_DiagnosisHelper_ReportNetworkEnvironmentFunc
        ReportNetworkEnvironmentFunc,
    Cronet_DiagnosisHelper_DestroyFunc DestroyFunc);

///////////////////////
// Struct Cronet_RequestParams.
CRONET_EXPORT Cronet_RequestParamsPtr Cronet_RequestParams_Create(void);
CRONET_EXPORT void Cronet_RequestParams_Destroy(Cronet_RequestParamsPtr self);
// Cronet_RequestParams setters.
CRONET_EXPORT
void Cronet_RequestParams_req_type_set(Cronet_RequestParamsPtr self,
                                       const Cronet_RequestType req_type);
CRONET_EXPORT
void Cronet_RequestParams_targets_add(Cronet_RequestParamsPtr self,
                                      const Cronet_String element);
CRONET_EXPORT
void Cronet_RequestParams_net_detect_type_set(
    Cronet_RequestParamsPtr self,
    const Cronet_NetDetectType net_detect_type);
CRONET_EXPORT
void Cronet_RequestParams_resolver_type_set(
    Cronet_RequestParamsPtr self,
    const Cronet_HostResolverType resolver_type);
CRONET_EXPORT
void Cronet_RequestParams_tnc_config_set(Cronet_RequestParamsPtr self,
                                         const Cronet_String tnc_config);
CRONET_EXPORT
void Cronet_RequestParams_timeout_set(Cronet_RequestParamsPtr self,
                                      const int64_t timeout);
// Cronet_RequestParams getters.
CRONET_EXPORT
Cronet_RequestType Cronet_RequestParams_req_type_get(
    const Cronet_RequestParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_RequestParams_targets_size(const Cronet_RequestParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_RequestParams_targets_at(
    const Cronet_RequestParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_RequestParams_targets_clear(Cronet_RequestParamsPtr self);
CRONET_EXPORT
Cronet_NetDetectType Cronet_RequestParams_net_detect_type_get(
    const Cronet_RequestParamsPtr self);
CRONET_EXPORT
Cronet_HostResolverType Cronet_RequestParams_resolver_type_get(
    const Cronet_RequestParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_RequestParams_tnc_config_get(
    const Cronet_RequestParamsPtr self);
CRONET_EXPORT
int64_t Cronet_RequestParams_timeout_get(const Cronet_RequestParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DIAGNOSIS_IDL_C_H_
