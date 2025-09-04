// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_throttle.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_THROTTLE_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_THROTTLE_IDL_C_H_
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
typedef struct Cronet_ThrottleDelegate Cronet_ThrottleDelegate;
typedef struct Cronet_ThrottleDelegate* Cronet_ThrottleDelegatePtr;
typedef struct Cronet_Throttle Cronet_Throttle;
typedef struct Cronet_Throttle* Cronet_ThrottlePtr;

// Forward declare structs.
typedef struct Cronet_ThrottleLevel Cronet_ThrottleLevel;
typedef struct Cronet_ThrottleLevel* Cronet_ThrottleLevelPtr;
typedef struct Cronet_ThrottleParam Cronet_ThrottleParam;
typedef struct Cronet_ThrottleParam* Cronet_ThrottleParamPtr;

// Declare enums
typedef enum Cronet_DIRECTION_TYPE {
  Cronet_DIRECTION_TYPE_DOWN = 0,
  Cronet_DIRECTION_TYPE_UP = 1,
  Cronet_DIRECTION_TYPE_PC_DOWN = 2,
  Cronet_DIRECTION_TYPE_PC_UP = 3,
} Cronet_DIRECTION_TYPE;

// Declare constants

///////////////////////
// Abstract interface Cronet_ThrottleDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_ThrottleDelegate.
CRONET_EXPORT void Cronet_ThrottleDelegate_Destroy(
    Cronet_ThrottleDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_ThrottleDelegate_SetClientContext(
    Cronet_ThrottleDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_ThrottleDelegate_GetClientContext(Cronet_ThrottleDelegatePtr self);
// Abstract interface Cronet_ThrottleDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_ThrottleDelegate_OnStatistics(Cronet_ThrottleDelegatePtr self,
                                          int32_t error,
                                          Cronet_String url,
                                          Cronet_String method,
                                          int32_t actual_down_speed,
                                          int32_t given_down_speed,
                                          int32_t actual_up_speed,
                                          int32_t given_up_speed);
CRONET_EXPORT
void Cronet_ThrottleDelegate_OnPCStatistics(Cronet_ThrottleDelegatePtr self,
                                            Cronet_String url,
                                            int32_t pre_given_down_speed,
                                            int32_t cur_given_down_speed,
                                            int32_t pre_actual_down_speed,
                                            int32_t pre_given_up_speed,
                                            int32_t cur_given_up_speed,
                                            int32_t pre_actual_up_speed);
// The app implements abstract interface Cronet_ThrottleDelegate by defining
// custom functions for each method.
typedef void (*Cronet_ThrottleDelegate_OnStatisticsFunc)(
    Cronet_ThrottleDelegatePtr self,
    int32_t error,
    Cronet_String url,
    Cronet_String method,
    int32_t actual_down_speed,
    int32_t given_down_speed,
    int32_t actual_up_speed,
    int32_t given_up_speed);
typedef void (*Cronet_ThrottleDelegate_OnPCStatisticsFunc)(
    Cronet_ThrottleDelegatePtr self,
    Cronet_String url,
    int32_t pre_given_down_speed,
    int32_t cur_given_down_speed,
    int32_t pre_actual_down_speed,
    int32_t pre_given_up_speed,
    int32_t cur_given_up_speed,
    int32_t pre_actual_up_speed);
// The app creates an instance of Cronet_ThrottleDelegate by providing custom
// functions for each method.
CRONET_EXPORT Cronet_ThrottleDelegatePtr Cronet_ThrottleDelegate_CreateWith(
    Cronet_ThrottleDelegate_OnStatisticsFunc OnStatisticsFunc,
    Cronet_ThrottleDelegate_OnPCStatisticsFunc OnPCStatisticsFunc);

///////////////////////
// Concrete interface Cronet_Throttle.

// Create an instance of Cronet_Throttle.
CRONET_EXPORT Cronet_ThrottlePtr Cronet_Throttle_Create(void);
// Destroy an instance of Cronet_Throttle.
CRONET_EXPORT void Cronet_Throttle_Destroy(Cronet_ThrottlePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_Throttle_SetClientContext(
    Cronet_ThrottlePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_Throttle_GetClientContext(Cronet_ThrottlePtr self);
// Concrete methods of Cronet_Throttle implemented by Cronet.
// The app calls them to manipulate Cronet_Throttle.
CRONET_EXPORT
void Cronet_Throttle_Start(Cronet_ThrottlePtr self,
                           Cronet_ThrottleParamPtr param);
CRONET_EXPORT
void Cronet_Throttle_Stop(Cronet_ThrottlePtr self,
                          Cronet_ThrottleParamPtr param);
CRONET_EXPORT
void Cronet_Throttle_StopAll(Cronet_ThrottlePtr self);
CRONET_EXPORT
void Cronet_Throttle_AddDelegate(Cronet_ThrottlePtr self,
                                 Cronet_ThrottleDelegatePtr delegate,
                                 Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Throttle_RemoveDelegate(Cronet_ThrottlePtr self,
                                    Cronet_ThrottleDelegatePtr delegate);
// Concrete interface Cronet_Throttle is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_Throttle_DestroyFunc)(Cronet_ThrottlePtr self);
typedef void (*Cronet_Throttle_StartFunc)(Cronet_ThrottlePtr self,
                                          Cronet_ThrottleParamPtr param);
typedef void (*Cronet_Throttle_StopFunc)(Cronet_ThrottlePtr self,
                                         Cronet_ThrottleParamPtr param);
typedef void (*Cronet_Throttle_StopAllFunc)(Cronet_ThrottlePtr self);
typedef void (*Cronet_Throttle_AddDelegateFunc)(
    Cronet_ThrottlePtr self,
    Cronet_ThrottleDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Throttle_RemoveDelegateFunc)(
    Cronet_ThrottlePtr self,
    Cronet_ThrottleDelegatePtr delegate);
// Concrete interface Cronet_Throttle is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_ThrottlePtr Cronet_Throttle_CreateWith(
    Cronet_Throttle_DestroyFunc DestroyFunc,
    Cronet_Throttle_StartFunc StartFunc,
    Cronet_Throttle_StopFunc StopFunc,
    Cronet_Throttle_StopAllFunc StopAllFunc,
    Cronet_Throttle_AddDelegateFunc AddDelegateFunc,
    Cronet_Throttle_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_ThrottleLevel.
CRONET_EXPORT Cronet_ThrottleLevelPtr Cronet_ThrottleLevel_Create(void);
CRONET_EXPORT void Cronet_ThrottleLevel_Destroy(Cronet_ThrottleLevelPtr self);
// Cronet_ThrottleLevel setters.
CRONET_EXPORT
void Cronet_ThrottleLevel_low_level_bytes_per_sec_set(
    Cronet_ThrottleLevelPtr self,
    const int32_t low_level_bytes_per_sec);
CRONET_EXPORT
void Cronet_ThrottleLevel_medium_level_bytes_per_sec_set(
    Cronet_ThrottleLevelPtr self,
    const int32_t medium_level_bytes_per_sec);
CRONET_EXPORT
void Cronet_ThrottleLevel_high_level_bytes_per_sec_set(
    Cronet_ThrottleLevelPtr self,
    const int32_t high_level_bytes_per_sec);
// Cronet_ThrottleLevel getters.
CRONET_EXPORT
int32_t Cronet_ThrottleLevel_low_level_bytes_per_sec_get(
    const Cronet_ThrottleLevelPtr self);
CRONET_EXPORT
int32_t Cronet_ThrottleLevel_medium_level_bytes_per_sec_get(
    const Cronet_ThrottleLevelPtr self);
CRONET_EXPORT
int32_t Cronet_ThrottleLevel_high_level_bytes_per_sec_get(
    const Cronet_ThrottleLevelPtr self);

///////////////////////
// Struct Cronet_ThrottleParam.
CRONET_EXPORT Cronet_ThrottleParamPtr Cronet_ThrottleParam_Create(void);
CRONET_EXPORT void Cronet_ThrottleParam_Destroy(Cronet_ThrottleParamPtr self);
// Cronet_ThrottleParam setters.
CRONET_EXPORT
void Cronet_ThrottleParam_host_list_add(Cronet_ThrottleParamPtr self,
                                        const Cronet_String element);
CRONET_EXPORT
void Cronet_ThrottleParam_level_set(Cronet_ThrottleParamPtr self,
                                    const Cronet_ThrottleLevelPtr level);
// Move data from |level|. The caller retains ownership of |level| and must
// destroy it.
void Cronet_ThrottleParam_level_move(Cronet_ThrottleParamPtr self,
                                     Cronet_ThrottleLevelPtr level);
CRONET_EXPORT
void Cronet_ThrottleParam_type_set(Cronet_ThrottleParamPtr self,
                                   const Cronet_DIRECTION_TYPE type);
CRONET_EXPORT
void Cronet_ThrottleParam_bytes_per_sec_set(Cronet_ThrottleParamPtr self,
                                            const uint32_t bytes_per_sec);
// Cronet_ThrottleParam getters.
CRONET_EXPORT
uint32_t Cronet_ThrottleParam_host_list_size(
    const Cronet_ThrottleParamPtr self);
CRONET_EXPORT
Cronet_String Cronet_ThrottleParam_host_list_at(
    const Cronet_ThrottleParamPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_ThrottleParam_host_list_clear(Cronet_ThrottleParamPtr self);
CRONET_EXPORT
Cronet_ThrottleLevelPtr Cronet_ThrottleParam_level_get(
    const Cronet_ThrottleParamPtr self);
CRONET_EXPORT
Cronet_DIRECTION_TYPE Cronet_ThrottleParam_type_get(
    const Cronet_ThrottleParamPtr self);
CRONET_EXPORT
uint32_t Cronet_ThrottleParam_bytes_per_sec_get(
    const Cronet_ThrottleParamPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_THROTTLE_IDL_C_H_
