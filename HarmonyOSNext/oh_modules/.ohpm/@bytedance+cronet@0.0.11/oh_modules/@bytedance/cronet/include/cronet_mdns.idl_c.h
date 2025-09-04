// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_mdns.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_MDNS_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_MDNS_IDL_C_H_
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
typedef struct Cronet_MDnsDelegate Cronet_MDnsDelegate;
typedef struct Cronet_MDnsDelegate* Cronet_MDnsDelegatePtr;
typedef struct Cronet_MDns Cronet_MDns;
typedef struct Cronet_MDns* Cronet_MDnsPtr;

// Forward declare structs.
typedef struct Cronet_DeviceInfo Cronet_DeviceInfo;
typedef struct Cronet_DeviceInfo* Cronet_DeviceInfoPtr;
typedef struct Cronet_MDnsConfig Cronet_MDnsConfig;
typedef struct Cronet_MDnsConfig* Cronet_MDnsConfigPtr;

// Declare enums
typedef enum Cronet_MDnsMode {
  Cronet_MDnsMode_MDNS_CLIENT = 0,
  Cronet_MDnsMode_MDNS_SERVICE = 1,
} Cronet_MDnsMode;

typedef enum Cronet_DeviceInfo_IP_TYPE {
  Cronet_DeviceInfo_IP_TYPE_IP_TYPE_V4 = 0,
  Cronet_DeviceInfo_IP_TYPE_IP_TYPE_V6 = 1,
} Cronet_DeviceInfo_IP_TYPE;

// Declare constants

///////////////////////
// Abstract interface Cronet_MDnsDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_MDnsDelegate.
CRONET_EXPORT void Cronet_MDnsDelegate_Destroy(Cronet_MDnsDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_MDnsDelegate_SetClientContext(
    Cronet_MDnsDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_MDnsDelegate_GetClientContext(Cronet_MDnsDelegatePtr self);
// Abstract interface Cronet_MDnsDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_MDnsDelegate_OnError(Cronet_MDnsDelegatePtr self, int32_t error);
CRONET_EXPORT
void Cronet_MDnsDelegate_OnDiscovered(Cronet_MDnsDelegatePtr self,
                                      Cronet_DeviceInfoPtr device_info);
// The app implements abstract interface Cronet_MDnsDelegate by defining custom
// functions for each method.
typedef void (*Cronet_MDnsDelegate_OnErrorFunc)(Cronet_MDnsDelegatePtr self,
                                                int32_t error);
typedef void (*Cronet_MDnsDelegate_OnDiscoveredFunc)(
    Cronet_MDnsDelegatePtr self,
    Cronet_DeviceInfoPtr device_info);
// The app creates an instance of Cronet_MDnsDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_MDnsDelegatePtr Cronet_MDnsDelegate_CreateWith(
    Cronet_MDnsDelegate_OnErrorFunc OnErrorFunc,
    Cronet_MDnsDelegate_OnDiscoveredFunc OnDiscoveredFunc);

///////////////////////
// Concrete interface Cronet_MDns.

// Create an instance of Cronet_MDns.
CRONET_EXPORT Cronet_MDnsPtr Cronet_MDns_Create(void);
// Destroy an instance of Cronet_MDns.
CRONET_EXPORT void Cronet_MDns_Destroy(Cronet_MDnsPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_MDns_SetClientContext(
    Cronet_MDnsPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_MDns_GetClientContext(Cronet_MDnsPtr self);
// Concrete methods of Cronet_MDns implemented by Cronet.
// The app calls them to manipulate Cronet_MDns.
CRONET_EXPORT
void Cronet_MDns_ConfigService(Cronet_MDnsPtr self,
                               Cronet_MDnsConfigPtr config);
CRONET_EXPORT
void Cronet_MDns_Start(Cronet_MDnsPtr self);
CRONET_EXPORT
void Cronet_MDns_Stop(Cronet_MDnsPtr self);
CRONET_EXPORT
void Cronet_MDns_AddDelegate(Cronet_MDnsPtr self,
                             Cronet_MDnsDelegatePtr delegate,
                             Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_MDns_RemoveDelegate(Cronet_MDnsPtr self,
                                Cronet_MDnsDelegatePtr delegate);
// Concrete interface Cronet_MDns is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_MDns_ConfigServiceFunc)(Cronet_MDnsPtr self,
                                              Cronet_MDnsConfigPtr config);
typedef void (*Cronet_MDns_StartFunc)(Cronet_MDnsPtr self);
typedef void (*Cronet_MDns_StopFunc)(Cronet_MDnsPtr self);
typedef void (*Cronet_MDns_DestroyFunc)(Cronet_MDnsPtr self);
typedef void (*Cronet_MDns_AddDelegateFunc)(Cronet_MDnsPtr self,
                                            Cronet_MDnsDelegatePtr delegate,
                                            Cronet_ExecutorPtr executor);
typedef void (*Cronet_MDns_RemoveDelegateFunc)(Cronet_MDnsPtr self,
                                               Cronet_MDnsDelegatePtr delegate);
// Concrete interface Cronet_MDns is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_MDnsPtr
Cronet_MDns_CreateWith(Cronet_MDns_ConfigServiceFunc ConfigServiceFunc,
                       Cronet_MDns_StartFunc StartFunc,
                       Cronet_MDns_StopFunc StopFunc,
                       Cronet_MDns_DestroyFunc DestroyFunc,
                       Cronet_MDns_AddDelegateFunc AddDelegateFunc,
                       Cronet_MDns_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_DeviceInfo.
CRONET_EXPORT Cronet_DeviceInfoPtr Cronet_DeviceInfo_Create(void);
CRONET_EXPORT void Cronet_DeviceInfo_Destroy(Cronet_DeviceInfoPtr self);
// Cronet_DeviceInfo setters.
CRONET_EXPORT
void Cronet_DeviceInfo_ip_addr_set(Cronet_DeviceInfoPtr self,
                                   const Cronet_String ip_addr);
CRONET_EXPORT
void Cronet_DeviceInfo_ip_type_set(Cronet_DeviceInfoPtr self,
                                   const Cronet_DeviceInfo_IP_TYPE ip_type);
CRONET_EXPORT
void Cronet_DeviceInfo_extra_info_add(Cronet_DeviceInfoPtr self,
                                      const Cronet_String element);
// Cronet_DeviceInfo getters.
CRONET_EXPORT
Cronet_String Cronet_DeviceInfo_ip_addr_get(const Cronet_DeviceInfoPtr self);
CRONET_EXPORT
Cronet_DeviceInfo_IP_TYPE Cronet_DeviceInfo_ip_type_get(
    const Cronet_DeviceInfoPtr self);
CRONET_EXPORT
uint32_t Cronet_DeviceInfo_extra_info_size(const Cronet_DeviceInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_DeviceInfo_extra_info_at(const Cronet_DeviceInfoPtr self,
                                              uint32_t index);
CRONET_EXPORT
void Cronet_DeviceInfo_extra_info_clear(Cronet_DeviceInfoPtr self);

///////////////////////
// Struct Cronet_MDnsConfig.
CRONET_EXPORT Cronet_MDnsConfigPtr Cronet_MDnsConfig_Create(void);
CRONET_EXPORT void Cronet_MDnsConfig_Destroy(Cronet_MDnsConfigPtr self);
// Cronet_MDnsConfig setters.
CRONET_EXPORT
void Cronet_MDnsConfig_name_set(Cronet_MDnsConfigPtr self,
                                const Cronet_String name);
CRONET_EXPORT
void Cronet_MDnsConfig_broadcast_interval_set(Cronet_MDnsConfigPtr self,
                                              const int64_t broadcast_interval);
CRONET_EXPORT
void Cronet_MDnsConfig_mode_set(Cronet_MDnsConfigPtr self,
                                const Cronet_MDnsMode mode);
CRONET_EXPORT
void Cronet_MDnsConfig_extra_info_add(Cronet_MDnsConfigPtr self,
                                      const Cronet_String element);
// Cronet_MDnsConfig getters.
CRONET_EXPORT
Cronet_String Cronet_MDnsConfig_name_get(const Cronet_MDnsConfigPtr self);
CRONET_EXPORT
int64_t Cronet_MDnsConfig_broadcast_interval_get(
    const Cronet_MDnsConfigPtr self);
CRONET_EXPORT
Cronet_MDnsMode Cronet_MDnsConfig_mode_get(const Cronet_MDnsConfigPtr self);
CRONET_EXPORT
uint32_t Cronet_MDnsConfig_extra_info_size(const Cronet_MDnsConfigPtr self);
CRONET_EXPORT
Cronet_String Cronet_MDnsConfig_extra_info_at(const Cronet_MDnsConfigPtr self,
                                              uint32_t index);
CRONET_EXPORT
void Cronet_MDnsConfig_extra_info_clear(Cronet_MDnsConfigPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_MDNS_IDL_C_H_
