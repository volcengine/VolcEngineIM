// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_detector.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DETECTOR_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DETECTOR_IDL_C_H_
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
typedef struct Cronet_TTNetDetectDelegate Cronet_TTNetDetectDelegate;
typedef struct Cronet_TTNetDetectDelegate* Cronet_TTNetDetectDelegatePtr;
typedef struct Cronet_TTNetDetector Cronet_TTNetDetector;
typedef struct Cronet_TTNetDetector* Cronet_TTNetDetectorPtr;

// Forward declare structs.
typedef struct Cronet_TTNetDetectParams Cronet_TTNetDetectParams;
typedef struct Cronet_TTNetDetectParams* Cronet_TTNetDetectParamsPtr;

// Declare enums

// Declare constants

///////////////////////
// Abstract interface Cronet_TTNetDetectDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TTNetDetectDelegate.
CRONET_EXPORT void Cronet_TTNetDetectDelegate_Destroy(
    Cronet_TTNetDetectDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TTNetDetectDelegate_SetClientContext(
    Cronet_TTNetDetectDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TTNetDetectDelegate_GetClientContext(Cronet_TTNetDetectDelegatePtr self);
// Abstract interface Cronet_TTNetDetectDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TTNetDetectDelegate_OnTTNetDetectInfoChanged(
    Cronet_TTNetDetectDelegatePtr self,
    Cronet_String info);
// The app implements abstract interface Cronet_TTNetDetectDelegate by defining
// custom functions for each method.
typedef void (*Cronet_TTNetDetectDelegate_OnTTNetDetectInfoChangedFunc)(
    Cronet_TTNetDetectDelegatePtr self,
    Cronet_String info);
// The app creates an instance of Cronet_TTNetDetectDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_TTNetDetectDelegatePtr
Cronet_TTNetDetectDelegate_CreateWith(
    Cronet_TTNetDetectDelegate_OnTTNetDetectInfoChangedFunc
        OnTTNetDetectInfoChangedFunc);

///////////////////////
// Concrete interface Cronet_TTNetDetector.

// Create an instance of Cronet_TTNetDetector.
CRONET_EXPORT Cronet_TTNetDetectorPtr Cronet_TTNetDetector_Create(void);
// Destroy an instance of Cronet_TTNetDetector.
CRONET_EXPORT void Cronet_TTNetDetector_Destroy(Cronet_TTNetDetectorPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TTNetDetector_SetClientContext(
    Cronet_TTNetDetectorPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TTNetDetector_GetClientContext(Cronet_TTNetDetectorPtr self);
// Concrete methods of Cronet_TTNetDetector implemented by Cronet.
// The app calls them to manipulate Cronet_TTNetDetector.
CRONET_EXPORT
void Cronet_TTNetDetector_TryStartNetDetect(Cronet_TTNetDetectorPtr self,
                                            Cronet_TTNetDetectParamsPtr params);
CRONET_EXPORT
void Cronet_TTNetDetector_AddDelegate(Cronet_TTNetDetectorPtr self,
                                      Cronet_TTNetDetectDelegatePtr delegate,
                                      Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_TTNetDetector_RemoveDelegate(
    Cronet_TTNetDetectorPtr self,
    Cronet_TTNetDetectDelegatePtr delegate);
// Concrete interface Cronet_TTNetDetector is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_TTNetDetector_TryStartNetDetectFunc)(
    Cronet_TTNetDetectorPtr self,
    Cronet_TTNetDetectParamsPtr params);
typedef void (*Cronet_TTNetDetector_AddDelegateFunc)(
    Cronet_TTNetDetectorPtr self,
    Cronet_TTNetDetectDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_TTNetDetector_RemoveDelegateFunc)(
    Cronet_TTNetDetectorPtr self,
    Cronet_TTNetDetectDelegatePtr delegate);
typedef void (*Cronet_TTNetDetector_DestroyFunc)(Cronet_TTNetDetectorPtr self);
// Concrete interface Cronet_TTNetDetector is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_TTNetDetectorPtr Cronet_TTNetDetector_CreateWith(
    Cronet_TTNetDetector_TryStartNetDetectFunc TryStartNetDetectFunc,
    Cronet_TTNetDetector_AddDelegateFunc AddDelegateFunc,
    Cronet_TTNetDetector_RemoveDelegateFunc RemoveDelegateFunc,
    Cronet_TTNetDetector_DestroyFunc DestroyFunc);

///////////////////////
// Struct Cronet_TTNetDetectParams.
CRONET_EXPORT Cronet_TTNetDetectParamsPtr Cronet_TTNetDetectParams_Create(void);
CRONET_EXPORT void Cronet_TTNetDetectParams_Destroy(
    Cronet_TTNetDetectParamsPtr self);
// Cronet_TTNetDetectParams setters.
CRONET_EXPORT
void Cronet_TTNetDetectParams_urls_add(Cronet_TTNetDetectParamsPtr self,
                                       const Cronet_String element);
CRONET_EXPORT
void Cronet_TTNetDetectParams_timeout_set(Cronet_TTNetDetectParamsPtr self,
                                          const uint32_t timeout);
CRONET_EXPORT
void Cronet_TTNetDetectParams_actions_set(Cronet_TTNetDetectParamsPtr self,
                                          const uint32_t actions);
// Cronet_TTNetDetectParams getters.
CRONET_EXPORT
uint32_t Cronet_TTNetDetectParams_urls_size(
    const Cronet_TTNetDetectParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetDetectParams_urls_at(
    const Cronet_TTNetDetectParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_TTNetDetectParams_urls_clear(Cronet_TTNetDetectParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_TTNetDetectParams_timeout_get(
    const Cronet_TTNetDetectParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_TTNetDetectParams_actions_get(
    const Cronet_TTNetDetectParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_DETECTOR_IDL_C_H_
