// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_frontier_sdk.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_SDK_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_SDK_IDL_C_H_
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
typedef struct Cronet_ServiceDelegate Cronet_ServiceDelegate;
typedef struct Cronet_ServiceDelegate* Cronet_ServiceDelegatePtr;
typedef struct Cronet_AuthDelegate Cronet_AuthDelegate;
typedef struct Cronet_AuthDelegate* Cronet_AuthDelegatePtr;
typedef struct Cronet_FrontierClientSDK Cronet_FrontierClientSDK;
typedef struct Cronet_FrontierClientSDK* Cronet_FrontierClientSDKPtr;

// Forward declare structs.
typedef struct Cronet_KvPair Cronet_KvPair;
typedef struct Cronet_KvPair* Cronet_KvPairPtr;
typedef struct Cronet_PairInfo Cronet_PairInfo;
typedef struct Cronet_PairInfo* Cronet_PairInfoPtr;
typedef struct Cronet_FrontierConfig Cronet_FrontierConfig;
typedef struct Cronet_FrontierConfig* Cronet_FrontierConfigPtr;
typedef struct Cronet_ServiceInfo Cronet_ServiceInfo;
typedef struct Cronet_ServiceInfo* Cronet_ServiceInfoPtr;

// Declare enums
typedef enum Cronet_FrontierTransportMode {
  Cronet_FrontierTransportMode_T_UNKNOWN = -1,
  Cronet_FrontierTransportMode_T_UDP = 0,
  Cronet_FrontierTransportMode_T_TLS = 1,
  Cronet_FrontierTransportMode_T_HTTP2 = 2,
  Cronet_FrontierTransportMode_T_SPDY = 3,
} Cronet_FrontierTransportMode;

typedef enum Cronet_Platform {
  Cronet_Platform_WEB = 0,
  Cronet_Platform_ANDROID = 1,
  Cronet_Platform_IOS = 2,
  Cronet_Platform_MAC = 3,
  Cronet_Platform_WIN = 4,
  Cronet_Platform_IPAD = 5,
  Cronet_Platform_LINUX = 6,
  Cronet_Platform_H5 = 7,
} Cronet_Platform;

typedef enum Cronet_ServicePriority {
  Cronet_ServicePriority_P_LOW = 0,
  Cronet_ServicePriority_P_MEDIUM = 1,
  Cronet_ServicePriority_P_HIGH = 2,
} Cronet_ServicePriority;

// Declare constants

///////////////////////
// Abstract interface Cronet_ServiceDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_ServiceDelegate.
CRONET_EXPORT void Cronet_ServiceDelegate_Destroy(
    Cronet_ServiceDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_ServiceDelegate_SetClientContext(
    Cronet_ServiceDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_ServiceDelegate_GetClientContext(Cronet_ServiceDelegatePtr self);
// Abstract interface Cronet_ServiceDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_ServiceDelegate_OnServiceReady(Cronet_ServiceDelegatePtr self,
                                           Cronet_ServiceInfoPtr service_info,
                                           Cronet_String log_info);
CRONET_EXPORT
void Cronet_ServiceDelegate_OnError(Cronet_ServiceDelegatePtr self,
                                    Cronet_ServiceInfoPtr service_info,
                                    int32_t error,
                                    Cronet_String log_info);
CRONET_EXPORT
void Cronet_ServiceDelegate_OnReceivedMessage(
    Cronet_ServiceDelegatePtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_PairInfoPtr pair_info,
    Cronet_String message,
    uint64_t size,
    bool fin);
CRONET_EXPORT
void Cronet_ServiceDelegate_OnReceivedAck(Cronet_ServiceDelegatePtr self,
                                          Cronet_ServiceInfoPtr service_info,
                                          uint32_t message_id,
                                          Cronet_String log_info,
                                          bool fin);
// The app implements abstract interface Cronet_ServiceDelegate by defining
// custom functions for each method.
typedef void (*Cronet_ServiceDelegate_OnServiceReadyFunc)(
    Cronet_ServiceDelegatePtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_String log_info);
typedef void (*Cronet_ServiceDelegate_OnErrorFunc)(
    Cronet_ServiceDelegatePtr self,
    Cronet_ServiceInfoPtr service_info,
    int32_t error,
    Cronet_String log_info);
typedef void (*Cronet_ServiceDelegate_OnReceivedMessageFunc)(
    Cronet_ServiceDelegatePtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_PairInfoPtr pair_info,
    Cronet_String message,
    uint64_t size,
    bool fin);
typedef void (*Cronet_ServiceDelegate_OnReceivedAckFunc)(
    Cronet_ServiceDelegatePtr self,
    Cronet_ServiceInfoPtr service_info,
    uint32_t message_id,
    Cronet_String log_info,
    bool fin);
// The app creates an instance of Cronet_ServiceDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_ServiceDelegatePtr Cronet_ServiceDelegate_CreateWith(
    Cronet_ServiceDelegate_OnServiceReadyFunc OnServiceReadyFunc,
    Cronet_ServiceDelegate_OnErrorFunc OnErrorFunc,
    Cronet_ServiceDelegate_OnReceivedMessageFunc OnReceivedMessageFunc,
    Cronet_ServiceDelegate_OnReceivedAckFunc OnReceivedAckFunc);

///////////////////////
// Abstract interface Cronet_AuthDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_AuthDelegate.
CRONET_EXPORT void Cronet_AuthDelegate_Destroy(Cronet_AuthDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_AuthDelegate_SetClientContext(
    Cronet_AuthDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_AuthDelegate_GetClientContext(Cronet_AuthDelegatePtr self);
// Abstract interface Cronet_AuthDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
Cronet_PairInfoPtr Cronet_AuthDelegate_OnFetchAuthInfo(
    Cronet_AuthDelegatePtr self,
    Cronet_ServiceInfoPtr service_info);
// The app implements abstract interface Cronet_AuthDelegate by defining custom
// functions for each method.
typedef Cronet_PairInfoPtr (*Cronet_AuthDelegate_OnFetchAuthInfoFunc)(
    Cronet_AuthDelegatePtr self,
    Cronet_ServiceInfoPtr service_info);
// The app creates an instance of Cronet_AuthDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_AuthDelegatePtr Cronet_AuthDelegate_CreateWith(
    Cronet_AuthDelegate_OnFetchAuthInfoFunc OnFetchAuthInfoFunc);

///////////////////////
// Concrete interface Cronet_FrontierClientSDK.

// Create an instance of Cronet_FrontierClientSDK.
CRONET_EXPORT Cronet_FrontierClientSDKPtr Cronet_FrontierClientSDK_Create(void);
// Destroy an instance of Cronet_FrontierClientSDK.
CRONET_EXPORT void Cronet_FrontierClientSDK_Destroy(
    Cronet_FrontierClientSDKPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_FrontierClientSDK_SetClientContext(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_FrontierClientSDK_GetClientContext(Cronet_FrontierClientSDKPtr self);
// Concrete methods of Cronet_FrontierClientSDK implemented by Cronet.
// The app calls them to manipulate Cronet_FrontierClientSDK.
CRONET_EXPORT
void Cronet_FrontierClientSDK_InitWithParams(Cronet_FrontierClientSDKPtr self,
                                             Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_FrontierClientSDK_Configure(Cronet_FrontierClientSDKPtr self,
                                        Cronet_FrontierConfigPtr config);
CRONET_EXPORT
void Cronet_FrontierClientSDK_Register(Cronet_FrontierClientSDKPtr self,
                                       Cronet_ServiceInfoPtr service_info,
                                       bool lazy,
                                       Cronet_PairInfoPtr header_info,
                                       Cronet_String early_data,
                                       uint64_t size);
CRONET_EXPORT
uint32_t Cronet_FrontierClientSDK_SendMessage(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_PairInfoPtr header_info,
    Cronet_String msg,
    uint64_t size);
CRONET_EXPORT
bool Cronet_FrontierClientSDK_IsServiceReady(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info);
CRONET_EXPORT
void Cronet_FrontierClientSDK_SetMsgCursor(Cronet_FrontierClientSDKPtr self,
                                           Cronet_ServiceInfoPtr service_info,
                                           uint32_t cursor);
CRONET_EXPORT
void Cronet_FrontierClientSDK_SetMaxPacketSize(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    uint32_t max_package_size);
CRONET_EXPORT
void Cronet_FrontierClientSDK_UpdatePriority(Cronet_FrontierClientSDKPtr self,
                                             Cronet_ServiceInfoPtr service_info,
                                             Cronet_ServicePriority priority);
CRONET_EXPORT
void Cronet_FrontierClientSDK_Unregister(Cronet_FrontierClientSDKPtr self,
                                         Cronet_ServiceInfoPtr service_info);
CRONET_EXPORT
void Cronet_FrontierClientSDK_Destroy(Cronet_FrontierClientSDKPtr self);
// Concrete interface Cronet_FrontierClientSDK is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_FrontierClientSDK_InitWithParamsFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_FrontierClientSDK_ConfigureFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_FrontierConfigPtr config);
typedef void (*Cronet_FrontierClientSDK_RegisterFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    bool lazy,
    Cronet_PairInfoPtr header_info,
    Cronet_String early_data,
    uint64_t size);
typedef uint32_t (*Cronet_FrontierClientSDK_SendMessageFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_PairInfoPtr header_info,
    Cronet_String msg,
    uint64_t size);
typedef bool (*Cronet_FrontierClientSDK_IsServiceReadyFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info);
typedef void (*Cronet_FrontierClientSDK_SetMsgCursorFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    uint32_t cursor);
typedef void (*Cronet_FrontierClientSDK_SetMaxPacketSizeFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    uint32_t max_package_size);
typedef void (*Cronet_FrontierClientSDK_UpdatePriorityFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info,
    Cronet_ServicePriority priority);
typedef void (*Cronet_FrontierClientSDK_UnregisterFunc)(
    Cronet_FrontierClientSDKPtr self,
    Cronet_ServiceInfoPtr service_info);
typedef void (*Cronet_FrontierClientSDK_DestroyFunc)(
    Cronet_FrontierClientSDKPtr self);
// Concrete interface Cronet_FrontierClientSDK is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_FrontierClientSDKPtr Cronet_FrontierClientSDK_CreateWith(
    Cronet_FrontierClientSDK_InitWithParamsFunc InitWithParamsFunc,
    Cronet_FrontierClientSDK_ConfigureFunc ConfigureFunc,
    Cronet_FrontierClientSDK_RegisterFunc RegisterFunc,
    Cronet_FrontierClientSDK_SendMessageFunc SendMessageFunc,
    Cronet_FrontierClientSDK_IsServiceReadyFunc IsServiceReadyFunc,
    Cronet_FrontierClientSDK_SetMsgCursorFunc SetMsgCursorFunc,
    Cronet_FrontierClientSDK_SetMaxPacketSizeFunc SetMaxPacketSizeFunc,
    Cronet_FrontierClientSDK_UpdatePriorityFunc UpdatePriorityFunc,
    Cronet_FrontierClientSDK_UnregisterFunc UnregisterFunc,
    Cronet_FrontierClientSDK_DestroyFunc DestroyFunc);

///////////////////////
// Struct Cronet_KvPair.
CRONET_EXPORT Cronet_KvPairPtr Cronet_KvPair_Create(void);
CRONET_EXPORT void Cronet_KvPair_Destroy(Cronet_KvPairPtr self);
// Cronet_KvPair setters.
CRONET_EXPORT
void Cronet_KvPair_name_set(Cronet_KvPairPtr self, const Cronet_String name);
CRONET_EXPORT
void Cronet_KvPair_value_set(Cronet_KvPairPtr self, const Cronet_String value);
// Cronet_KvPair getters.
CRONET_EXPORT
Cronet_String Cronet_KvPair_name_get(const Cronet_KvPairPtr self);
CRONET_EXPORT
Cronet_String Cronet_KvPair_value_get(const Cronet_KvPairPtr self);

///////////////////////
// Struct Cronet_PairInfo.
CRONET_EXPORT Cronet_PairInfoPtr Cronet_PairInfo_Create(void);
CRONET_EXPORT void Cronet_PairInfo_Destroy(Cronet_PairInfoPtr self);
// Cronet_PairInfo setters.
CRONET_EXPORT
void Cronet_PairInfo_pair_info_add(Cronet_PairInfoPtr self,
                                   const Cronet_KvPairPtr element);
// Cronet_PairInfo getters.
CRONET_EXPORT
uint32_t Cronet_PairInfo_pair_info_size(const Cronet_PairInfoPtr self);
CRONET_EXPORT
Cronet_KvPairPtr Cronet_PairInfo_pair_info_at(const Cronet_PairInfoPtr self,
                                              uint32_t index);
CRONET_EXPORT
void Cronet_PairInfo_pair_info_clear(Cronet_PairInfoPtr self);

///////////////////////
// Struct Cronet_FrontierConfig.
CRONET_EXPORT Cronet_FrontierConfigPtr Cronet_FrontierConfig_Create(void);
CRONET_EXPORT void Cronet_FrontierConfig_Destroy(Cronet_FrontierConfigPtr self);
// Cronet_FrontierConfig setters.
CRONET_EXPORT
void Cronet_FrontierConfig_app_id_set(Cronet_FrontierConfigPtr self,
                                      const int32_t app_id);
CRONET_EXPORT
void Cronet_FrontierConfig_fpid_set(Cronet_FrontierConfigPtr self,
                                    const int32_t fpid);
CRONET_EXPORT
void Cronet_FrontierConfig_host_set(Cronet_FrontierConfigPtr self,
                                    const Cronet_String host);
CRONET_EXPORT
void Cronet_FrontierConfig_port_set(Cronet_FrontierConfigPtr self,
                                    const uint16_t port);
CRONET_EXPORT
void Cronet_FrontierConfig_app_version_set(Cronet_FrontierConfigPtr self,
                                           const Cronet_String app_version);
CRONET_EXPORT
void Cronet_FrontierConfig_platform_set(Cronet_FrontierConfigPtr self,
                                        const Cronet_Platform platform);
CRONET_EXPORT
void Cronet_FrontierConfig_access_token_set(Cronet_FrontierConfigPtr self,
                                            const Cronet_String access_token);
CRONET_EXPORT
void Cronet_FrontierConfig_x_tt_env_set(Cronet_FrontierConfigPtr self,
                                        const Cronet_String x_tt_env);
CRONET_EXPORT
void Cronet_FrontierConfig_device_id_set(Cronet_FrontierConfigPtr self,
                                         const Cronet_String device_id);
CRONET_EXPORT
void Cronet_FrontierConfig_mode_set(Cronet_FrontierConfigPtr self,
                                    const Cronet_FrontierTransportMode mode);
CRONET_EXPORT
void Cronet_FrontierConfig_ping_period_set(Cronet_FrontierConfigPtr self,
                                           const uint32_t ping_period);
CRONET_EXPORT
void Cronet_FrontierConfig_timeout_set(Cronet_FrontierConfigPtr self,
                                       const uint32_t timeout);
CRONET_EXPORT
void Cronet_FrontierConfig_load_flags_set(
    Cronet_FrontierConfigPtr self,
    const Cronet_REQUEST_FLAGS load_flags);
CRONET_EXPORT
void Cronet_FrontierConfig_extra_pair_set(Cronet_FrontierConfigPtr self,
                                          const Cronet_PairInfoPtr extra_pair);
// Move data from |extra_pair|. The caller retains ownership of |extra_pair| and
// must destroy it.
void Cronet_FrontierConfig_extra_pair_move(Cronet_FrontierConfigPtr self,
                                           Cronet_PairInfoPtr extra_pair);
CRONET_EXPORT
void Cronet_FrontierConfig_rebuild_set(Cronet_FrontierConfigPtr self,
                                       const bool rebuild);
CRONET_EXPORT
void Cronet_FrontierConfig_monitor_services_add(Cronet_FrontierConfigPtr self,
                                                const uint32_t element);
CRONET_EXPORT
void Cronet_FrontierConfig_proxy_set(Cronet_FrontierConfigPtr self,
                                     const bool proxy);
CRONET_EXPORT
void Cronet_FrontierConfig_query_set(Cronet_FrontierConfigPtr self,
                                     const Cronet_String query);
// Cronet_FrontierConfig getters.
CRONET_EXPORT
int32_t Cronet_FrontierConfig_app_id_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
int32_t Cronet_FrontierConfig_fpid_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_host_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
uint16_t Cronet_FrontierConfig_port_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_app_version_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_Platform Cronet_FrontierConfig_platform_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_access_token_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_x_tt_env_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_device_id_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_FrontierTransportMode Cronet_FrontierConfig_mode_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
uint32_t Cronet_FrontierConfig_ping_period_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
uint32_t Cronet_FrontierConfig_timeout_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_FrontierConfig_load_flags_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_PairInfoPtr Cronet_FrontierConfig_extra_pair_get(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
bool Cronet_FrontierConfig_rebuild_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
uint32_t Cronet_FrontierConfig_monitor_services_size(
    const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
uint32_t Cronet_FrontierConfig_monitor_services_at(
    const Cronet_FrontierConfigPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_FrontierConfig_monitor_services_clear(
    Cronet_FrontierConfigPtr self);
CRONET_EXPORT
bool Cronet_FrontierConfig_proxy_get(const Cronet_FrontierConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_FrontierConfig_query_get(
    const Cronet_FrontierConfigPtr self);

///////////////////////
// Struct Cronet_ServiceInfo.
CRONET_EXPORT Cronet_ServiceInfoPtr Cronet_ServiceInfo_Create(void);
CRONET_EXPORT void Cronet_ServiceInfo_Destroy(Cronet_ServiceInfoPtr self);
// Cronet_ServiceInfo setters.
CRONET_EXPORT
void Cronet_ServiceInfo_identity_set(Cronet_ServiceInfoPtr self,
                                     const uint32_t identity);
CRONET_EXPORT
void Cronet_ServiceInfo_sequence_set(Cronet_ServiceInfoPtr self,
                                     const bool sequence);
CRONET_EXPORT
void Cronet_ServiceInfo_priority_set(Cronet_ServiceInfoPtr self,
                                     const Cronet_ServicePriority priority);
CRONET_EXPORT
void Cronet_ServiceInfo_service_delegate_set(
    Cronet_ServiceInfoPtr self,
    const Cronet_ServiceDelegatePtr service_delegate);
CRONET_EXPORT
void Cronet_ServiceInfo_auth_delegate_set(
    Cronet_ServiceInfoPtr self,
    const Cronet_AuthDelegatePtr auth_delegate);
// Cronet_ServiceInfo getters.
CRONET_EXPORT
uint32_t Cronet_ServiceInfo_identity_get(const Cronet_ServiceInfoPtr self);
CRONET_EXPORT
bool Cronet_ServiceInfo_sequence_get(const Cronet_ServiceInfoPtr self);
CRONET_EXPORT
Cronet_ServicePriority Cronet_ServiceInfo_priority_get(
    const Cronet_ServiceInfoPtr self);
CRONET_EXPORT
Cronet_ServiceDelegatePtr Cronet_ServiceInfo_service_delegate_get(
    const Cronet_ServiceInfoPtr self);
CRONET_EXPORT
Cronet_AuthDelegatePtr Cronet_ServiceInfo_auth_delegate_get(
    const Cronet_ServiceInfoPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_FRONTIER_SDK_IDL_C_H_
