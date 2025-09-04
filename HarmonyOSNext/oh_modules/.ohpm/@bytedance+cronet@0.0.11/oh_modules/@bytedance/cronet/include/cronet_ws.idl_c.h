// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from components/cronet/native/generated/cronet_ws.idl
 */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_WS_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_WS_IDL_C_H_
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
typedef struct Cronet_FrontierMessageHandler Cronet_FrontierMessageHandler;
typedef struct Cronet_FrontierMessageHandler* Cronet_FrontierMessageHandlerPtr;
typedef struct Cronet_WSClientDelegate Cronet_WSClientDelegate;
typedef struct Cronet_WSClientDelegate* Cronet_WSClientDelegatePtr;
typedef struct Cronet_WSClient Cronet_WSClient;
typedef struct Cronet_WSClient* Cronet_WSClientPtr;

// Forward declare structs.
typedef struct Cronet_FrontierMessageHeader Cronet_FrontierMessageHeader;
typedef struct Cronet_FrontierMessageHeader* Cronet_FrontierMessageHeaderPtr;
typedef struct Cronet_FrontierMessage Cronet_FrontierMessage;
typedef struct Cronet_FrontierMessage* Cronet_FrontierMessagePtr;
typedef struct Cronet_WSClientConnectionParams Cronet_WSClientConnectionParams;
typedef struct Cronet_WSClientConnectionParams*
    Cronet_WSClientConnectionParamsPtr;

// Declare enums
typedef enum Cronet_WSClientConnectionMode {
  Cronet_WSClientConnectionMode_CONNECTION_FRONTIER = 0,
  Cronet_WSClientConnectionMode_CONNECTION_WSCHANNEL,
} Cronet_WSClientConnectionMode;

typedef enum Cronet_WSClientMode {
  Cronet_WSClientMode_Stop,
  Cronet_WSClientMode_Run,
  Cronet_WSClientMode_RunAndKeepAlive,
} Cronet_WSClientMode;

typedef enum Cronet_WSClientDelegate_ConnectionState {
  Cronet_WSClientDelegate_ConnectionState_ConnectUnknown = -1,
  Cronet_WSClientDelegate_ConnectionState_Connecting,
  Cronet_WSClientDelegate_ConnectionState_Disconnecting,
  Cronet_WSClientDelegate_ConnectionState_ConnectFailed,
  Cronet_WSClientDelegate_ConnectionState_ConnectClosed,
  Cronet_WSClientDelegate_ConnectionState_Connected,
} Cronet_WSClientDelegate_ConnectionState;

// Declare constants

///////////////////////
// Concrete interface Cronet_FrontierMessageHandler.

// Create an instance of Cronet_FrontierMessageHandler.
CRONET_EXPORT Cronet_FrontierMessageHandlerPtr
Cronet_FrontierMessageHandler_Create(void);
// Destroy an instance of Cronet_FrontierMessageHandler.
CRONET_EXPORT void Cronet_FrontierMessageHandler_Destroy(
    Cronet_FrontierMessageHandlerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_FrontierMessageHandler_SetClientContext(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_FrontierMessageHandler_GetClientContext(
    Cronet_FrontierMessageHandlerPtr self);
// Concrete methods of Cronet_FrontierMessageHandler implemented by Cronet.
// The app calls them to manipulate Cronet_FrontierMessageHandler.
CRONET_EXPORT
void Cronet_FrontierMessageHandler_Encode(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_FrontierMessagePtr frontier_data);
CRONET_EXPORT
void Cronet_FrontierMessageHandler_EncodeWithPayload(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_FrontierMessagePtr frontier_data,
    Cronet_String payload,
    uint64_t size);
CRONET_EXPORT
uint64_t Cronet_FrontierMessageHandler_GetPbSize(
    Cronet_FrontierMessageHandlerPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierMessageHandler_GetPbData(
    Cronet_FrontierMessageHandlerPtr self);
CRONET_EXPORT
Cronet_FrontierMessagePtr Cronet_FrontierMessageHandler_Decode(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_String data,
    uint64_t size);
// Concrete interface Cronet_FrontierMessageHandler is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_FrontierMessageHandler_EncodeFunc)(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_FrontierMessagePtr frontier_data);
typedef void (*Cronet_FrontierMessageHandler_EncodeWithPayloadFunc)(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_FrontierMessagePtr frontier_data,
    Cronet_String payload,
    uint64_t size);
typedef uint64_t (*Cronet_FrontierMessageHandler_GetPbSizeFunc)(
    Cronet_FrontierMessageHandlerPtr self);
typedef Cronet_String (*Cronet_FrontierMessageHandler_GetPbDataFunc)(
    Cronet_FrontierMessageHandlerPtr self);
typedef Cronet_FrontierMessagePtr (*Cronet_FrontierMessageHandler_DecodeFunc)(
    Cronet_FrontierMessageHandlerPtr self,
    Cronet_String data,
    uint64_t size);
// Concrete interface Cronet_FrontierMessageHandler is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_FrontierMessageHandlerPtr
Cronet_FrontierMessageHandler_CreateWith(
    Cronet_FrontierMessageHandler_EncodeFunc EncodeFunc,
    Cronet_FrontierMessageHandler_EncodeWithPayloadFunc EncodeWithPayloadFunc,
    Cronet_FrontierMessageHandler_GetPbSizeFunc GetPbSizeFunc,
    Cronet_FrontierMessageHandler_GetPbDataFunc GetPbDataFunc,
    Cronet_FrontierMessageHandler_DecodeFunc DecodeFunc);

///////////////////////
// Abstract interface Cronet_WSClientDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_WSClientDelegate.
CRONET_EXPORT void Cronet_WSClientDelegate_Destroy(
    Cronet_WSClientDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_WSClientDelegate_SetClientContext(
    Cronet_WSClientDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_WSClientDelegate_GetClientContext(Cronet_WSClientDelegatePtr self);
// Abstract interface Cronet_WSClientDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_WSClientDelegate_OnConnectionStateChanged(
    Cronet_WSClientDelegatePtr self,
    Cronet_WSClientDelegate_ConnectionState state,
    Cronet_String url);
CRONET_EXPORT
void Cronet_WSClientDelegate_OnConnectionError(
    Cronet_WSClientDelegatePtr self,
    Cronet_WSClientDelegate_ConnectionState state,
    Cronet_String url,
    Cronet_String error);
CRONET_EXPORT
void Cronet_WSClientDelegate_OnMessageReceived(Cronet_WSClientDelegatePtr self,
                                               Cronet_String message,
                                               uint64_t size);
CRONET_EXPORT
void Cronet_WSClientDelegate_OnFeedbackLog(Cronet_WSClientDelegatePtr self,
                                           Cronet_String log);
CRONET_EXPORT
void Cronet_WSClientDelegate_OnTrafficChanged(Cronet_WSClientDelegatePtr self,
                                              Cronet_String url,
                                              int64_t sent_bytes,
                                              int64_t received_bytes);
// The app implements abstract interface Cronet_WSClientDelegate by defining
// custom functions for each method.
typedef void (*Cronet_WSClientDelegate_OnConnectionStateChangedFunc)(
    Cronet_WSClientDelegatePtr self,
    Cronet_WSClientDelegate_ConnectionState state,
    Cronet_String url);
typedef void (*Cronet_WSClientDelegate_OnConnectionErrorFunc)(
    Cronet_WSClientDelegatePtr self,
    Cronet_WSClientDelegate_ConnectionState state,
    Cronet_String url,
    Cronet_String error);
typedef void (*Cronet_WSClientDelegate_OnMessageReceivedFunc)(
    Cronet_WSClientDelegatePtr self,
    Cronet_String message,
    uint64_t size);
typedef void (*Cronet_WSClientDelegate_OnFeedbackLogFunc)(
    Cronet_WSClientDelegatePtr self,
    Cronet_String log);
typedef void (*Cronet_WSClientDelegate_OnTrafficChangedFunc)(
    Cronet_WSClientDelegatePtr self,
    Cronet_String url,
    int64_t sent_bytes,
    int64_t received_bytes);
// The app creates an instance of Cronet_WSClientDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_WSClientDelegatePtr Cronet_WSClientDelegate_CreateWith(
    Cronet_WSClientDelegate_OnConnectionStateChangedFunc
        OnConnectionStateChangedFunc,
    Cronet_WSClientDelegate_OnConnectionErrorFunc OnConnectionErrorFunc,
    Cronet_WSClientDelegate_OnMessageReceivedFunc OnMessageReceivedFunc,
    Cronet_WSClientDelegate_OnFeedbackLogFunc OnFeedbackLogFunc,
    Cronet_WSClientDelegate_OnTrafficChangedFunc OnTrafficChangedFunc);

///////////////////////
// Concrete interface Cronet_WSClient.

// Create an instance of Cronet_WSClient.
CRONET_EXPORT Cronet_WSClientPtr Cronet_WSClient_Create(void);
// Destroy an instance of Cronet_WSClient.
CRONET_EXPORT void Cronet_WSClient_Destroy(Cronet_WSClientPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_WSClient_SetClientContext(
    Cronet_WSClientPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_WSClient_GetClientContext(Cronet_WSClientPtr self);
// Concrete methods of Cronet_WSClient implemented by Cronet.
// The app calls them to manipulate Cronet_WSClient.
CRONET_EXPORT
void Cronet_WSClient_SetupMode(Cronet_WSClientPtr self, Cronet_WSClientMode m);
CRONET_EXPORT
void Cronet_WSClient_ConfigConnection(
    Cronet_WSClientPtr self,
    Cronet_WSClientConnectionParamsPtr params);
CRONET_EXPORT
void Cronet_WSClient_StartConnection(Cronet_WSClientPtr self);
CRONET_EXPORT
void Cronet_WSClient_StopConnection(Cronet_WSClientPtr self);
CRONET_EXPORT
bool Cronet_WSClient_IsConnected(Cronet_WSClientPtr self);
CRONET_EXPORT
bool Cronet_WSClient_ChangeConnectionTimeout(Cronet_WSClientPtr self,
                                             int32_t timeout);
CRONET_EXPORT
void Cronet_WSClient_AsyncSendBinary(Cronet_WSClientPtr self,
                                     Cronet_String data,
                                     uint64_t size);
CRONET_EXPORT
void Cronet_WSClient_AsyncSendText(Cronet_WSClientPtr self,
                                   Cronet_String text,
                                   uint64_t size);
CRONET_EXPORT
void Cronet_WSClient_AddDelegate(Cronet_WSClientPtr self,
                                 Cronet_WSClientDelegatePtr delegate,
                                 Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_WSClient_RemoveDelegate(Cronet_WSClientPtr self,
                                    Cronet_WSClientDelegatePtr delegate);
// Concrete interface Cronet_WSClient is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_WSClient_SetupModeFunc)(Cronet_WSClientPtr self,
                                              Cronet_WSClientMode m);
typedef void (*Cronet_WSClient_ConfigConnectionFunc)(
    Cronet_WSClientPtr self,
    Cronet_WSClientConnectionParamsPtr params);
typedef void (*Cronet_WSClient_StartConnectionFunc)(Cronet_WSClientPtr self);
typedef void (*Cronet_WSClient_StopConnectionFunc)(Cronet_WSClientPtr self);
typedef void (*Cronet_WSClient_DestroyFunc)(Cronet_WSClientPtr self);
typedef bool (*Cronet_WSClient_IsConnectedFunc)(Cronet_WSClientPtr self);
typedef bool (*Cronet_WSClient_ChangeConnectionTimeoutFunc)(
    Cronet_WSClientPtr self,
    int32_t timeout);
typedef void (*Cronet_WSClient_AsyncSendBinaryFunc)(Cronet_WSClientPtr self,
                                                    Cronet_String data,
                                                    uint64_t size);
typedef void (*Cronet_WSClient_AsyncSendTextFunc)(Cronet_WSClientPtr self,
                                                  Cronet_String text,
                                                  uint64_t size);
typedef void (*Cronet_WSClient_AddDelegateFunc)(
    Cronet_WSClientPtr self,
    Cronet_WSClientDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_WSClient_RemoveDelegateFunc)(
    Cronet_WSClientPtr self,
    Cronet_WSClientDelegatePtr delegate);
// Concrete interface Cronet_WSClient is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_WSClientPtr Cronet_WSClient_CreateWith(
    Cronet_WSClient_SetupModeFunc SetupModeFunc,
    Cronet_WSClient_ConfigConnectionFunc ConfigConnectionFunc,
    Cronet_WSClient_StartConnectionFunc StartConnectionFunc,
    Cronet_WSClient_StopConnectionFunc StopConnectionFunc,
    Cronet_WSClient_DestroyFunc DestroyFunc,
    Cronet_WSClient_IsConnectedFunc IsConnectedFunc,
    Cronet_WSClient_ChangeConnectionTimeoutFunc ChangeConnectionTimeoutFunc,
    Cronet_WSClient_AsyncSendBinaryFunc AsyncSendBinaryFunc,
    Cronet_WSClient_AsyncSendTextFunc AsyncSendTextFunc,
    Cronet_WSClient_AddDelegateFunc AddDelegateFunc,
    Cronet_WSClient_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_FrontierMessageHeader.
CRONET_EXPORT Cronet_FrontierMessageHeaderPtr
Cronet_FrontierMessageHeader_Create(void);
CRONET_EXPORT void Cronet_FrontierMessageHeader_Destroy(
    Cronet_FrontierMessageHeaderPtr self);
// Cronet_FrontierMessageHeader setters.
CRONET_EXPORT
void Cronet_FrontierMessageHeader_key_set(Cronet_FrontierMessageHeaderPtr self,
                                          const Cronet_String key);
CRONET_EXPORT
void Cronet_FrontierMessageHeader_value_set(
    Cronet_FrontierMessageHeaderPtr self,
    const Cronet_String value);
// Cronet_FrontierMessageHeader getters.
CRONET_EXPORT
Cronet_String Cronet_FrontierMessageHeader_key_get(
    const Cronet_FrontierMessageHeaderPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierMessageHeader_value_get(
    const Cronet_FrontierMessageHeaderPtr self);

///////////////////////
// Struct Cronet_FrontierMessage.
CRONET_EXPORT Cronet_FrontierMessagePtr Cronet_FrontierMessage_Create(void);
CRONET_EXPORT void Cronet_FrontierMessage_Destroy(
    Cronet_FrontierMessagePtr self);
// Cronet_FrontierMessage setters.
CRONET_EXPORT
void Cronet_FrontierMessage_seqid_set(Cronet_FrontierMessagePtr self,
                                      const uint64_t seqid);
CRONET_EXPORT
void Cronet_FrontierMessage_logid_set(Cronet_FrontierMessagePtr self,
                                      const uint64_t logid);
CRONET_EXPORT
void Cronet_FrontierMessage_service_set(Cronet_FrontierMessagePtr self,
                                        const int32_t service);
CRONET_EXPORT
void Cronet_FrontierMessage_method_set(Cronet_FrontierMessagePtr self,
                                       const int32_t method);
CRONET_EXPORT
void Cronet_FrontierMessage_payload_type_set(Cronet_FrontierMessagePtr self,
                                             const Cronet_String payload_type);
CRONET_EXPORT
void Cronet_FrontierMessage_payload_encoding_set(
    Cronet_FrontierMessagePtr self,
    const Cronet_String payload_encoding);
CRONET_EXPORT
void Cronet_FrontierMessage_payload_set(Cronet_FrontierMessagePtr self,
                                        const Cronet_String payload);
CRONET_EXPORT
void Cronet_FrontierMessage_payload_size_set(Cronet_FrontierMessagePtr self,
                                             const uint64_t payload_size);
CRONET_EXPORT
void Cronet_FrontierMessage_headers_add(
    Cronet_FrontierMessagePtr self,
    const Cronet_FrontierMessageHeaderPtr element);
// Cronet_FrontierMessage getters.
CRONET_EXPORT
uint64_t Cronet_FrontierMessage_seqid_get(const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
uint64_t Cronet_FrontierMessage_logid_get(const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
int32_t Cronet_FrontierMessage_service_get(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
int32_t Cronet_FrontierMessage_method_get(const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierMessage_payload_type_get(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierMessage_payload_encoding_get(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierMessage_payload_get(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
uint64_t Cronet_FrontierMessage_payload_size_get(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
uint32_t Cronet_FrontierMessage_headers_size(
    const Cronet_FrontierMessagePtr self);
CRONET_EXPORT
Cronet_FrontierMessageHeaderPtr Cronet_FrontierMessage_headers_at(
    const Cronet_FrontierMessagePtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_FrontierMessage_headers_clear(Cronet_FrontierMessagePtr self);

///////////////////////
// Struct Cronet_WSClientConnectionParams.
CRONET_EXPORT Cronet_WSClientConnectionParamsPtr
Cronet_WSClientConnectionParams_Create(void);
CRONET_EXPORT void Cronet_WSClientConnectionParams_Destroy(
    Cronet_WSClientConnectionParamsPtr self);
// Cronet_WSClientConnectionParams setters.
CRONET_EXPORT
void Cronet_WSClientConnectionParams_urls_add(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String element);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_appKey_set(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String appKey);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_appId_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t appId);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_deviceId_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int64_t deviceId);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_fpid_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t fpid);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_sdkVersion_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t sdkVersion);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_appVersion_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t appVersion);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_installId_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int64_t installId);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_sessionId_set(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String sessionId);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_webId_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int64_t webId);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_platform_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t platform);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_network_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t network);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_appToken_set(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String appToken);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_appStateReportEnabled_set(
    Cronet_WSClientConnectionParamsPtr self,
    const bool appStateReportEnabled);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_customParams_add(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String element);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_customHeaders_add(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_String element);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_sharedConnection_set(
    Cronet_WSClientConnectionParamsPtr self,
    const bool sharedConnection);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_mode_set(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_WSClientConnectionMode mode);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_timeout_set(
    Cronet_WSClientConnectionParamsPtr self,
    const int32_t timeout);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_ignoreOfflineState_set(
    Cronet_WSClientConnectionParamsPtr self,
    const bool ignoreOfflineState);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_load_flags_set(
    Cronet_WSClientConnectionParamsPtr self,
    const Cronet_REQUEST_FLAGS load_flags);
// Cronet_WSClientConnectionParams getters.
CRONET_EXPORT
uint32_t Cronet_WSClientConnectionParams_urls_size(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_urls_at(
    const Cronet_WSClientConnectionParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_urls_clear(
    Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_appKey_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_appId_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int64_t Cronet_WSClientConnectionParams_deviceId_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_fpid_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_sdkVersion_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_appVersion_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int64_t Cronet_WSClientConnectionParams_installId_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_sessionId_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int64_t Cronet_WSClientConnectionParams_webId_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_platform_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_network_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_appToken_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
bool Cronet_WSClientConnectionParams_appStateReportEnabled_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_WSClientConnectionParams_customParams_size(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_customParams_at(
    const Cronet_WSClientConnectionParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_customParams_clear(
    Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_WSClientConnectionParams_customHeaders_size(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_WSClientConnectionParams_customHeaders_at(
    const Cronet_WSClientConnectionParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_WSClientConnectionParams_customHeaders_clear(
    Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
bool Cronet_WSClientConnectionParams_sharedConnection_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_WSClientConnectionMode Cronet_WSClientConnectionParams_mode_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
int32_t Cronet_WSClientConnectionParams_timeout_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
bool Cronet_WSClientConnectionParams_ignoreOfflineState_get(
    const Cronet_WSClientConnectionParamsPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_WSClientConnectionParams_load_flags_get(
    const Cronet_WSClientConnectionParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_WS_IDL_C_H_
