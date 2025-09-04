// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_ohos.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_OHOS_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_OHOS_IDL_C_H_
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_NetworkChangeNotifier Cronet_NetworkChangeNotifier;
typedef struct Cronet_NetworkChangeNotifier* Cronet_NetworkChangeNotifierPtr;

// Forward declare structs.

// Declare enums

// Declare constants

///////////////////////
// Concrete interface Cronet_NetworkChangeNotifier.

// Create an instance of Cronet_NetworkChangeNotifier.
CRONET_EXPORT Cronet_NetworkChangeNotifierPtr
Cronet_NetworkChangeNotifier_Create(void);
// Destroy an instance of Cronet_NetworkChangeNotifier.
CRONET_EXPORT void Cronet_NetworkChangeNotifier_Destroy(
    Cronet_NetworkChangeNotifierPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_NetworkChangeNotifier_SetClientContext(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_NetworkChangeNotifier_GetClientContext(
    Cronet_NetworkChangeNotifierPtr self);
// Concrete methods of Cronet_NetworkChangeNotifier implemented by Cronet.
// The app calls them to manipulate Cronet_NetworkChangeNotifier.
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyTypeChanged(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String type,
    int32_t net_id);
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyConnected(
    Cronet_NetworkChangeNotifierPtr self,
    int32_t net_id,
    Cronet_String type,
    bool is_vpn);
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyDisconnected(
    Cronet_NetworkChangeNotifierPtr self,
    int32_t net_id,
    bool is_vpn);
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyConnnectionOnInit(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String type,
    int32_t net_id,
    bool is_vpn);
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyVPNChanged(
    Cronet_NetworkChangeNotifierPtr self,
    bool has_vpn);
CRONET_EXPORT
void Cronet_NetworkChangeNotifier_NotifyProxyChanged(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String proxy);
// Concrete interface Cronet_NetworkChangeNotifier is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_NetworkChangeNotifier_NotifyTypeChangedFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String type,
    int32_t net_id);
typedef void (*Cronet_NetworkChangeNotifier_NotifyConnectedFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    int32_t net_id,
    Cronet_String type,
    bool is_vpn);
typedef void (*Cronet_NetworkChangeNotifier_NotifyDisconnectedFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    int32_t net_id,
    bool is_vpn);
typedef void (*Cronet_NetworkChangeNotifier_NotifyConnnectionOnInitFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String type,
    int32_t net_id,
    bool is_vpn);
typedef void (*Cronet_NetworkChangeNotifier_NotifyVPNChangedFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    bool has_vpn);
typedef void (*Cronet_NetworkChangeNotifier_NotifyProxyChangedFunc)(
    Cronet_NetworkChangeNotifierPtr self,
    Cronet_String proxy);
// Concrete interface Cronet_NetworkChangeNotifier is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_NetworkChangeNotifierPtr
Cronet_NetworkChangeNotifier_CreateWith(
    Cronet_NetworkChangeNotifier_NotifyTypeChangedFunc NotifyTypeChangedFunc,
    Cronet_NetworkChangeNotifier_NotifyConnectedFunc NotifyConnectedFunc,
    Cronet_NetworkChangeNotifier_NotifyDisconnectedFunc NotifyDisconnectedFunc,
    Cronet_NetworkChangeNotifier_NotifyConnnectionOnInitFunc
        NotifyConnnectionOnInitFunc,
    Cronet_NetworkChangeNotifier_NotifyVPNChangedFunc NotifyVPNChangedFunc,
    Cronet_NetworkChangeNotifier_NotifyProxyChangedFunc NotifyProxyChangedFunc);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_OHOS_IDL_C_H_
