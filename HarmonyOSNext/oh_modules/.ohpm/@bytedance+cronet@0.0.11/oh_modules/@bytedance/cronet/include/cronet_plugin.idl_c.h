// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_plugin.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_PLUGIN_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_PLUGIN_IDL_C_H_
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
typedef struct Cronet_PluginUpdateDelegate Cronet_PluginUpdateDelegate;
typedef struct Cronet_PluginUpdateDelegate* Cronet_PluginUpdateDelegatePtr;
typedef struct Cronet_PluginManager Cronet_PluginManager;
typedef struct Cronet_PluginManager* Cronet_PluginManagerPtr;

// Forward declare structs.
typedef struct Cronet_PluginUpdateParams Cronet_PluginUpdateParams;
typedef struct Cronet_PluginUpdateParams* Cronet_PluginUpdateParamsPtr;
typedef struct Cronet_PluginInfo Cronet_PluginInfo;
typedef struct Cronet_PluginInfo* Cronet_PluginInfoPtr;
typedef struct Cronet_PluginList Cronet_PluginList;
typedef struct Cronet_PluginList* Cronet_PluginListPtr;

// Declare enums
typedef enum Cronet_PluginUpdateDelegate_RESULT {
  Cronet_PluginUpdateDelegate_RESULT_STOP_SUCCESS = 2,
  Cronet_PluginUpdateDelegate_RESULT_START_SUCCESS = 1,
  Cronet_PluginUpdateDelegate_RESULT_INIT_SUCCESS = 0,
  Cronet_PluginUpdateDelegate_RESULT_INIT_FAILED = -100,
  Cronet_PluginUpdateDelegate_RESULT_START_FAILED = -101,
  Cronet_PluginUpdateDelegate_RESULT_QUERY_SERVER_FAILED = -201,
  Cronet_PluginUpdateDelegate_RESULT_QUERY_SERVER_TIMEOUT = -202,
  Cronet_PluginUpdateDelegate_RESULT_DOWNLOAD_PLUGIN_FAILED = -301,
  Cronet_PluginUpdateDelegate_RESULT_DOWNLOAD_PLUGIN_TIMEOUT = -302,
  Cronet_PluginUpdateDelegate_RESULT_VERIFY_PLUGIN_FAILED = -303,
  Cronet_PluginUpdateDelegate_RESULT_UNZIP_PLUGIN_FAILED = -304,
  Cronet_PluginUpdateDelegate_RESULT_SAVE_UPDATE_RECORD_FAILED = -305,
  Cronet_PluginUpdateDelegate_RESULT_GET_ZIP_PATH_FAILED = -306,
} Cronet_PluginUpdateDelegate_RESULT;

// Declare constants

///////////////////////
// Abstract interface Cronet_PluginUpdateDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_PluginUpdateDelegate.
CRONET_EXPORT void Cronet_PluginUpdateDelegate_Destroy(
    Cronet_PluginUpdateDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_PluginUpdateDelegate_SetClientContext(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext Cronet_PluginUpdateDelegate_GetClientContext(
    Cronet_PluginUpdateDelegatePtr self);
// Abstract interface Cronet_PluginUpdateDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_PluginUpdateDelegate_OnResult(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginUpdateDelegate_RESULT result);
CRONET_EXPORT
void Cronet_PluginUpdateDelegate_OnNewPluginsInfoReceived(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginListPtr plugins);
CRONET_EXPORT
void Cronet_PluginUpdateDelegate_OnAllPluginsUpdateFinished(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginListPtr plugins);
CRONET_EXPORT
void Cronet_PluginUpdateDelegate_OnPluginUpdateSucceeded(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginInfoPtr plugin);
// The app implements abstract interface Cronet_PluginUpdateDelegate by defining
// custom functions for each method.
typedef void (*Cronet_PluginUpdateDelegate_OnResultFunc)(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginUpdateDelegate_RESULT result);
typedef void (*Cronet_PluginUpdateDelegate_OnNewPluginsInfoReceivedFunc)(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginListPtr plugins);
typedef void (*Cronet_PluginUpdateDelegate_OnAllPluginsUpdateFinishedFunc)(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginListPtr plugins);
typedef void (*Cronet_PluginUpdateDelegate_OnPluginUpdateSucceededFunc)(
    Cronet_PluginUpdateDelegatePtr self,
    Cronet_PluginInfoPtr plugin);
// The app creates an instance of Cronet_PluginUpdateDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_PluginUpdateDelegatePtr
Cronet_PluginUpdateDelegate_CreateWith(
    Cronet_PluginUpdateDelegate_OnResultFunc OnResultFunc,
    Cronet_PluginUpdateDelegate_OnNewPluginsInfoReceivedFunc
        OnNewPluginsInfoReceivedFunc,
    Cronet_PluginUpdateDelegate_OnAllPluginsUpdateFinishedFunc
        OnAllPluginsUpdateFinishedFunc,
    Cronet_PluginUpdateDelegate_OnPluginUpdateSucceededFunc
        OnPluginUpdateSucceededFunc);

///////////////////////
// Concrete interface Cronet_PluginManager.

// Create an instance of Cronet_PluginManager.
CRONET_EXPORT Cronet_PluginManagerPtr Cronet_PluginManager_Create(void);
// Destroy an instance of Cronet_PluginManager.
CRONET_EXPORT void Cronet_PluginManager_Destroy(Cronet_PluginManagerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_PluginManager_SetClientContext(
    Cronet_PluginManagerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_PluginManager_GetClientContext(Cronet_PluginManagerPtr self);
// Concrete methods of Cronet_PluginManager implemented by Cronet.
// The app calls them to manipulate Cronet_PluginManager.
CRONET_EXPORT
void Cronet_PluginManager_Init(Cronet_PluginManagerPtr self,
                               Cronet_PluginUpdateParamsPtr params);
CRONET_EXPORT
void Cronet_PluginManager_UpdateParams(Cronet_PluginManagerPtr self,
                                       Cronet_PluginUpdateParamsPtr params);
CRONET_EXPORT
void Cronet_PluginManager_Start(Cronet_PluginManagerPtr self);
CRONET_EXPORT
void Cronet_PluginManager_Stop(Cronet_PluginManagerPtr self);
CRONET_EXPORT
void Cronet_PluginManager_AddDelegate(Cronet_PluginManagerPtr self,
                                      Cronet_PluginUpdateDelegatePtr delegate,
                                      Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_PluginManager_RemoveDelegate(
    Cronet_PluginManagerPtr self,
    Cronet_PluginUpdateDelegatePtr delegate);
// Concrete interface Cronet_PluginManager is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_PluginManager_InitFunc)(
    Cronet_PluginManagerPtr self,
    Cronet_PluginUpdateParamsPtr params);
typedef void (*Cronet_PluginManager_UpdateParamsFunc)(
    Cronet_PluginManagerPtr self,
    Cronet_PluginUpdateParamsPtr params);
typedef void (*Cronet_PluginManager_StartFunc)(Cronet_PluginManagerPtr self);
typedef void (*Cronet_PluginManager_StopFunc)(Cronet_PluginManagerPtr self);
typedef void (*Cronet_PluginManager_DestroyFunc)(Cronet_PluginManagerPtr self);
typedef void (*Cronet_PluginManager_AddDelegateFunc)(
    Cronet_PluginManagerPtr self,
    Cronet_PluginUpdateDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_PluginManager_RemoveDelegateFunc)(
    Cronet_PluginManagerPtr self,
    Cronet_PluginUpdateDelegatePtr delegate);
// Concrete interface Cronet_PluginManager is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_PluginManagerPtr Cronet_PluginManager_CreateWith(
    Cronet_PluginManager_InitFunc InitFunc,
    Cronet_PluginManager_UpdateParamsFunc UpdateParamsFunc,
    Cronet_PluginManager_StartFunc StartFunc,
    Cronet_PluginManager_StopFunc StopFunc,
    Cronet_PluginManager_DestroyFunc DestroyFunc,
    Cronet_PluginManager_AddDelegateFunc AddDelegateFunc,
    Cronet_PluginManager_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_PluginUpdateParams.
CRONET_EXPORT Cronet_PluginUpdateParamsPtr
Cronet_PluginUpdateParams_Create(void);
CRONET_EXPORT void Cronet_PluginUpdateParams_Destroy(
    Cronet_PluginUpdateParamsPtr self);
// Cronet_PluginUpdateParams setters.
CRONET_EXPORT
void Cronet_PluginUpdateParams_url_set(Cronet_PluginUpdateParamsPtr self,
                                       const Cronet_String url);
CRONET_EXPORT
void Cronet_PluginUpdateParams_plugin_path_set(
    Cronet_PluginUpdateParamsPtr self,
    const Cronet_String plugin_path);
CRONET_EXPORT
void Cronet_PluginUpdateParams_user_id_set(Cronet_PluginUpdateParamsPtr self,
                                           const Cronet_String user_id);
CRONET_EXPORT
void Cronet_PluginUpdateParams_install_time_set(
    Cronet_PluginUpdateParamsPtr self,
    const int64_t install_time);
CRONET_EXPORT
void Cronet_PluginUpdateParams_is_logged_in_set(
    Cronet_PluginUpdateParamsPtr self,
    const bool is_logged_in);
CRONET_EXPORT
void Cronet_PluginUpdateParams_build_number_set(
    Cronet_PluginUpdateParamsPtr self,
    const Cronet_String build_number);
// Cronet_PluginUpdateParams getters.
CRONET_EXPORT
Cronet_String Cronet_PluginUpdateParams_url_get(
    const Cronet_PluginUpdateParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginUpdateParams_plugin_path_get(
    const Cronet_PluginUpdateParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginUpdateParams_user_id_get(
    const Cronet_PluginUpdateParamsPtr self);
CRONET_EXPORT
int64_t Cronet_PluginUpdateParams_install_time_get(
    const Cronet_PluginUpdateParamsPtr self);
CRONET_EXPORT
bool Cronet_PluginUpdateParams_is_logged_in_get(
    const Cronet_PluginUpdateParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginUpdateParams_build_number_get(
    const Cronet_PluginUpdateParamsPtr self);

///////////////////////
// Struct Cronet_PluginInfo.
CRONET_EXPORT Cronet_PluginInfoPtr Cronet_PluginInfo_Create(void);
CRONET_EXPORT void Cronet_PluginInfo_Destroy(Cronet_PluginInfoPtr self);
// Cronet_PluginInfo setters.
CRONET_EXPORT
void Cronet_PluginInfo_name_set(Cronet_PluginInfoPtr self,
                                const Cronet_String name);
CRONET_EXPORT
void Cronet_PluginInfo_version_set(Cronet_PluginInfoPtr self,
                                   const Cronet_String version);
CRONET_EXPORT
void Cronet_PluginInfo_path_set(Cronet_PluginInfoPtr self,
                                const Cronet_String path);
CRONET_EXPORT
void Cronet_PluginInfo_type_set(Cronet_PluginInfoPtr self,
                                const Cronet_String type);
// Cronet_PluginInfo getters.
CRONET_EXPORT
Cronet_String Cronet_PluginInfo_name_get(const Cronet_PluginInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginInfo_version_get(const Cronet_PluginInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginInfo_path_get(const Cronet_PluginInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_PluginInfo_type_get(const Cronet_PluginInfoPtr self);

///////////////////////
// Struct Cronet_PluginList.
CRONET_EXPORT Cronet_PluginListPtr Cronet_PluginList_Create(void);
CRONET_EXPORT void Cronet_PluginList_Destroy(Cronet_PluginListPtr self);
// Cronet_PluginList setters.
CRONET_EXPORT
void Cronet_PluginList_plugin_list_add(Cronet_PluginListPtr self,
                                       const Cronet_PluginInfoPtr element);
// Cronet_PluginList getters.
CRONET_EXPORT
uint32_t Cronet_PluginList_plugin_list_size(const Cronet_PluginListPtr self);
CRONET_EXPORT
Cronet_PluginInfoPtr Cronet_PluginList_plugin_list_at(
    const Cronet_PluginListPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_PluginList_plugin_list_clear(Cronet_PluginListPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_PLUGIN_IDL_C_H_
