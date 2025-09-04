// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from components/cronet/native/generated/cronet_bis.idl
 */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_BIS_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_BIS_IDL_C_H_
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
typedef struct Cronet_BiStreamDelegate Cronet_BiStreamDelegate;
typedef struct Cronet_BiStreamDelegate* Cronet_BiStreamDelegatePtr;
typedef struct Cronet_BiStreamClient Cronet_BiStreamClient;
typedef struct Cronet_BiStreamClient* Cronet_BiStreamClientPtr;

// Forward declare structs.
typedef struct Cronet_ConnParams Cronet_ConnParams;
typedef struct Cronet_ConnParams* Cronet_ConnParamsPtr;

// Declare enums
typedef enum Cronet_TransportMode {
  Cronet_TransportMode_T_UDP = 0,
  Cronet_TransportMode_T_TLS = 1,
  Cronet_TransportMode_T_HTTP2 = 2,
  Cronet_TransportMode_T_SPDY = 3,
} Cronet_TransportMode;

typedef enum Cronet_BiStreamPriority {
  Cronet_BiStreamPriority_S_LOW = 0,
  Cronet_BiStreamPriority_S_MEDIUM = 1,
  Cronet_BiStreamPriority_S_HIGH = 2,
} Cronet_BiStreamPriority;

// Declare constants

///////////////////////
// Abstract interface Cronet_BiStreamDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_BiStreamDelegate.
CRONET_EXPORT void Cronet_BiStreamDelegate_Destroy(
    Cronet_BiStreamDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_BiStreamDelegate_SetClientContext(
    Cronet_BiStreamDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_BiStreamDelegate_GetClientContext(Cronet_BiStreamDelegatePtr self);
// Abstract interface Cronet_BiStreamDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_BiStreamDelegate_OnConnected(Cronet_BiStreamDelegatePtr self,
                                         Cronet_String extra_info);
CRONET_EXPORT
void Cronet_BiStreamDelegate_OnStreamReady(Cronet_BiStreamDelegatePtr self,
                                           uint32_t stream_id,
                                           Cronet_String extra_info);
CRONET_EXPORT
void Cronet_BiStreamDelegate_OnError(Cronet_BiStreamDelegatePtr self,
                                     uint32_t stream_id,
                                     int32_t error,
                                     Cronet_String extra_info);
CRONET_EXPORT
void Cronet_BiStreamDelegate_OnReceivedData(Cronet_BiStreamDelegatePtr self,
                                            uint32_t stream_id,
                                            Cronet_String data,
                                            uint64_t size,
                                            bool fin);
CRONET_EXPORT
void Cronet_BiStreamDelegate_OnFeedbackLog(Cronet_BiStreamDelegatePtr self,
                                           uint32_t stream_id,
                                           Cronet_String extra_info);
// The app implements abstract interface Cronet_BiStreamDelegate by defining
// custom functions for each method.
typedef void (*Cronet_BiStreamDelegate_OnConnectedFunc)(
    Cronet_BiStreamDelegatePtr self,
    Cronet_String extra_info);
typedef void (*Cronet_BiStreamDelegate_OnStreamReadyFunc)(
    Cronet_BiStreamDelegatePtr self,
    uint32_t stream_id,
    Cronet_String extra_info);
typedef void (*Cronet_BiStreamDelegate_OnErrorFunc)(
    Cronet_BiStreamDelegatePtr self,
    uint32_t stream_id,
    int32_t error,
    Cronet_String extra_info);
typedef void (*Cronet_BiStreamDelegate_OnReceivedDataFunc)(
    Cronet_BiStreamDelegatePtr self,
    uint32_t stream_id,
    Cronet_String data,
    uint64_t size,
    bool fin);
typedef void (*Cronet_BiStreamDelegate_OnFeedbackLogFunc)(
    Cronet_BiStreamDelegatePtr self,
    uint32_t stream_id,
    Cronet_String extra_info);
// The app creates an instance of Cronet_BiStreamDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_BiStreamDelegatePtr Cronet_BiStreamDelegate_CreateWith(
    Cronet_BiStreamDelegate_OnConnectedFunc OnConnectedFunc,
    Cronet_BiStreamDelegate_OnStreamReadyFunc OnStreamReadyFunc,
    Cronet_BiStreamDelegate_OnErrorFunc OnErrorFunc,
    Cronet_BiStreamDelegate_OnReceivedDataFunc OnReceivedDataFunc,
    Cronet_BiStreamDelegate_OnFeedbackLogFunc OnFeedbackLogFunc);

///////////////////////
// Concrete interface Cronet_BiStreamClient.

// Create an instance of Cronet_BiStreamClient.
CRONET_EXPORT Cronet_BiStreamClientPtr Cronet_BiStreamClient_Create(void);
// Destroy an instance of Cronet_BiStreamClient.
CRONET_EXPORT void Cronet_BiStreamClient_Destroy(Cronet_BiStreamClientPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_BiStreamClient_SetClientContext(
    Cronet_BiStreamClientPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_BiStreamClient_GetClientContext(Cronet_BiStreamClientPtr self);
// Concrete methods of Cronet_BiStreamClient implemented by Cronet.
// The app calls them to manipulate Cronet_BiStreamClient.
CRONET_EXPORT
void Cronet_BiStreamClient_CreateConnection(Cronet_BiStreamClientPtr self,
                                            Cronet_ConnParamsPtr params);
CRONET_EXPORT
uint32_t Cronet_BiStreamClient_CreateStream(Cronet_BiStreamClientPtr self,
                                            Cronet_BiStreamPriority priority,
                                            Cronet_String early_data,
                                            uint64_t early_size);
CRONET_EXPORT
bool Cronet_BiStreamClient_IsConnectionReady(Cronet_BiStreamClientPtr self);
CRONET_EXPORT
bool Cronet_BiStreamClient_IsStreamReady(Cronet_BiStreamClientPtr self,
                                         uint32_t stream_id);
CRONET_EXPORT
void Cronet_BiStreamClient_SendData(Cronet_BiStreamClientPtr self,
                                    uint32_t stream_id,
                                    Cronet_String data,
                                    uint64_t size);
CRONET_EXPORT
void Cronet_BiStreamClient_CloseStream(Cronet_BiStreamClientPtr self,
                                       uint32_t stream_id);
CRONET_EXPORT
void Cronet_BiStreamClient_CloseConnection(Cronet_BiStreamClientPtr self);
CRONET_EXPORT
void Cronet_BiStreamClient_AddDelegate(Cronet_BiStreamClientPtr self,
                                       Cronet_BiStreamDelegatePtr delegate,
                                       Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_BiStreamClient_RemoveDelegate(Cronet_BiStreamClientPtr self,
                                          Cronet_BiStreamDelegatePtr delegate);
// Concrete interface Cronet_BiStreamClient is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_BiStreamClient_CreateConnectionFunc)(
    Cronet_BiStreamClientPtr self,
    Cronet_ConnParamsPtr params);
typedef uint32_t (*Cronet_BiStreamClient_CreateStreamFunc)(
    Cronet_BiStreamClientPtr self,
    Cronet_BiStreamPriority priority,
    Cronet_String early_data,
    uint64_t early_size);
typedef bool (*Cronet_BiStreamClient_IsConnectionReadyFunc)(
    Cronet_BiStreamClientPtr self);
typedef bool (*Cronet_BiStreamClient_IsStreamReadyFunc)(
    Cronet_BiStreamClientPtr self,
    uint32_t stream_id);
typedef void (*Cronet_BiStreamClient_SendDataFunc)(
    Cronet_BiStreamClientPtr self,
    uint32_t stream_id,
    Cronet_String data,
    uint64_t size);
typedef void (*Cronet_BiStreamClient_CloseStreamFunc)(
    Cronet_BiStreamClientPtr self,
    uint32_t stream_id);
typedef void (*Cronet_BiStreamClient_CloseConnectionFunc)(
    Cronet_BiStreamClientPtr self);
typedef void (*Cronet_BiStreamClient_DestroyFunc)(
    Cronet_BiStreamClientPtr self);
typedef void (*Cronet_BiStreamClient_AddDelegateFunc)(
    Cronet_BiStreamClientPtr self,
    Cronet_BiStreamDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_BiStreamClient_RemoveDelegateFunc)(
    Cronet_BiStreamClientPtr self,
    Cronet_BiStreamDelegatePtr delegate);
// Concrete interface Cronet_BiStreamClient is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_BiStreamClientPtr Cronet_BiStreamClient_CreateWith(
    Cronet_BiStreamClient_CreateConnectionFunc CreateConnectionFunc,
    Cronet_BiStreamClient_CreateStreamFunc CreateStreamFunc,
    Cronet_BiStreamClient_IsConnectionReadyFunc IsConnectionReadyFunc,
    Cronet_BiStreamClient_IsStreamReadyFunc IsStreamReadyFunc,
    Cronet_BiStreamClient_SendDataFunc SendDataFunc,
    Cronet_BiStreamClient_CloseStreamFunc CloseStreamFunc,
    Cronet_BiStreamClient_CloseConnectionFunc CloseConnectionFunc,
    Cronet_BiStreamClient_DestroyFunc DestroyFunc,
    Cronet_BiStreamClient_AddDelegateFunc AddDelegateFunc,
    Cronet_BiStreamClient_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_ConnParams.
CRONET_EXPORT Cronet_ConnParamsPtr Cronet_ConnParams_Create(void);
CRONET_EXPORT void Cronet_ConnParams_Destroy(Cronet_ConnParamsPtr self);
// Cronet_ConnParams setters.
CRONET_EXPORT
void Cronet_ConnParams_host_set(Cronet_ConnParamsPtr self,
                                const Cronet_String host);
CRONET_EXPORT
void Cronet_ConnParams_port_set(Cronet_ConnParamsPtr self, const uint16_t port);
CRONET_EXPORT
void Cronet_ConnParams_mode_set(Cronet_ConnParamsPtr self,
                                const Cronet_TransportMode mode);
CRONET_EXPORT
void Cronet_ConnParams_ping_period_set(Cronet_ConnParamsPtr self,
                                       const uint32_t ping_period);
CRONET_EXPORT
void Cronet_ConnParams_timeout_set(Cronet_ConnParamsPtr self,
                                   const uint32_t timeout);
CRONET_EXPORT
void Cronet_ConnParams_auto_rebuild_set(Cronet_ConnParamsPtr self,
                                        const bool auto_rebuild);
CRONET_EXPORT
void Cronet_ConnParams_proxy_set(Cronet_ConnParamsPtr self, const bool proxy);
CRONET_EXPORT
void Cronet_ConnParams_load_flags_set(Cronet_ConnParamsPtr self,
                                      const Cronet_REQUEST_FLAGS load_flags);
// Cronet_ConnParams getters.
CRONET_EXPORT
Cronet_String Cronet_ConnParams_host_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
uint16_t Cronet_ConnParams_port_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
Cronet_TransportMode Cronet_ConnParams_mode_get(
    const Cronet_ConnParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_ConnParams_ping_period_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_ConnParams_timeout_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
bool Cronet_ConnParams_auto_rebuild_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
bool Cronet_ConnParams_proxy_get(const Cronet_ConnParamsPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_ConnParams_load_flags_get(
    const Cronet_ConnParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_BIS_IDL_C_H_
