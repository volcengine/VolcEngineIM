// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_frontier.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_IDL_C_H_
#include "cronet_bis.idl_c.h"
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_FrontierSDKDelegate Cronet_FrontierSDKDelegate;
typedef struct Cronet_FrontierSDKDelegate* Cronet_FrontierSDKDelegatePtr;
typedef struct Cronet_FrontierDelegate Cronet_FrontierDelegate;
typedef struct Cronet_FrontierDelegate* Cronet_FrontierDelegatePtr;
typedef struct Cronet_FrontierClient Cronet_FrontierClient;
typedef struct Cronet_FrontierClient* Cronet_FrontierClientPtr;

// Forward declare structs.
typedef struct Cronet_FrontierParams Cronet_FrontierParams;
typedef struct Cronet_FrontierParams* Cronet_FrontierParamsPtr;

// Declare enums
typedef enum Cronet_FrontierSDKDelegate_ConnectionState {
  Cronet_FrontierSDKDelegate_ConnectionState_ConnectUnknown = 0,
  Cronet_FrontierSDKDelegate_ConnectionState_Connecting,
  Cronet_FrontierSDKDelegate_ConnectionState_Connected,
  Cronet_FrontierSDKDelegate_ConnectionState_ConnectFailed,
  Cronet_FrontierSDKDelegate_ConnectionState_ConnectClosed,
  Cronet_FrontierSDKDelegate_ConnectionState_Disconnecting,
} Cronet_FrontierSDKDelegate_ConnectionState;

// Declare constants

///////////////////////
// Abstract interface Cronet_FrontierSDKDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_FrontierSDKDelegate.
CRONET_EXPORT void Cronet_FrontierSDKDelegate_Destroy(
    Cronet_FrontierSDKDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_FrontierSDKDelegate_SetClientContext(
    Cronet_FrontierSDKDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_FrontierSDKDelegate_GetClientContext(Cronet_FrontierSDKDelegatePtr self);
// Abstract interface Cronet_FrontierSDKDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_FrontierSDKDelegate_OnConnectionStateChange(
    Cronet_FrontierSDKDelegatePtr self,
    Cronet_FrontierSDKDelegate_ConnectionState state);
// The app implements abstract interface Cronet_FrontierSDKDelegate by defining
// custom functions for each method.
typedef void (*Cronet_FrontierSDKDelegate_OnConnectionStateChangeFunc)(
    Cronet_FrontierSDKDelegatePtr self,
    Cronet_FrontierSDKDelegate_ConnectionState state);
// The app creates an instance of Cronet_FrontierSDKDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_FrontierSDKDelegatePtr
Cronet_FrontierSDKDelegate_CreateWith(
    Cronet_FrontierSDKDelegate_OnConnectionStateChangeFunc
        OnConnectionStateChangeFunc);

///////////////////////
// Abstract interface Cronet_FrontierDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_FrontierDelegate.
CRONET_EXPORT void Cronet_FrontierDelegate_Destroy(
    Cronet_FrontierDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_FrontierDelegate_SetClientContext(
    Cronet_FrontierDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_FrontierDelegate_GetClientContext(Cronet_FrontierDelegatePtr self);
// Abstract interface Cronet_FrontierDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_FrontierDelegate_OnConnectionReady(Cronet_FrontierDelegatePtr self,
                                               Cronet_String extra_info);
CRONET_EXPORT
void Cronet_FrontierDelegate_OnStreamReady(Cronet_FrontierDelegatePtr self,
                                           uint32_t stream_id,
                                           Cronet_String extra_info);
CRONET_EXPORT
void Cronet_FrontierDelegate_OnError(Cronet_FrontierDelegatePtr self,
                                     uint32_t stream_id,
                                     int32_t error,
                                     Cronet_String extra_info);
CRONET_EXPORT
void Cronet_FrontierDelegate_OnReceivedMessage(Cronet_FrontierDelegatePtr self,
                                               uint32_t stream_id,
                                               Cronet_String meta,
                                               uint64_t meta_size,
                                               Cronet_String message,
                                               uint64_t size,
                                               bool fin);
CRONET_EXPORT
void Cronet_FrontierDelegate_OnReceivedAck(Cronet_FrontierDelegatePtr self,
                                           uint32_t stream_id,
                                           uint32_t message_id,
                                           Cronet_String extra_info,
                                           bool fin);
CRONET_EXPORT
void Cronet_FrontierDelegate_OnReceivedAckWithMeta(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    uint32_t message_id,
    Cronet_String meta,
    uint64_t meta_size,
    Cronet_String extra_info,
    bool fin);
// The app implements abstract interface Cronet_FrontierDelegate by defining
// custom functions for each method.
typedef void (*Cronet_FrontierDelegate_OnConnectionReadyFunc)(
    Cronet_FrontierDelegatePtr self,
    Cronet_String extra_info);
typedef void (*Cronet_FrontierDelegate_OnStreamReadyFunc)(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    Cronet_String extra_info);
typedef void (*Cronet_FrontierDelegate_OnErrorFunc)(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    int32_t error,
    Cronet_String extra_info);
typedef void (*Cronet_FrontierDelegate_OnReceivedMessageFunc)(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    Cronet_String meta,
    uint64_t meta_size,
    Cronet_String message,
    uint64_t size,
    bool fin);
typedef void (*Cronet_FrontierDelegate_OnReceivedAckFunc)(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    uint32_t message_id,
    Cronet_String extra_info,
    bool fin);
typedef void (*Cronet_FrontierDelegate_OnReceivedAckWithMetaFunc)(
    Cronet_FrontierDelegatePtr self,
    uint32_t stream_id,
    uint32_t message_id,
    Cronet_String meta,
    uint64_t meta_size,
    Cronet_String extra_info,
    bool fin);
// The app creates an instance of Cronet_FrontierDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_FrontierDelegatePtr Cronet_FrontierDelegate_CreateWith(
    Cronet_FrontierDelegate_OnConnectionReadyFunc OnConnectionReadyFunc,
    Cronet_FrontierDelegate_OnStreamReadyFunc OnStreamReadyFunc,
    Cronet_FrontierDelegate_OnErrorFunc OnErrorFunc,
    Cronet_FrontierDelegate_OnReceivedMessageFunc OnReceivedMessageFunc,
    Cronet_FrontierDelegate_OnReceivedAckFunc OnReceivedAckFunc,
    Cronet_FrontierDelegate_OnReceivedAckWithMetaFunc
        OnReceivedAckWithMetaFunc);

///////////////////////
// Concrete interface Cronet_FrontierClient.

// Create an instance of Cronet_FrontierClient.
CRONET_EXPORT Cronet_FrontierClientPtr Cronet_FrontierClient_Create(void);
// Destroy an instance of Cronet_FrontierClient.
CRONET_EXPORT void Cronet_FrontierClient_Destroy(Cronet_FrontierClientPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_FrontierClient_SetClientContext(
    Cronet_FrontierClientPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_FrontierClient_GetClientContext(Cronet_FrontierClientPtr self);
// Concrete methods of Cronet_FrontierClient implemented by Cronet.
// The app calls them to manipulate Cronet_FrontierClient.
CRONET_EXPORT
void Cronet_FrontierClient_ConfigClient(Cronet_FrontierClientPtr self,
                                        Cronet_FrontierParamsPtr params);
CRONET_EXPORT
void Cronet_FrontierClient_CreateConnection(Cronet_FrontierClientPtr self,
                                            Cronet_ConnParamsPtr params);
CRONET_EXPORT
uint32_t Cronet_FrontierClient_CreateStream(Cronet_FrontierClientPtr self,
                                            Cronet_BiStreamPriority priority,
                                            Cronet_String meta_data,
                                            uint64_t meta_size,
                                            Cronet_String early_data,
                                            uint64_t early_size);
CRONET_EXPORT
bool Cronet_FrontierClient_IsConnectionReady(Cronet_FrontierClientPtr self);
CRONET_EXPORT
bool Cronet_FrontierClient_IsStreamReady(Cronet_FrontierClientPtr self,
                                         uint32_t stream_id);
CRONET_EXPORT
uint32_t Cronet_FrontierClient_SendMessage(Cronet_FrontierClientPtr self,
                                           uint32_t stream_id,
                                           Cronet_String meta_data,
                                           uint64_t meta_size,
                                           Cronet_String message,
                                           uint64_t size);
CRONET_EXPORT
void Cronet_FrontierClient_UpdatePriority(Cronet_FrontierClientPtr self,
                                          uint32_t stream_id,
                                          Cronet_BiStreamPriority priority);
CRONET_EXPORT
void Cronet_FrontierClient_CloseStream(Cronet_FrontierClientPtr self,
                                       uint32_t stream_id);
CRONET_EXPORT
void Cronet_FrontierClient_CloseConnection(Cronet_FrontierClientPtr self);
CRONET_EXPORT
void Cronet_FrontierClient_SendAppStateChangeMessage(
    Cronet_FrontierClientPtr self,
    bool is_background);
CRONET_EXPORT
void Cronet_FrontierClient_Destroy(Cronet_FrontierClientPtr self);
CRONET_EXPORT
void Cronet_FrontierClient_AddDelegate(Cronet_FrontierClientPtr self,
                                       Cronet_FrontierDelegatePtr delegate,
                                       Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_FrontierClient_RemoveDelegate(Cronet_FrontierClientPtr self,
                                          Cronet_FrontierDelegatePtr delegate);
CRONET_EXPORT
void Cronet_FrontierClient_AddFrontierSDKDelegate(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierSDKDelegatePtr delegate);
CRONET_EXPORT
void Cronet_FrontierClient_RemoveFrontierSDKDelegate(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierSDKDelegatePtr delegate);
// Concrete interface Cronet_FrontierClient is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_FrontierClient_ConfigClientFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierParamsPtr params);
typedef void (*Cronet_FrontierClient_CreateConnectionFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_ConnParamsPtr params);
typedef uint32_t (*Cronet_FrontierClient_CreateStreamFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_BiStreamPriority priority,
    Cronet_String meta_data,
    uint64_t meta_size,
    Cronet_String early_data,
    uint64_t early_size);
typedef bool (*Cronet_FrontierClient_IsConnectionReadyFunc)(
    Cronet_FrontierClientPtr self);
typedef bool (*Cronet_FrontierClient_IsStreamReadyFunc)(
    Cronet_FrontierClientPtr self,
    uint32_t stream_id);
typedef uint32_t (*Cronet_FrontierClient_SendMessageFunc)(
    Cronet_FrontierClientPtr self,
    uint32_t stream_id,
    Cronet_String meta_data,
    uint64_t meta_size,
    Cronet_String message,
    uint64_t size);
typedef void (*Cronet_FrontierClient_UpdatePriorityFunc)(
    Cronet_FrontierClientPtr self,
    uint32_t stream_id,
    Cronet_BiStreamPriority priority);
typedef void (*Cronet_FrontierClient_CloseStreamFunc)(
    Cronet_FrontierClientPtr self,
    uint32_t stream_id);
typedef void (*Cronet_FrontierClient_CloseConnectionFunc)(
    Cronet_FrontierClientPtr self);
typedef void (*Cronet_FrontierClient_SendAppStateChangeMessageFunc)(
    Cronet_FrontierClientPtr self,
    bool is_background);
typedef void (*Cronet_FrontierClient_DestroyFunc)(
    Cronet_FrontierClientPtr self);
typedef void (*Cronet_FrontierClient_AddDelegateFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_FrontierClient_RemoveDelegateFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierDelegatePtr delegate);
typedef void (*Cronet_FrontierClient_AddFrontierSDKDelegateFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierSDKDelegatePtr delegate);
typedef void (*Cronet_FrontierClient_RemoveFrontierSDKDelegateFunc)(
    Cronet_FrontierClientPtr self,
    Cronet_FrontierSDKDelegatePtr delegate);
// Concrete interface Cronet_FrontierClient is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_FrontierClientPtr Cronet_FrontierClient_CreateWith(
    Cronet_FrontierClient_ConfigClientFunc ConfigClientFunc,
    Cronet_FrontierClient_CreateConnectionFunc CreateConnectionFunc,
    Cronet_FrontierClient_CreateStreamFunc CreateStreamFunc,
    Cronet_FrontierClient_IsConnectionReadyFunc IsConnectionReadyFunc,
    Cronet_FrontierClient_IsStreamReadyFunc IsStreamReadyFunc,
    Cronet_FrontierClient_SendMessageFunc SendMessageFunc,
    Cronet_FrontierClient_UpdatePriorityFunc UpdatePriorityFunc,
    Cronet_FrontierClient_CloseStreamFunc CloseStreamFunc,
    Cronet_FrontierClient_CloseConnectionFunc CloseConnectionFunc,
    Cronet_FrontierClient_SendAppStateChangeMessageFunc
        SendAppStateChangeMessageFunc,
    Cronet_FrontierClient_DestroyFunc DestroyFunc,
    Cronet_FrontierClient_AddDelegateFunc AddDelegateFunc,
    Cronet_FrontierClient_RemoveDelegateFunc RemoveDelegateFunc,
    Cronet_FrontierClient_AddFrontierSDKDelegateFunc AddFrontierSDKDelegateFunc,
    Cronet_FrontierClient_RemoveFrontierSDKDelegateFunc
        RemoveFrontierSDKDelegateFunc);

///////////////////////
// Struct Cronet_FrontierParams.
CRONET_EXPORT Cronet_FrontierParamsPtr Cronet_FrontierParams_Create(void);
CRONET_EXPORT void Cronet_FrontierParams_Destroy(Cronet_FrontierParamsPtr self);
// Cronet_FrontierParams setters.
CRONET_EXPORT
void Cronet_FrontierParams_report_app_state_set(Cronet_FrontierParamsPtr self,
                                                const bool report_app_state);
CRONET_EXPORT
void Cronet_FrontierParams_reply_frontier_ack_set(
    Cronet_FrontierParamsPtr self,
    const bool reply_frontier_ack);
CRONET_EXPORT
void Cronet_FrontierParams_callback_set(Cronet_FrontierParamsPtr self,
                                        const Cronet_RawDataPtr callback);
// Cronet_FrontierParams getters.
CRONET_EXPORT
bool Cronet_FrontierParams_report_app_state_get(
    const Cronet_FrontierParamsPtr self);
CRONET_EXPORT
bool Cronet_FrontierParams_reply_frontier_ack_get(
    const Cronet_FrontierParamsPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_FrontierParams_callback_get(
    const Cronet_FrontierParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_IDL_C_H_
