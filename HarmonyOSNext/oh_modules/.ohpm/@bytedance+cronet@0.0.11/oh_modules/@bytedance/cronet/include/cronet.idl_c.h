// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from components/cronet/native/generated/cronet.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_IDL_C_H_
#include "cronet_export.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef const char* Cronet_String;
typedef void* Cronet_RawDataPtr;
typedef void* Cronet_ClientContext;

// Forward declare interfaces.
typedef struct Cronet_Buffer Cronet_Buffer;
typedef struct Cronet_Buffer* Cronet_BufferPtr;
typedef struct Cronet_BufferCallback Cronet_BufferCallback;
typedef struct Cronet_BufferCallback* Cronet_BufferCallbackPtr;
typedef struct Cronet_Runnable Cronet_Runnable;
typedef struct Cronet_Runnable* Cronet_RunnablePtr;
typedef struct Cronet_Executor Cronet_Executor;
typedef struct Cronet_Executor* Cronet_ExecutorPtr;
typedef struct Cronet_Engine Cronet_Engine;
typedef struct Cronet_Engine* Cronet_EnginePtr;
typedef struct Cronet_UrlRequestStatusListener Cronet_UrlRequestStatusListener;
typedef struct Cronet_UrlRequestStatusListener*
    Cronet_UrlRequestStatusListenerPtr;
typedef struct Cronet_UrlRequestCallback Cronet_UrlRequestCallback;
typedef struct Cronet_UrlRequestCallback* Cronet_UrlRequestCallbackPtr;
typedef struct Cronet_UploadDataSink Cronet_UploadDataSink;
typedef struct Cronet_UploadDataSink* Cronet_UploadDataSinkPtr;
typedef struct Cronet_UploadDataProvider Cronet_UploadDataProvider;
typedef struct Cronet_UploadDataProvider* Cronet_UploadDataProviderPtr;
typedef struct Cronet_UrlRequest Cronet_UrlRequest;
typedef struct Cronet_UrlRequest* Cronet_UrlRequestPtr;
typedef struct Cronet_RequestFinishedInfoListener
    Cronet_RequestFinishedInfoListener;
typedef struct Cronet_RequestFinishedInfoListener*
    Cronet_RequestFinishedInfoListenerPtr;
typedef struct Cronet_ConnectionTypeListener Cronet_ConnectionTypeListener;
typedef struct Cronet_ConnectionTypeListener* Cronet_ConnectionTypeListenerPtr;
typedef struct Cronet_NQEListener Cronet_NQEListener;
typedef struct Cronet_NQEListener* Cronet_NQEListenerPtr;
typedef struct Cronet_MNListener Cronet_MNListener;
typedef struct Cronet_MNListener* Cronet_MNListenerPtr;
typedef struct Cronet_StoreRegionListener Cronet_StoreRegionListener;
typedef struct Cronet_StoreRegionListener* Cronet_StoreRegionListenerPtr;
typedef struct Cronet_TTNetRequestInfoDelegate Cronet_TTNetRequestInfoDelegate;
typedef struct Cronet_TTNetRequestInfoDelegate*
    Cronet_TTNetRequestInfoDelegatePtr;
typedef struct Cronet_PublicIPsListener Cronet_PublicIPsListener;
typedef struct Cronet_PublicIPsListener* Cronet_PublicIPsListenerPtr;
typedef struct Cronet_LogMonitorListener Cronet_LogMonitorListener;
typedef struct Cronet_LogMonitorListener* Cronet_LogMonitorListenerPtr;
typedef struct Cronet_TNCConfigListener Cronet_TNCConfigListener;
typedef struct Cronet_TNCConfigListener* Cronet_TNCConfigListenerPtr;
typedef struct Cronet_TTUrlDispatchCallback Cronet_TTUrlDispatchCallback;
typedef struct Cronet_TTUrlDispatchCallback* Cronet_TTUrlDispatchCallbackPtr;

// Forward declare structs.
typedef struct Cronet_Error Cronet_Error;
typedef struct Cronet_Error* Cronet_ErrorPtr;
typedef struct Cronet_RTTAndThroughput Cronet_RTTAndThroughput;
typedef struct Cronet_RTTAndThroughput* Cronet_RTTAndThroughputPtr;
typedef struct Cronet_PacketLostStats Cronet_PacketLostStats;
typedef struct Cronet_PacketLostStats* Cronet_PacketLostStatsPtr;
typedef struct Cronet_NetworkInterface Cronet_NetworkInterface;
typedef struct Cronet_NetworkInterface* Cronet_NetworkInterfacePtr;
typedef struct Cronet_NetworkReport Cronet_NetworkReport;
typedef struct Cronet_NetworkReport* Cronet_NetworkReportPtr;
typedef struct Cronet_TTDnsResult Cronet_TTDnsResult;
typedef struct Cronet_TTDnsResult* Cronet_TTDnsResultPtr;
typedef struct Cronet_OpaqueData Cronet_OpaqueData;
typedef struct Cronet_OpaqueData* Cronet_OpaqueDataPtr;
typedef struct Cronet_ClientOpaqueData Cronet_ClientOpaqueData;
typedef struct Cronet_ClientOpaqueData* Cronet_ClientOpaqueDataPtr;
typedef struct Cronet_QuicHint Cronet_QuicHint;
typedef struct Cronet_QuicHint* Cronet_QuicHintPtr;
typedef struct Cronet_PublicKeyPins Cronet_PublicKeyPins;
typedef struct Cronet_PublicKeyPins* Cronet_PublicKeyPinsPtr;
typedef struct Cronet_TTNetParams Cronet_TTNetParams;
typedef struct Cronet_TTNetParams* Cronet_TTNetParamsPtr;
typedef struct Cronet_AuthCredentials Cronet_AuthCredentials;
typedef struct Cronet_AuthCredentials* Cronet_AuthCredentialsPtr;
typedef struct Cronet_EngineParams Cronet_EngineParams;
typedef struct Cronet_EngineParams* Cronet_EngineParamsPtr;
typedef struct Cronet_HttpHeader Cronet_HttpHeader;
typedef struct Cronet_HttpHeader* Cronet_HttpHeaderPtr;
typedef struct Cronet_Query Cronet_Query;
typedef struct Cronet_Query* Cronet_QueryPtr;
typedef struct Cronet_UrlResponseInfo Cronet_UrlResponseInfo;
typedef struct Cronet_UrlResponseInfo* Cronet_UrlResponseInfoPtr;
typedef struct Cronet_UrlRequestParams Cronet_UrlRequestParams;
typedef struct Cronet_UrlRequestParams* Cronet_UrlRequestParamsPtr;
typedef struct Cronet_DateTime Cronet_DateTime;
typedef struct Cronet_DateTime* Cronet_DateTimePtr;
typedef struct Cronet_Metrics Cronet_Metrics;
typedef struct Cronet_Metrics* Cronet_MetricsPtr;
typedef struct Cronet_RequestFinishedInfo Cronet_RequestFinishedInfo;
typedef struct Cronet_RequestFinishedInfo* Cronet_RequestFinishedInfoPtr;
typedef struct Cronet_TTNetBasicRequestInfo Cronet_TTNetBasicRequestInfo;
typedef struct Cronet_TTNetBasicRequestInfo* Cronet_TTNetBasicRequestInfoPtr;
typedef struct Cronet_PublicIPs Cronet_PublicIPs;
typedef struct Cronet_PublicIPs* Cronet_PublicIPsPtr;
typedef struct Cronet_EventLog Cronet_EventLog;
typedef struct Cronet_EventLog* Cronet_EventLogPtr;
typedef struct Cronet_InnerRequestFinishedInfo Cronet_InnerRequestFinishedInfo;
typedef struct Cronet_InnerRequestFinishedInfo*
    Cronet_InnerRequestFinishedInfoPtr;
typedef struct Cronet_HeaderList Cronet_HeaderList;
typedef struct Cronet_HeaderList* Cronet_HeaderListPtr;
typedef struct Cronet_TTDispatchResult Cronet_TTDispatchResult;
typedef struct Cronet_TTDispatchResult* Cronet_TTDispatchResultPtr;

// Declare enums
typedef enum Cronet_RESULT {
  Cronet_RESULT_SUCCESS = 0,
  Cronet_RESULT_CONCURRENT_REQUESTS = 1,
  Cronet_RESULT_ILLEGAL_ARGUMENT = -100,
  Cronet_RESULT_ILLEGAL_ARGUMENT_STORAGE_PATH_MUST_EXIST = -101,
  Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_PIN = -102,
  Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HOSTNAME = -103,
  Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HTTP_METHOD = -104,
  Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HTTP_HEADER = -105,
  Cronet_RESULT_ILLEGAL_STATE = -200,
  Cronet_RESULT_ILLEGAL_STATE_STORAGE_PATH_IN_USE = -201,
  Cronet_RESULT_ILLEGAL_STATE_CANNOT_SHUTDOWN_ENGINE_FROM_NETWORK_THREAD = -202,
  Cronet_RESULT_ILLEGAL_STATE_ENGINE_ALREADY_STARTED = -203,
  Cronet_RESULT_ILLEGAL_STATE_REQUEST_ALREADY_STARTED = -204,
  Cronet_RESULT_ILLEGAL_STATE_REQUEST_NOT_INITIALIZED = -205,
  Cronet_RESULT_ILLEGAL_STATE_REQUEST_ALREADY_INITIALIZED = -206,
  Cronet_RESULT_ILLEGAL_STATE_REQUEST_NOT_STARTED = -207,
  Cronet_RESULT_ILLEGAL_STATE_UNEXPECTED_REDIRECT = -208,
  Cronet_RESULT_ILLEGAL_STATE_UNEXPECTED_READ = -209,
  Cronet_RESULT_ILLEGAL_STATE_READ_FAILED = -210,
  Cronet_RESULT_NULL_POINTER = -300,
  Cronet_RESULT_NULL_POINTER_HOSTNAME = -301,
  Cronet_RESULT_NULL_POINTER_SHA256_PINS = -302,
  Cronet_RESULT_NULL_POINTER_EXPIRATION_DATE = -303,
  Cronet_RESULT_NULL_POINTER_ENGINE = -304,
  Cronet_RESULT_NULL_POINTER_URL = -305,
  Cronet_RESULT_NULL_POINTER_CALLBACK = -306,
  Cronet_RESULT_NULL_POINTER_EXECUTOR = -307,
  Cronet_RESULT_NULL_POINTER_METHOD = -308,
  Cronet_RESULT_NULL_POINTER_HEADER_NAME = -309,
  Cronet_RESULT_NULL_POINTER_HEADER_VALUE = -310,
  Cronet_RESULT_NULL_POINTER_PARAMS = -311,
  Cronet_RESULT_NULL_POINTER_REQUEST_FINISHED_INFO_LISTENER_EXECUTOR = -312,
} Cronet_RESULT;

typedef enum Cronet_REQUEST_FLAGS {
  Cronet_REQUEST_FLAGS_REQUEST_FLAG_NORMAL = 0,
  Cronet_REQUEST_FLAGS_REQUEST_FLAG_BYPASS_PROXY = 128,
} Cronet_REQUEST_FLAGS;

typedef enum Cronet_NetworkQualityType {
  Cronet_NetworkQualityType_TYPE_FAKE = -1,
  Cronet_NetworkQualityType_TYPE_UNKNOWN = 0,
  Cronet_NetworkQualityType_TYPE_OFFLINE = 1,
  Cronet_NetworkQualityType_TYPE_SLOW_2G = 2,
  Cronet_NetworkQualityType_TYPE_2G,
  Cronet_NetworkQualityType_TYPE_3G,
  Cronet_NetworkQualityType_TYPE_SLOW_4G,
  Cronet_NetworkQualityType_TYPE_MODERATE_4G,
  Cronet_NetworkQualityType_TYPE_GOOD_4G,
  Cronet_NetworkQualityType_TYPE_EXCELLENT_4G,
} Cronet_NetworkQualityType;

typedef enum Cronet_LOG_LEVEL {
  Cronet_LOG_LEVEL_VERBOSE4 = -4,
  Cronet_LOG_LEVEL_VERBOSE3 = -3,
  Cronet_LOG_LEVEL_VERBOSE2 = -2,
  Cronet_LOG_LEVEL_VERBOSE1 = -1,
  Cronet_LOG_LEVEL_INFO = 0,
  Cronet_LOG_LEVEL_WARNING = 1,
  Cronet_LOG_LEVEL_ERROR = 2,
  Cronet_LOG_LEVEL_FATAL = 3,
  Cronet_LOG_LEVEL_NUM_SEVERITIES = 4,
} Cronet_LOG_LEVEL;

typedef enum Cronet_TTUrlDispatchState {
  Cronet_TTUrlDispatchState_SUCCESS = 0,
  Cronet_TTUrlDispatchState_INVALID_ORIGIN_URL = 1,
  Cronet_TTUrlDispatchState_INVALID_FINAL_URL = 4,
} Cronet_TTUrlDispatchState;

typedef enum Cronet_Error_ERROR_CODE {
  Cronet_Error_ERROR_CODE_ERROR_CALLBACK = 0,
  Cronet_Error_ERROR_CODE_ERROR_HOSTNAME_NOT_RESOLVED = 1,
  Cronet_Error_ERROR_CODE_ERROR_INTERNET_DISCONNECTED = 2,
  Cronet_Error_ERROR_CODE_ERROR_NETWORK_CHANGED = 3,
  Cronet_Error_ERROR_CODE_ERROR_TIMED_OUT = 4,
  Cronet_Error_ERROR_CODE_ERROR_CONNECTION_CLOSED = 5,
  Cronet_Error_ERROR_CODE_ERROR_CONNECTION_TIMED_OUT = 6,
  Cronet_Error_ERROR_CODE_ERROR_CONNECTION_REFUSED = 7,
  Cronet_Error_ERROR_CODE_ERROR_CONNECTION_RESET = 8,
  Cronet_Error_ERROR_CODE_ERROR_ADDRESS_UNREACHABLE = 9,
  Cronet_Error_ERROR_CODE_ERROR_QUIC_PROTOCOL_FAILED = 10,
  Cronet_Error_ERROR_CODE_ERROR_OTHER = 11,
  Cronet_Error_ERROR_CODE_ERROR_CONCURRENT_REQUESTS_TIMEOUT = 12,
  Cronet_Error_ERROR_CODE_ERROR_CONCURRENT_REQUESTS_FAILED = 13,
} Cronet_Error_ERROR_CODE;

typedef enum Cronet_EngineParams_HTTP_CACHE_MODE {
  Cronet_EngineParams_HTTP_CACHE_MODE_DISABLED = 0,
  Cronet_EngineParams_HTTP_CACHE_MODE_IN_MEMORY = 1,
  Cronet_EngineParams_HTTP_CACHE_MODE_DISK_NO_HTTP = 2,
  Cronet_EngineParams_HTTP_CACHE_MODE_DISK = 3,
} Cronet_EngineParams_HTTP_CACHE_MODE;

typedef enum Cronet_UrlRequestParams_REQUEST_PRIORITY {
  Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_IDLE = 0,
  Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_LOWEST = 1,
  Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_LOW = 2,
  Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_MEDIUM = 3,
  Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_HIGHEST = 4,
} Cronet_UrlRequestParams_REQUEST_PRIORITY;

typedef enum Cronet_UrlRequestParams_IDEMPOTENCY {
  Cronet_UrlRequestParams_IDEMPOTENCY_DEFAULT_IDEMPOTENCY = 0,
  Cronet_UrlRequestParams_IDEMPOTENCY_IDEMPOTENT = 1,
  Cronet_UrlRequestParams_IDEMPOTENCY_NOT_IDEMPOTENT = 2,
} Cronet_UrlRequestParams_IDEMPOTENCY;

typedef enum Cronet_RequestFinishedInfo_FINISHED_REASON {
  Cronet_RequestFinishedInfo_FINISHED_REASON_SUCCEEDED = 0,
  Cronet_RequestFinishedInfo_FINISHED_REASON_FAILED = 1,
  Cronet_RequestFinishedInfo_FINISHED_REASON_CANCELED = 2,
} Cronet_RequestFinishedInfo_FINISHED_REASON;

typedef enum Cronet_UrlRequestStatusListener_Status {
  Cronet_UrlRequestStatusListener_Status_INVALID = -1,
  Cronet_UrlRequestStatusListener_Status_IDLE = 0,
  Cronet_UrlRequestStatusListener_Status_WAITING_FOR_STALLED_SOCKET_POOL = 1,
  Cronet_UrlRequestStatusListener_Status_WAITING_FOR_AVAILABLE_SOCKET = 2,
  Cronet_UrlRequestStatusListener_Status_WAITING_FOR_DELEGATE = 3,
  Cronet_UrlRequestStatusListener_Status_WAITING_FOR_CACHE = 4,
  Cronet_UrlRequestStatusListener_Status_DOWNLOADING_PAC_FILE = 5,
  Cronet_UrlRequestStatusListener_Status_RESOLVING_PROXY_FOR_URL = 6,
  Cronet_UrlRequestStatusListener_Status_RESOLVING_HOST_IN_PAC_FILE = 7,
  Cronet_UrlRequestStatusListener_Status_ESTABLISHING_PROXY_TUNNEL = 8,
  Cronet_UrlRequestStatusListener_Status_RESOLVING_HOST = 9,
  Cronet_UrlRequestStatusListener_Status_CONNECTING = 10,
  Cronet_UrlRequestStatusListener_Status_SSL_HANDSHAKE = 11,
  Cronet_UrlRequestStatusListener_Status_SENDING_REQUEST = 12,
  Cronet_UrlRequestStatusListener_Status_WAITING_FOR_RESPONSE = 13,
  Cronet_UrlRequestStatusListener_Status_READING_RESPONSE = 14,
} Cronet_UrlRequestStatusListener_Status;

typedef enum Cronet_ConnectionTypeListener_NetworkQualityType {
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_SLOW_2G =
      2,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_2G,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_3G,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_SLOW_4G,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_MODERATE_4G,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_GOOD_4G,
  Cronet_ConnectionTypeListener_NetworkQualityType_NETWORK_QUALITY_TYPE_EXCELLENT_4G,
} Cronet_ConnectionTypeListener_NetworkQualityType;

typedef enum Cronet_MNListener_State {
  Cronet_MNListener_State_STOPPED = -1,
  Cronet_MNListener_State_NETWORK = 0,
  Cronet_MNListener_State_DEFAULT_CELLULAR,
  Cronet_MNListener_State_DEFAULT_WIFI_WITH_CELLULAR_DOWN,
  Cronet_MNListener_State_DEFAULT_WIFI_WITH_CELLULAR_UP,
  Cronet_MNListener_State_WAIT_CELLULAR_ALWAYS_UP,
  Cronet_MNListener_State_WAIT_USER_ENABLE,
  Cronet_MNListener_State_WIFI_WITH_CELLULAR_TRANS_DATA,
  Cronet_MNListener_State_EVALUATE_CELLULAR,
  Cronet_MNListener_State_COUNT,
} Cronet_MNListener_State;

// Declare constants

///////////////////////
// Concrete interface Cronet_Buffer.

// Create an instance of Cronet_Buffer.
CRONET_EXPORT Cronet_BufferPtr Cronet_Buffer_Create(void);
// Destroy an instance of Cronet_Buffer.
CRONET_EXPORT void Cronet_Buffer_Destroy(Cronet_BufferPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_Buffer_SetClientContext(
    Cronet_BufferPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_Buffer_GetClientContext(Cronet_BufferPtr self);
// Concrete methods of Cronet_Buffer implemented by Cronet.
// The app calls them to manipulate Cronet_Buffer.
CRONET_EXPORT
void Cronet_Buffer_InitWithDataAndCallback(Cronet_BufferPtr self,
                                           Cronet_RawDataPtr data,
                                           uint64_t size,
                                           Cronet_BufferCallbackPtr callback);
CRONET_EXPORT
void Cronet_Buffer_InitWithAlloc(Cronet_BufferPtr self, uint64_t size);
CRONET_EXPORT
uint64_t Cronet_Buffer_GetSize(Cronet_BufferPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_Buffer_GetData(Cronet_BufferPtr self);
// Concrete interface Cronet_Buffer is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_Buffer_InitWithDataAndCallbackFunc)(
    Cronet_BufferPtr self,
    Cronet_RawDataPtr data,
    uint64_t size,
    Cronet_BufferCallbackPtr callback);
typedef void (*Cronet_Buffer_InitWithAllocFunc)(Cronet_BufferPtr self,
                                                uint64_t size);
typedef uint64_t (*Cronet_Buffer_GetSizeFunc)(Cronet_BufferPtr self);
typedef Cronet_RawDataPtr (*Cronet_Buffer_GetDataFunc)(Cronet_BufferPtr self);
// Concrete interface Cronet_Buffer is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_BufferPtr Cronet_Buffer_CreateWith(
    Cronet_Buffer_InitWithDataAndCallbackFunc InitWithDataAndCallbackFunc,
    Cronet_Buffer_InitWithAllocFunc InitWithAllocFunc,
    Cronet_Buffer_GetSizeFunc GetSizeFunc,
    Cronet_Buffer_GetDataFunc GetDataFunc);

///////////////////////
// Abstract interface Cronet_BufferCallback is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_BufferCallback.
CRONET_EXPORT void Cronet_BufferCallback_Destroy(Cronet_BufferCallbackPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_BufferCallback_SetClientContext(
    Cronet_BufferCallbackPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_BufferCallback_GetClientContext(Cronet_BufferCallbackPtr self);
// Abstract interface Cronet_BufferCallback is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_BufferCallback_OnDestroy(Cronet_BufferCallbackPtr self,
                                     Cronet_BufferPtr buffer);
// The app implements abstract interface Cronet_BufferCallback by defining
// custom functions for each method.
typedef void (*Cronet_BufferCallback_OnDestroyFunc)(
    Cronet_BufferCallbackPtr self,
    Cronet_BufferPtr buffer);
// The app creates an instance of Cronet_BufferCallback by providing custom
// functions for each method.
CRONET_EXPORT Cronet_BufferCallbackPtr Cronet_BufferCallback_CreateWith(
    Cronet_BufferCallback_OnDestroyFunc OnDestroyFunc);

///////////////////////
// Abstract interface Cronet_Runnable is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_Runnable.
CRONET_EXPORT void Cronet_Runnable_Destroy(Cronet_RunnablePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_Runnable_SetClientContext(
    Cronet_RunnablePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_Runnable_GetClientContext(Cronet_RunnablePtr self);
// Abstract interface Cronet_Runnable is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_Runnable_Run(Cronet_RunnablePtr self);
// The app implements abstract interface Cronet_Runnable by defining custom
// functions for each method.
typedef void (*Cronet_Runnable_RunFunc)(Cronet_RunnablePtr self);
// The app creates an instance of Cronet_Runnable by providing custom functions
// for each method.
CRONET_EXPORT Cronet_RunnablePtr
Cronet_Runnable_CreateWith(Cronet_Runnable_RunFunc RunFunc);

///////////////////////
// Abstract interface Cronet_Executor is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_Executor.
CRONET_EXPORT void Cronet_Executor_Destroy(Cronet_ExecutorPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_Executor_SetClientContext(
    Cronet_ExecutorPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_Executor_GetClientContext(Cronet_ExecutorPtr self);
// Abstract interface Cronet_Executor is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_Executor_Execute(Cronet_ExecutorPtr self,
                             Cronet_RunnablePtr command);
// The app implements abstract interface Cronet_Executor by defining custom
// functions for each method.
typedef void (*Cronet_Executor_ExecuteFunc)(Cronet_ExecutorPtr self,
                                            Cronet_RunnablePtr command);
// The app creates an instance of Cronet_Executor by providing custom functions
// for each method.
CRONET_EXPORT Cronet_ExecutorPtr
Cronet_Executor_CreateWith(Cronet_Executor_ExecuteFunc ExecuteFunc);

///////////////////////
// Concrete interface Cronet_Engine.

// Create an instance of Cronet_Engine.
CRONET_EXPORT Cronet_EnginePtr Cronet_Engine_Create(void);
// Destroy an instance of Cronet_Engine.
CRONET_EXPORT void Cronet_Engine_Destroy(Cronet_EnginePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_Engine_SetClientContext(
    Cronet_EnginePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_Engine_GetClientContext(Cronet_EnginePtr self);
// Concrete methods of Cronet_Engine implemented by Cronet.
// The app calls them to manipulate Cronet_Engine.
CRONET_EXPORT
bool Cronet_Engine_CanStartWithParams(Cronet_EnginePtr self);
CRONET_EXPORT
Cronet_RESULT Cronet_Engine_StartWithParams(Cronet_EnginePtr self,
                                            Cronet_EngineParamsPtr params);
CRONET_EXPORT
bool Cronet_Engine_StartNetLogToFile(Cronet_EnginePtr self,
                                     Cronet_String file_name,
                                     bool log_all);
CRONET_EXPORT
void Cronet_Engine_StopNetLog(Cronet_EnginePtr self);
CRONET_EXPORT
Cronet_RESULT Cronet_Engine_Shutdown(Cronet_EnginePtr self);
CRONET_EXPORT
Cronet_String Cronet_Engine_GetVersionString(Cronet_EnginePtr self);
CRONET_EXPORT
Cronet_String Cronet_Engine_GetDefaultUserAgent(Cronet_EnginePtr self);
CRONET_EXPORT
void Cronet_Engine_AddRequestFinishedListener(
    Cronet_EnginePtr self,
    Cronet_RequestFinishedInfoListenerPtr listener,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveRequestFinishedListener(
    Cronet_EnginePtr self,
    Cronet_RequestFinishedInfoListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_AddNQEListener(Cronet_EnginePtr self,
                                  Cronet_NQEListenerPtr listener,
                                  Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveNQEListener(Cronet_EnginePtr self,
                                     Cronet_NQEListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_AddMNListener(Cronet_EnginePtr self,
                                 Cronet_MNListenerPtr listener,
                                 Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveMNListener(Cronet_EnginePtr self,
                                    Cronet_MNListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_AddStoreRegionListener(
    Cronet_EnginePtr self,
    Cronet_StoreRegionListenerPtr listener,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveStoreRegionListener(
    Cronet_EnginePtr self,
    Cronet_StoreRegionListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_AddConnectionTypeListener(
    Cronet_EnginePtr self,
    Cronet_ConnectionTypeListenerPtr listener,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveConnectionTypeListener(
    Cronet_EnginePtr self,
    Cronet_ConnectionTypeListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_TriggerGetDomain(Cronet_EnginePtr self,
                                    Cronet_TTNetParamsPtr params,
                                    bool force_update);
CRONET_EXPORT
void Cronet_Engine_NotifySwitchToMN(Cronet_EnginePtr self, bool enable);
CRONET_EXPORT
void Cronet_Engine_TriggerWiFiToCellularByThirdParty(Cronet_EnginePtr self);
CRONET_EXPORT
void Cronet_Engine_SetProxyConfig(Cronet_EnginePtr self,
                                  Cronet_String proxy_config);
CRONET_EXPORT
void Cronet_Engine_AddClientOpaqueData(
    Cronet_EnginePtr self,
    Cronet_ClientOpaqueDataPtr client_opaque_data);
CRONET_EXPORT
void Cronet_Engine_ClearClientOpaqueData(Cronet_EnginePtr self);
CRONET_EXPORT
void Cronet_Engine_RemoveClientOpaqueData(Cronet_EnginePtr self,
                                          Cronet_String host);
CRONET_EXPORT
void Cronet_Engine_AddOpaqueDataStoreDynamic(Cronet_EnginePtr self,
                                             Cronet_OpaqueDataPtr opaque_data);
CRONET_EXPORT
void Cronet_Engine_SetInitModeWithInject(Cronet_EnginePtr self, bool inject);
CRONET_EXPORT
void Cronet_Engine_SetInitTimeoutWithInject(Cronet_EnginePtr self,
                                            int32_t init_timeout);
CRONET_EXPORT
void Cronet_Engine_SetLogLevel(Cronet_EnginePtr self,
                               Cronet_LOG_LEVEL log_level);
CRONET_EXPORT
void Cronet_Engine_SetOpaque(Cronet_EnginePtr self,
                             Cronet_RawDataPtr security_callback);
CRONET_EXPORT
void Cronet_Engine_SetWSOpaque(Cronet_EnginePtr self,
                               Cronet_RawDataPtr security_callback);
CRONET_EXPORT
void Cronet_Engine_SetOpaqueFree(Cronet_EnginePtr self,
                                 Cronet_RawDataPtr security_callback);
CRONET_EXPORT
void Cronet_Engine_SetMD5Header(Cronet_EnginePtr self,
                                Cronet_UrlRequestParamsPtr params,
                                Cronet_String buffer,
                                uint64_t length);
CRONET_EXPORT
void Cronet_Engine_RunInBackGround(Cronet_EnginePtr self,
                                   bool is_in_background);
CRONET_EXPORT
void Cronet_Engine_GetRTTAndThroughput(
    Cronet_EnginePtr self,
    Cronet_RTTAndThroughputPtr rtt_and_throughput_out);
CRONET_EXPORT
void Cronet_Engine_GetPacketLostStats(
    Cronet_EnginePtr self,
    Cronet_PacketLostStatsPtr packet_lost_stats_out);
CRONET_EXPORT
Cronet_NetworkQualityType Cronet_Engine_GetEffectiveConnectionType(
    Cronet_EnginePtr self);
CRONET_EXPORT
bool Cronet_Engine_GetNetworkReport(Cronet_EnginePtr self,
                                    Cronet_NetworkReportPtr network_report);
CRONET_EXPORT
void Cronet_Engine_TTDnsResolve(Cronet_EnginePtr self,
                                Cronet_String host,
                                int32_t sdk_id,
                                Cronet_TTDnsResultPtr dns_result_ptr);
CRONET_EXPORT
void Cronet_Engine_AddRequestInfoDelegate(
    Cronet_EnginePtr self,
    Cronet_TTNetRequestInfoDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveRequestInfoDelegate(
    Cronet_EnginePtr self,
    Cronet_TTNetRequestInfoDelegatePtr delegate);
CRONET_EXPORT
void Cronet_Engine_GetPublicIPs(Cronet_EnginePtr self,
                                Cronet_PublicIPsPtr public_ips_out);
CRONET_EXPORT
void Cronet_Engine_AddPublicIPsListener(Cronet_EnginePtr self,
                                        Cronet_PublicIPsListenerPtr listener,
                                        Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemovePublicIPsListener(
    Cronet_EnginePtr self,
    Cronet_PublicIPsListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_SetEnableModifyMode(Cronet_EnginePtr self, bool enable);
CRONET_EXPORT
void Cronet_Engine_AddLogMonitorListener(Cronet_EnginePtr self,
                                         Cronet_LogMonitorListenerPtr listener,
                                         Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveLogMonitorListener(
    Cronet_EnginePtr self,
    Cronet_LogMonitorListenerPtr listener);
CRONET_EXPORT
void Cronet_Engine_UpdateStoreRegionConfigFromResponse(
    Cronet_EnginePtr self,
    Cronet_HeaderListPtr tnc_header,
    Cronet_String tnc_data);
CRONET_EXPORT
void Cronet_Engine_AddTNCConfigListener(Cronet_EnginePtr self,
                                        Cronet_TNCConfigListenerPtr listener,
                                        Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_Engine_RemoveTNCConfigListener(
    Cronet_EnginePtr self,
    Cronet_TNCConfigListenerPtr listener);
CRONET_EXPORT
Cronet_RESULT Cronet_Engine_TTUrlDispatch(
    Cronet_EnginePtr self,
    Cronet_String original_url,
    Cronet_TTUrlDispatchCallbackPtr callback,
    Cronet_ExecutorPtr executor);
// Concrete interface Cronet_Engine is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef bool (*Cronet_Engine_CanStartWithParamsFunc)(Cronet_EnginePtr self);
typedef Cronet_RESULT (*Cronet_Engine_StartWithParamsFunc)(
    Cronet_EnginePtr self,
    Cronet_EngineParamsPtr params);
typedef bool (*Cronet_Engine_StartNetLogToFileFunc)(Cronet_EnginePtr self,
                                                    Cronet_String file_name,
                                                    bool log_all);
typedef void (*Cronet_Engine_StopNetLogFunc)(Cronet_EnginePtr self);
typedef Cronet_RESULT (*Cronet_Engine_ShutdownFunc)(Cronet_EnginePtr self);
typedef Cronet_String (*Cronet_Engine_GetVersionStringFunc)(
    Cronet_EnginePtr self);
typedef Cronet_String (*Cronet_Engine_GetDefaultUserAgentFunc)(
    Cronet_EnginePtr self);
typedef void (*Cronet_Engine_AddRequestFinishedListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_RequestFinishedInfoListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveRequestFinishedListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_RequestFinishedInfoListenerPtr listener);
typedef void (*Cronet_Engine_AddNQEListenerFunc)(Cronet_EnginePtr self,
                                                 Cronet_NQEListenerPtr listener,
                                                 Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveNQEListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_NQEListenerPtr listener);
typedef void (*Cronet_Engine_AddMNListenerFunc)(Cronet_EnginePtr self,
                                                Cronet_MNListenerPtr listener,
                                                Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveMNListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_MNListenerPtr listener);
typedef void (*Cronet_Engine_AddStoreRegionListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_StoreRegionListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveStoreRegionListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_StoreRegionListenerPtr listener);
typedef void (*Cronet_Engine_AddConnectionTypeListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_ConnectionTypeListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveConnectionTypeListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_ConnectionTypeListenerPtr listener);
typedef void (*Cronet_Engine_TriggerGetDomainFunc)(Cronet_EnginePtr self,
                                                   Cronet_TTNetParamsPtr params,
                                                   bool force_update);
typedef void (*Cronet_Engine_NotifySwitchToMNFunc)(Cronet_EnginePtr self,
                                                   bool enable);
typedef void (*Cronet_Engine_TriggerWiFiToCellularByThirdPartyFunc)(
    Cronet_EnginePtr self);
typedef void (*Cronet_Engine_SetProxyConfigFunc)(Cronet_EnginePtr self,
                                                 Cronet_String proxy_config);
typedef void (*Cronet_Engine_AddClientOpaqueDataFunc)(
    Cronet_EnginePtr self,
    Cronet_ClientOpaqueDataPtr client_opaque_data);
typedef void (*Cronet_Engine_ClearClientOpaqueDataFunc)(Cronet_EnginePtr self);
typedef void (*Cronet_Engine_RemoveClientOpaqueDataFunc)(Cronet_EnginePtr self,
                                                         Cronet_String host);
typedef void (*Cronet_Engine_AddOpaqueDataStoreDynamicFunc)(
    Cronet_EnginePtr self,
    Cronet_OpaqueDataPtr opaque_data);
typedef void (*Cronet_Engine_SetInitModeWithInjectFunc)(Cronet_EnginePtr self,
                                                        bool inject);
typedef void (*Cronet_Engine_SetInitTimeoutWithInjectFunc)(
    Cronet_EnginePtr self,
    int32_t init_timeout);
typedef void (*Cronet_Engine_SetLogLevelFunc)(Cronet_EnginePtr self,
                                              Cronet_LOG_LEVEL log_level);
typedef void (*Cronet_Engine_SetOpaqueFunc)(
    Cronet_EnginePtr self,
    Cronet_RawDataPtr security_callback);
typedef void (*Cronet_Engine_SetWSOpaqueFunc)(
    Cronet_EnginePtr self,
    Cronet_RawDataPtr security_callback);
typedef void (*Cronet_Engine_SetOpaqueFreeFunc)(
    Cronet_EnginePtr self,
    Cronet_RawDataPtr security_callback);
typedef void (*Cronet_Engine_SetMD5HeaderFunc)(
    Cronet_EnginePtr self,
    Cronet_UrlRequestParamsPtr params,
    Cronet_String buffer,
    uint64_t length);
typedef void (*Cronet_Engine_RunInBackGroundFunc)(Cronet_EnginePtr self,
                                                  bool is_in_background);
typedef void (*Cronet_Engine_GetRTTAndThroughputFunc)(
    Cronet_EnginePtr self,
    Cronet_RTTAndThroughputPtr rtt_and_throughput_out);
typedef void (*Cronet_Engine_GetPacketLostStatsFunc)(
    Cronet_EnginePtr self,
    Cronet_PacketLostStatsPtr packet_lost_stats_out);
typedef Cronet_NetworkQualityType (
    *Cronet_Engine_GetEffectiveConnectionTypeFunc)(Cronet_EnginePtr self);
typedef bool (*Cronet_Engine_GetNetworkReportFunc)(
    Cronet_EnginePtr self,
    Cronet_NetworkReportPtr network_report);
typedef void (*Cronet_Engine_TTDnsResolveFunc)(
    Cronet_EnginePtr self,
    Cronet_String host,
    int32_t sdk_id,
    Cronet_TTDnsResultPtr dns_result_ptr);
typedef void (*Cronet_Engine_AddRequestInfoDelegateFunc)(
    Cronet_EnginePtr self,
    Cronet_TTNetRequestInfoDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveRequestInfoDelegateFunc)(
    Cronet_EnginePtr self,
    Cronet_TTNetRequestInfoDelegatePtr delegate);
typedef void (*Cronet_Engine_GetPublicIPsFunc)(
    Cronet_EnginePtr self,
    Cronet_PublicIPsPtr public_ips_out);
typedef void (*Cronet_Engine_AddPublicIPsListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_PublicIPsListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemovePublicIPsListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_PublicIPsListenerPtr listener);
typedef void (*Cronet_Engine_SetEnableModifyModeFunc)(Cronet_EnginePtr self,
                                                      bool enable);
typedef void (*Cronet_Engine_AddLogMonitorListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_LogMonitorListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveLogMonitorListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_LogMonitorListenerPtr listener);
typedef void (*Cronet_Engine_UpdateStoreRegionConfigFromResponseFunc)(
    Cronet_EnginePtr self,
    Cronet_HeaderListPtr tnc_header,
    Cronet_String tnc_data);
typedef void (*Cronet_Engine_AddTNCConfigListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_TNCConfigListenerPtr listener,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_Engine_RemoveTNCConfigListenerFunc)(
    Cronet_EnginePtr self,
    Cronet_TNCConfigListenerPtr listener);
typedef Cronet_RESULT (*Cronet_Engine_TTUrlDispatchFunc)(
    Cronet_EnginePtr self,
    Cronet_String original_url,
    Cronet_TTUrlDispatchCallbackPtr callback,
    Cronet_ExecutorPtr executor);
// Concrete interface Cronet_Engine is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_EnginePtr Cronet_Engine_CreateWith(
    Cronet_Engine_CanStartWithParamsFunc CanStartWithParamsFunc,
    Cronet_Engine_StartWithParamsFunc StartWithParamsFunc,
    Cronet_Engine_StartNetLogToFileFunc StartNetLogToFileFunc,
    Cronet_Engine_StopNetLogFunc StopNetLogFunc,
    Cronet_Engine_ShutdownFunc ShutdownFunc,
    Cronet_Engine_GetVersionStringFunc GetVersionStringFunc,
    Cronet_Engine_GetDefaultUserAgentFunc GetDefaultUserAgentFunc,
    Cronet_Engine_AddRequestFinishedListenerFunc AddRequestFinishedListenerFunc,
    Cronet_Engine_RemoveRequestFinishedListenerFunc
        RemoveRequestFinishedListenerFunc,
    Cronet_Engine_AddNQEListenerFunc AddNQEListenerFunc,
    Cronet_Engine_RemoveNQEListenerFunc RemoveNQEListenerFunc,
    Cronet_Engine_AddMNListenerFunc AddMNListenerFunc,
    Cronet_Engine_RemoveMNListenerFunc RemoveMNListenerFunc,
    Cronet_Engine_AddStoreRegionListenerFunc AddStoreRegionListenerFunc,
    Cronet_Engine_RemoveStoreRegionListenerFunc RemoveStoreRegionListenerFunc,
    Cronet_Engine_AddConnectionTypeListenerFunc AddConnectionTypeListenerFunc,
    Cronet_Engine_RemoveConnectionTypeListenerFunc
        RemoveConnectionTypeListenerFunc,
    Cronet_Engine_TriggerGetDomainFunc TriggerGetDomainFunc,
    Cronet_Engine_NotifySwitchToMNFunc NotifySwitchToMNFunc,
    Cronet_Engine_TriggerWiFiToCellularByThirdPartyFunc
        TriggerWiFiToCellularByThirdPartyFunc,
    Cronet_Engine_SetProxyConfigFunc SetProxyConfigFunc,
    Cronet_Engine_AddClientOpaqueDataFunc AddClientOpaqueDataFunc,
    Cronet_Engine_ClearClientOpaqueDataFunc ClearClientOpaqueDataFunc,
    Cronet_Engine_RemoveClientOpaqueDataFunc RemoveClientOpaqueDataFunc,
    Cronet_Engine_AddOpaqueDataStoreDynamicFunc AddOpaqueDataStoreDynamicFunc,
    Cronet_Engine_SetInitModeWithInjectFunc SetInitModeWithInjectFunc,
    Cronet_Engine_SetInitTimeoutWithInjectFunc SetInitTimeoutWithInjectFunc,
    Cronet_Engine_SetLogLevelFunc SetLogLevelFunc,
    Cronet_Engine_SetOpaqueFunc SetOpaqueFunc,
    Cronet_Engine_SetWSOpaqueFunc SetWSOpaqueFunc,
    Cronet_Engine_SetOpaqueFreeFunc SetOpaqueFreeFunc,
    Cronet_Engine_SetMD5HeaderFunc SetMD5HeaderFunc,
    Cronet_Engine_RunInBackGroundFunc RunInBackGroundFunc,
    Cronet_Engine_GetRTTAndThroughputFunc GetRTTAndThroughputFunc,
    Cronet_Engine_GetPacketLostStatsFunc GetPacketLostStatsFunc,
    Cronet_Engine_GetEffectiveConnectionTypeFunc GetEffectiveConnectionTypeFunc,
    Cronet_Engine_GetNetworkReportFunc GetNetworkReportFunc,
    Cronet_Engine_TTDnsResolveFunc TTDnsResolveFunc,
    Cronet_Engine_AddRequestInfoDelegateFunc AddRequestInfoDelegateFunc,
    Cronet_Engine_RemoveRequestInfoDelegateFunc RemoveRequestInfoDelegateFunc,
    Cronet_Engine_GetPublicIPsFunc GetPublicIPsFunc,
    Cronet_Engine_AddPublicIPsListenerFunc AddPublicIPsListenerFunc,
    Cronet_Engine_RemovePublicIPsListenerFunc RemovePublicIPsListenerFunc,
    Cronet_Engine_SetEnableModifyModeFunc SetEnableModifyModeFunc,
    Cronet_Engine_AddLogMonitorListenerFunc AddLogMonitorListenerFunc,
    Cronet_Engine_RemoveLogMonitorListenerFunc RemoveLogMonitorListenerFunc,
    Cronet_Engine_UpdateStoreRegionConfigFromResponseFunc
        UpdateStoreRegionConfigFromResponseFunc,
    Cronet_Engine_AddTNCConfigListenerFunc AddTNCConfigListenerFunc,
    Cronet_Engine_RemoveTNCConfigListenerFunc RemoveTNCConfigListenerFunc,
    Cronet_Engine_TTUrlDispatchFunc TTUrlDispatchFunc);

///////////////////////
// Abstract interface Cronet_UrlRequestStatusListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_UrlRequestStatusListener.
CRONET_EXPORT void Cronet_UrlRequestStatusListener_Destroy(
    Cronet_UrlRequestStatusListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UrlRequestStatusListener_SetClientContext(
    Cronet_UrlRequestStatusListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UrlRequestStatusListener_GetClientContext(
    Cronet_UrlRequestStatusListenerPtr self);
// Abstract interface Cronet_UrlRequestStatusListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_UrlRequestStatusListener_OnStatus(
    Cronet_UrlRequestStatusListenerPtr self,
    Cronet_UrlRequestStatusListener_Status status);
// The app implements abstract interface Cronet_UrlRequestStatusListener by
// defining custom functions for each method.
typedef void (*Cronet_UrlRequestStatusListener_OnStatusFunc)(
    Cronet_UrlRequestStatusListenerPtr self,
    Cronet_UrlRequestStatusListener_Status status);
// The app creates an instance of Cronet_UrlRequestStatusListener by providing
// custom functions for each method.
CRONET_EXPORT Cronet_UrlRequestStatusListenerPtr
Cronet_UrlRequestStatusListener_CreateWith(
    Cronet_UrlRequestStatusListener_OnStatusFunc OnStatusFunc);

///////////////////////
// Abstract interface Cronet_UrlRequestCallback is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_UrlRequestCallback.
CRONET_EXPORT void Cronet_UrlRequestCallback_Destroy(
    Cronet_UrlRequestCallbackPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UrlRequestCallback_SetClientContext(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UrlRequestCallback_GetClientContext(Cronet_UrlRequestCallbackPtr self);
// Abstract interface Cronet_UrlRequestCallback is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnRedirectReceived(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info,
    Cronet_String new_location_url);
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnResponseStarted(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info);
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnReadCompleted(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info,
    Cronet_BufferPtr buffer,
    uint64_t bytes_read);
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnSucceeded(Cronet_UrlRequestCallbackPtr self,
                                           Cronet_UrlRequestPtr request,
                                           Cronet_UrlResponseInfoPtr info);
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnFailed(Cronet_UrlRequestCallbackPtr self,
                                        Cronet_UrlRequestPtr request,
                                        Cronet_UrlResponseInfoPtr info,
                                        Cronet_ErrorPtr error);
CRONET_EXPORT
void Cronet_UrlRequestCallback_OnCanceled(Cronet_UrlRequestCallbackPtr self,
                                          Cronet_UrlRequestPtr request,
                                          Cronet_UrlResponseInfoPtr info);
// The app implements abstract interface Cronet_UrlRequestCallback by defining
// custom functions for each method.
typedef void (*Cronet_UrlRequestCallback_OnRedirectReceivedFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info,
    Cronet_String new_location_url);
typedef void (*Cronet_UrlRequestCallback_OnResponseStartedFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info);
typedef void (*Cronet_UrlRequestCallback_OnReadCompletedFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info,
    Cronet_BufferPtr buffer,
    uint64_t bytes_read);
typedef void (*Cronet_UrlRequestCallback_OnSucceededFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info);
typedef void (*Cronet_UrlRequestCallback_OnFailedFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info,
    Cronet_ErrorPtr error);
typedef void (*Cronet_UrlRequestCallback_OnCanceledFunc)(
    Cronet_UrlRequestCallbackPtr self,
    Cronet_UrlRequestPtr request,
    Cronet_UrlResponseInfoPtr info);
// The app creates an instance of Cronet_UrlRequestCallback by providing custom
// functions for each method.
CRONET_EXPORT Cronet_UrlRequestCallbackPtr Cronet_UrlRequestCallback_CreateWith(
    Cronet_UrlRequestCallback_OnRedirectReceivedFunc OnRedirectReceivedFunc,
    Cronet_UrlRequestCallback_OnResponseStartedFunc OnResponseStartedFunc,
    Cronet_UrlRequestCallback_OnReadCompletedFunc OnReadCompletedFunc,
    Cronet_UrlRequestCallback_OnSucceededFunc OnSucceededFunc,
    Cronet_UrlRequestCallback_OnFailedFunc OnFailedFunc,
    Cronet_UrlRequestCallback_OnCanceledFunc OnCanceledFunc);

///////////////////////
// Concrete interface Cronet_UploadDataSink.

// Create an instance of Cronet_UploadDataSink.
CRONET_EXPORT Cronet_UploadDataSinkPtr Cronet_UploadDataSink_Create(void);
// Destroy an instance of Cronet_UploadDataSink.
CRONET_EXPORT void Cronet_UploadDataSink_Destroy(Cronet_UploadDataSinkPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UploadDataSink_SetClientContext(
    Cronet_UploadDataSinkPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UploadDataSink_GetClientContext(Cronet_UploadDataSinkPtr self);
// Concrete methods of Cronet_UploadDataSink implemented by Cronet.
// The app calls them to manipulate Cronet_UploadDataSink.
CRONET_EXPORT
void Cronet_UploadDataSink_OnReadSucceeded(Cronet_UploadDataSinkPtr self,
                                           uint64_t bytes_read,
                                           bool final_chunk);
CRONET_EXPORT
void Cronet_UploadDataSink_OnReadError(Cronet_UploadDataSinkPtr self,
                                       Cronet_String error_message);
CRONET_EXPORT
void Cronet_UploadDataSink_OnRewindSucceeded(Cronet_UploadDataSinkPtr self);
CRONET_EXPORT
void Cronet_UploadDataSink_OnRewindError(Cronet_UploadDataSinkPtr self,
                                         Cronet_String error_message);
// Concrete interface Cronet_UploadDataSink is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_UploadDataSink_OnReadSucceededFunc)(
    Cronet_UploadDataSinkPtr self,
    uint64_t bytes_read,
    bool final_chunk);
typedef void (*Cronet_UploadDataSink_OnReadErrorFunc)(
    Cronet_UploadDataSinkPtr self,
    Cronet_String error_message);
typedef void (*Cronet_UploadDataSink_OnRewindSucceededFunc)(
    Cronet_UploadDataSinkPtr self);
typedef void (*Cronet_UploadDataSink_OnRewindErrorFunc)(
    Cronet_UploadDataSinkPtr self,
    Cronet_String error_message);
// Concrete interface Cronet_UploadDataSink is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_UploadDataSinkPtr Cronet_UploadDataSink_CreateWith(
    Cronet_UploadDataSink_OnReadSucceededFunc OnReadSucceededFunc,
    Cronet_UploadDataSink_OnReadErrorFunc OnReadErrorFunc,
    Cronet_UploadDataSink_OnRewindSucceededFunc OnRewindSucceededFunc,
    Cronet_UploadDataSink_OnRewindErrorFunc OnRewindErrorFunc);

///////////////////////
// Abstract interface Cronet_UploadDataProvider is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_UploadDataProvider.
CRONET_EXPORT void Cronet_UploadDataProvider_Destroy(
    Cronet_UploadDataProviderPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UploadDataProvider_SetClientContext(
    Cronet_UploadDataProviderPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UploadDataProvider_GetClientContext(Cronet_UploadDataProviderPtr self);
// Abstract interface Cronet_UploadDataProvider is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
int64_t Cronet_UploadDataProvider_GetLength(Cronet_UploadDataProviderPtr self);
CRONET_EXPORT
void Cronet_UploadDataProvider_Read(Cronet_UploadDataProviderPtr self,
                                    Cronet_UploadDataSinkPtr upload_data_sink,
                                    Cronet_BufferPtr buffer);
CRONET_EXPORT
void Cronet_UploadDataProvider_Rewind(
    Cronet_UploadDataProviderPtr self,
    Cronet_UploadDataSinkPtr upload_data_sink);
CRONET_EXPORT
void Cronet_UploadDataProvider_Close(Cronet_UploadDataProviderPtr self);
// The app implements abstract interface Cronet_UploadDataProvider by defining
// custom functions for each method.
typedef int64_t (*Cronet_UploadDataProvider_GetLengthFunc)(
    Cronet_UploadDataProviderPtr self);
typedef void (*Cronet_UploadDataProvider_ReadFunc)(
    Cronet_UploadDataProviderPtr self,
    Cronet_UploadDataSinkPtr upload_data_sink,
    Cronet_BufferPtr buffer);
typedef void (*Cronet_UploadDataProvider_RewindFunc)(
    Cronet_UploadDataProviderPtr self,
    Cronet_UploadDataSinkPtr upload_data_sink);
typedef void (*Cronet_UploadDataProvider_CloseFunc)(
    Cronet_UploadDataProviderPtr self);
// The app creates an instance of Cronet_UploadDataProvider by providing custom
// functions for each method.
CRONET_EXPORT Cronet_UploadDataProviderPtr Cronet_UploadDataProvider_CreateWith(
    Cronet_UploadDataProvider_GetLengthFunc GetLengthFunc,
    Cronet_UploadDataProvider_ReadFunc ReadFunc,
    Cronet_UploadDataProvider_RewindFunc RewindFunc,
    Cronet_UploadDataProvider_CloseFunc CloseFunc);

///////////////////////
// Concrete interface Cronet_UrlRequest.

// Create an instance of Cronet_UrlRequest.
CRONET_EXPORT Cronet_UrlRequestPtr Cronet_UrlRequest_Create(void);
// Destroy an instance of Cronet_UrlRequest.
CRONET_EXPORT void Cronet_UrlRequest_Destroy(Cronet_UrlRequestPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UrlRequest_SetClientContext(
    Cronet_UrlRequestPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UrlRequest_GetClientContext(Cronet_UrlRequestPtr self);
// Concrete methods of Cronet_UrlRequest implemented by Cronet.
// The app calls them to manipulate Cronet_UrlRequest.
CRONET_EXPORT
Cronet_RESULT Cronet_UrlRequest_InitWithParams(
    Cronet_UrlRequestPtr self,
    Cronet_EnginePtr engine,
    Cronet_String url,
    Cronet_UrlRequestParamsPtr params,
    Cronet_UrlRequestCallbackPtr callback,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
Cronet_RESULT Cronet_UrlRequest_Start(Cronet_UrlRequestPtr self);
CRONET_EXPORT
Cronet_RESULT Cronet_UrlRequest_FollowRedirect(Cronet_UrlRequestPtr self);
CRONET_EXPORT
Cronet_RESULT Cronet_UrlRequest_Read(Cronet_UrlRequestPtr self,
                                     Cronet_BufferPtr buffer);
CRONET_EXPORT
void Cronet_UrlRequest_Cancel(Cronet_UrlRequestPtr self);
CRONET_EXPORT
bool Cronet_UrlRequest_IsDone(Cronet_UrlRequestPtr self);
CRONET_EXPORT
void Cronet_UrlRequest_GetStatus(Cronet_UrlRequestPtr self,
                                 Cronet_UrlRequestStatusListenerPtr listener);
CRONET_EXPORT
Cronet_String Cronet_UrlRequest_GetRequestLog(Cronet_UrlRequestPtr self);
CRONET_EXPORT
void Cronet_UrlRequest_Destroy(Cronet_UrlRequestPtr self);
CRONET_EXPORT
void Cronet_UrlRequest_RemoveRequestCookieHeader(Cronet_UrlRequestPtr self);
CRONET_EXPORT
void Cronet_UrlRequest_AddRequestCookieHeader(Cronet_UrlRequestPtr self,
                                              Cronet_String name,
                                              Cronet_String value);
// Concrete interface Cronet_UrlRequest is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef Cronet_RESULT (*Cronet_UrlRequest_InitWithParamsFunc)(
    Cronet_UrlRequestPtr self,
    Cronet_EnginePtr engine,
    Cronet_String url,
    Cronet_UrlRequestParamsPtr params,
    Cronet_UrlRequestCallbackPtr callback,
    Cronet_ExecutorPtr executor);
typedef Cronet_RESULT (*Cronet_UrlRequest_StartFunc)(Cronet_UrlRequestPtr self);
typedef Cronet_RESULT (*Cronet_UrlRequest_FollowRedirectFunc)(
    Cronet_UrlRequestPtr self);
typedef Cronet_RESULT (*Cronet_UrlRequest_ReadFunc)(Cronet_UrlRequestPtr self,
                                                    Cronet_BufferPtr buffer);
typedef void (*Cronet_UrlRequest_CancelFunc)(Cronet_UrlRequestPtr self);
typedef bool (*Cronet_UrlRequest_IsDoneFunc)(Cronet_UrlRequestPtr self);
typedef void (*Cronet_UrlRequest_GetStatusFunc)(
    Cronet_UrlRequestPtr self,
    Cronet_UrlRequestStatusListenerPtr listener);
typedef Cronet_String (*Cronet_UrlRequest_GetRequestLogFunc)(
    Cronet_UrlRequestPtr self);
typedef void (*Cronet_UrlRequest_DestroyFunc)(Cronet_UrlRequestPtr self);
typedef void (*Cronet_UrlRequest_RemoveRequestCookieHeaderFunc)(
    Cronet_UrlRequestPtr self);
typedef void (*Cronet_UrlRequest_AddRequestCookieHeaderFunc)(
    Cronet_UrlRequestPtr self,
    Cronet_String name,
    Cronet_String value);
// Concrete interface Cronet_UrlRequest is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_UrlRequestPtr Cronet_UrlRequest_CreateWith(
    Cronet_UrlRequest_InitWithParamsFunc InitWithParamsFunc,
    Cronet_UrlRequest_StartFunc StartFunc,
    Cronet_UrlRequest_FollowRedirectFunc FollowRedirectFunc,
    Cronet_UrlRequest_ReadFunc ReadFunc,
    Cronet_UrlRequest_CancelFunc CancelFunc,
    Cronet_UrlRequest_IsDoneFunc IsDoneFunc,
    Cronet_UrlRequest_GetStatusFunc GetStatusFunc,
    Cronet_UrlRequest_GetRequestLogFunc GetRequestLogFunc,
    Cronet_UrlRequest_DestroyFunc DestroyFunc,
    Cronet_UrlRequest_RemoveRequestCookieHeaderFunc
        RemoveRequestCookieHeaderFunc,
    Cronet_UrlRequest_AddRequestCookieHeaderFunc AddRequestCookieHeaderFunc);

///////////////////////
// Abstract interface Cronet_RequestFinishedInfoListener is implemented by the
// app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_RequestFinishedInfoListener.
CRONET_EXPORT void Cronet_RequestFinishedInfoListener_Destroy(
    Cronet_RequestFinishedInfoListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_RequestFinishedInfoListener_SetClientContext(
    Cronet_RequestFinishedInfoListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_RequestFinishedInfoListener_GetClientContext(
    Cronet_RequestFinishedInfoListenerPtr self);
// Abstract interface Cronet_RequestFinishedInfoListener is implemented by the
// app. The following concrete methods forward call to app implementation. The
// app doesn't normally call them.
CRONET_EXPORT
void Cronet_RequestFinishedInfoListener_OnRequestFinished(
    Cronet_RequestFinishedInfoListenerPtr self,
    Cronet_RequestFinishedInfoPtr request_info,
    Cronet_UrlResponseInfoPtr response_info,
    Cronet_ErrorPtr error);
// The app implements abstract interface Cronet_RequestFinishedInfoListener by
// defining custom functions for each method.
typedef void (*Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc)(
    Cronet_RequestFinishedInfoListenerPtr self,
    Cronet_RequestFinishedInfoPtr request_info,
    Cronet_UrlResponseInfoPtr response_info,
    Cronet_ErrorPtr error);
// The app creates an instance of Cronet_RequestFinishedInfoListener by
// providing custom functions for each method.
CRONET_EXPORT Cronet_RequestFinishedInfoListenerPtr
Cronet_RequestFinishedInfoListener_CreateWith(
    Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc
        OnRequestFinishedFunc);

///////////////////////
// Abstract interface Cronet_ConnectionTypeListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_ConnectionTypeListener.
CRONET_EXPORT void Cronet_ConnectionTypeListener_Destroy(
    Cronet_ConnectionTypeListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_ConnectionTypeListener_SetClientContext(
    Cronet_ConnectionTypeListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_ConnectionTypeListener_GetClientContext(
    Cronet_ConnectionTypeListenerPtr self);
// Abstract interface Cronet_ConnectionTypeListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_ConnectionTypeListener_OnConnectionTypeChanged(
    Cronet_ConnectionTypeListenerPtr self,
    Cronet_ConnectionTypeListener_NetworkQualityType type);
// The app implements abstract interface Cronet_ConnectionTypeListener by
// defining custom functions for each method.
typedef void (*Cronet_ConnectionTypeListener_OnConnectionTypeChangedFunc)(
    Cronet_ConnectionTypeListenerPtr self,
    Cronet_ConnectionTypeListener_NetworkQualityType type);
// The app creates an instance of Cronet_ConnectionTypeListener by providing
// custom functions for each method.
CRONET_EXPORT Cronet_ConnectionTypeListenerPtr
Cronet_ConnectionTypeListener_CreateWith(
    Cronet_ConnectionTypeListener_OnConnectionTypeChangedFunc
        OnConnectionTypeChangedFunc);

///////////////////////
// Abstract interface Cronet_NQEListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_NQEListener.
CRONET_EXPORT void Cronet_NQEListener_Destroy(Cronet_NQEListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_NQEListener_SetClientContext(
    Cronet_NQEListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_NQEListener_GetClientContext(Cronet_NQEListenerPtr self);
// Abstract interface Cronet_NQEListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_NQEListener_OnEffectiveConnectionTypeChanged(
    Cronet_NQEListenerPtr self,
    Cronet_NetworkQualityType type);
CRONET_EXPORT
void Cronet_NQEListener_OnRTTOrThroughputEstimatesComputed(
    Cronet_NQEListenerPtr self,
    Cronet_RTTAndThroughputPtr rtt_and_throughput);
CRONET_EXPORT
void Cronet_NQEListener_OnPacketLossComputed(
    Cronet_NQEListenerPtr self,
    Cronet_PacketLostStatsPtr packet_lost_stats);
// The app implements abstract interface Cronet_NQEListener by defining custom
// functions for each method.
typedef void (*Cronet_NQEListener_OnEffectiveConnectionTypeChangedFunc)(
    Cronet_NQEListenerPtr self,
    Cronet_NetworkQualityType type);
typedef void (*Cronet_NQEListener_OnRTTOrThroughputEstimatesComputedFunc)(
    Cronet_NQEListenerPtr self,
    Cronet_RTTAndThroughputPtr rtt_and_throughput);
typedef void (*Cronet_NQEListener_OnPacketLossComputedFunc)(
    Cronet_NQEListenerPtr self,
    Cronet_PacketLostStatsPtr packet_lost_stats);
// The app creates an instance of Cronet_NQEListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_NQEListenerPtr Cronet_NQEListener_CreateWith(
    Cronet_NQEListener_OnEffectiveConnectionTypeChangedFunc
        OnEffectiveConnectionTypeChangedFunc,
    Cronet_NQEListener_OnRTTOrThroughputEstimatesComputedFunc
        OnRTTOrThroughputEstimatesComputedFunc,
    Cronet_NQEListener_OnPacketLossComputedFunc OnPacketLossComputedFunc);

///////////////////////
// Abstract interface Cronet_MNListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_MNListener.
CRONET_EXPORT void Cronet_MNListener_Destroy(Cronet_MNListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_MNListener_SetClientContext(
    Cronet_MNListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_MNListener_GetClientContext(Cronet_MNListenerPtr self);
// Abstract interface Cronet_MNListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_MNListener_OnMNStateChanged(Cronet_MNListenerPtr self,
                                        Cronet_MNListener_State previous_state,
                                        Cronet_MNListener_State current_state);
// The app implements abstract interface Cronet_MNListener by defining custom
// functions for each method.
typedef void (*Cronet_MNListener_OnMNStateChangedFunc)(
    Cronet_MNListenerPtr self,
    Cronet_MNListener_State previous_state,
    Cronet_MNListener_State current_state);
// The app creates an instance of Cronet_MNListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_MNListenerPtr Cronet_MNListener_CreateWith(
    Cronet_MNListener_OnMNStateChangedFunc OnMNStateChangedFunc);

///////////////////////
// Abstract interface Cronet_StoreRegionListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_StoreRegionListener.
CRONET_EXPORT void Cronet_StoreRegionListener_Destroy(
    Cronet_StoreRegionListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_StoreRegionListener_SetClientContext(
    Cronet_StoreRegionListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_StoreRegionListener_GetClientContext(Cronet_StoreRegionListenerPtr self);
// Abstract interface Cronet_StoreRegionListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_StoreRegionListener_OnStoreRegionChanged(
    Cronet_StoreRegionListenerPtr self,
    Cronet_String store_region,
    Cronet_String source);
// The app implements abstract interface Cronet_StoreRegionListener by defining
// custom functions for each method.
typedef void (*Cronet_StoreRegionListener_OnStoreRegionChangedFunc)(
    Cronet_StoreRegionListenerPtr self,
    Cronet_String store_region,
    Cronet_String source);
// The app creates an instance of Cronet_StoreRegionListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_StoreRegionListenerPtr
Cronet_StoreRegionListener_CreateWith(
    Cronet_StoreRegionListener_OnStoreRegionChangedFunc
        OnStoreRegionChangedFunc);

///////////////////////
// Abstract interface Cronet_TTNetRequestInfoDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TTNetRequestInfoDelegate.
CRONET_EXPORT void Cronet_TTNetRequestInfoDelegate_Destroy(
    Cronet_TTNetRequestInfoDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TTNetRequestInfoDelegate_SetClientContext(
    Cronet_TTNetRequestInfoDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TTNetRequestInfoDelegate_GetClientContext(
    Cronet_TTNetRequestInfoDelegatePtr self);
// Abstract interface Cronet_TTNetRequestInfoDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TTNetRequestInfoDelegate_OnRequestInfoNotify(
    Cronet_TTNetRequestInfoDelegatePtr self,
    Cronet_TTNetBasicRequestInfoPtr info);
// The app implements abstract interface Cronet_TTNetRequestInfoDelegate by
// defining custom functions for each method.
typedef void (*Cronet_TTNetRequestInfoDelegate_OnRequestInfoNotifyFunc)(
    Cronet_TTNetRequestInfoDelegatePtr self,
    Cronet_TTNetBasicRequestInfoPtr info);
// The app creates an instance of Cronet_TTNetRequestInfoDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_TTNetRequestInfoDelegatePtr
Cronet_TTNetRequestInfoDelegate_CreateWith(
    Cronet_TTNetRequestInfoDelegate_OnRequestInfoNotifyFunc
        OnRequestInfoNotifyFunc);

///////////////////////
// Abstract interface Cronet_PublicIPsListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_PublicIPsListener.
CRONET_EXPORT void Cronet_PublicIPsListener_Destroy(
    Cronet_PublicIPsListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_PublicIPsListener_SetClientContext(
    Cronet_PublicIPsListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_PublicIPsListener_GetClientContext(Cronet_PublicIPsListenerPtr self);
// Abstract interface Cronet_PublicIPsListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_PublicIPsListener_OnPublicIPsChanged(
    Cronet_PublicIPsListenerPtr self,
    Cronet_PublicIPsPtr public_ips);
// The app implements abstract interface Cronet_PublicIPsListener by defining
// custom functions for each method.
typedef void (*Cronet_PublicIPsListener_OnPublicIPsChangedFunc)(
    Cronet_PublicIPsListenerPtr self,
    Cronet_PublicIPsPtr public_ips);
// The app creates an instance of Cronet_PublicIPsListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_PublicIPsListenerPtr Cronet_PublicIPsListener_CreateWith(
    Cronet_PublicIPsListener_OnPublicIPsChangedFunc OnPublicIPsChangedFunc);

///////////////////////
// Abstract interface Cronet_LogMonitorListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_LogMonitorListener.
CRONET_EXPORT void Cronet_LogMonitorListener_Destroy(
    Cronet_LogMonitorListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_LogMonitorListener_SetClientContext(
    Cronet_LogMonitorListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_LogMonitorListener_GetClientContext(Cronet_LogMonitorListenerPtr self);
// Abstract interface Cronet_LogMonitorListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_LogMonitorListener_OnEventLogReceived(
    Cronet_LogMonitorListenerPtr self,
    Cronet_EventLogPtr log);
CRONET_EXPORT
void Cronet_LogMonitorListener_OnInnerRequestFinished(
    Cronet_LogMonitorListenerPtr self,
    Cronet_InnerRequestFinishedInfoPtr info);
// The app implements abstract interface Cronet_LogMonitorListener by defining
// custom functions for each method.
typedef void (*Cronet_LogMonitorListener_OnEventLogReceivedFunc)(
    Cronet_LogMonitorListenerPtr self,
    Cronet_EventLogPtr log);
typedef void (*Cronet_LogMonitorListener_OnInnerRequestFinishedFunc)(
    Cronet_LogMonitorListenerPtr self,
    Cronet_InnerRequestFinishedInfoPtr info);
// The app creates an instance of Cronet_LogMonitorListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_LogMonitorListenerPtr Cronet_LogMonitorListener_CreateWith(
    Cronet_LogMonitorListener_OnEventLogReceivedFunc OnEventLogReceivedFunc,
    Cronet_LogMonitorListener_OnInnerRequestFinishedFunc
        OnInnerRequestFinishedFunc);

///////////////////////
// Abstract interface Cronet_TNCConfigListener is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TNCConfigListener.
CRONET_EXPORT void Cronet_TNCConfigListener_Destroy(
    Cronet_TNCConfigListenerPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TNCConfigListener_SetClientContext(
    Cronet_TNCConfigListenerPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TNCConfigListener_GetClientContext(Cronet_TNCConfigListenerPtr self);
// Abstract interface Cronet_TNCConfigListener is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TNCConfigListener_OnServerConfigUpdated(
    Cronet_TNCConfigListenerPtr self,
    Cronet_String tnc_config);
// The app implements abstract interface Cronet_TNCConfigListener by defining
// custom functions for each method.
typedef void (*Cronet_TNCConfigListener_OnServerConfigUpdatedFunc)(
    Cronet_TNCConfigListenerPtr self,
    Cronet_String tnc_config);
// The app creates an instance of Cronet_TNCConfigListener by providing custom
// functions for each method.
CRONET_EXPORT Cronet_TNCConfigListenerPtr Cronet_TNCConfigListener_CreateWith(
    Cronet_TNCConfigListener_OnServerConfigUpdatedFunc
        OnServerConfigUpdatedFunc);

///////////////////////
// Abstract interface Cronet_TTUrlDispatchCallback is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TTUrlDispatchCallback.
CRONET_EXPORT void Cronet_TTUrlDispatchCallback_Destroy(
    Cronet_TTUrlDispatchCallbackPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TTUrlDispatchCallback_SetClientContext(
    Cronet_TTUrlDispatchCallbackPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TTUrlDispatchCallback_GetClientContext(
    Cronet_TTUrlDispatchCallbackPtr self);
// Abstract interface Cronet_TTUrlDispatchCallback is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TTUrlDispatchCallback_OnDispatchFinished(
    Cronet_TTUrlDispatchCallbackPtr self,
    Cronet_TTDispatchResultPtr result);
// The app implements abstract interface Cronet_TTUrlDispatchCallback by
// defining custom functions for each method.
typedef void (*Cronet_TTUrlDispatchCallback_OnDispatchFinishedFunc)(
    Cronet_TTUrlDispatchCallbackPtr self,
    Cronet_TTDispatchResultPtr result);
// The app creates an instance of Cronet_TTUrlDispatchCallback by providing
// custom functions for each method.
CRONET_EXPORT Cronet_TTUrlDispatchCallbackPtr
Cronet_TTUrlDispatchCallback_CreateWith(
    Cronet_TTUrlDispatchCallback_OnDispatchFinishedFunc OnDispatchFinishedFunc);

///////////////////////
// Struct Cronet_Error.
CRONET_EXPORT Cronet_ErrorPtr Cronet_Error_Create(void);
CRONET_EXPORT void Cronet_Error_Destroy(Cronet_ErrorPtr self);
// Cronet_Error setters.
CRONET_EXPORT
void Cronet_Error_error_code_set(Cronet_ErrorPtr self,
                                 const Cronet_Error_ERROR_CODE error_code);
CRONET_EXPORT
void Cronet_Error_message_set(Cronet_ErrorPtr self,
                              const Cronet_String message);
CRONET_EXPORT
void Cronet_Error_internal_error_code_set(Cronet_ErrorPtr self,
                                          const int32_t internal_error_code);
CRONET_EXPORT
void Cronet_Error_immediately_retryable_set(Cronet_ErrorPtr self,
                                            const bool immediately_retryable);
CRONET_EXPORT
void Cronet_Error_quic_detailed_error_code_set(
    Cronet_ErrorPtr self,
    const int32_t quic_detailed_error_code);
// Cronet_Error getters.
CRONET_EXPORT
Cronet_Error_ERROR_CODE Cronet_Error_error_code_get(const Cronet_ErrorPtr self);
CRONET_EXPORT
Cronet_String Cronet_Error_message_get(const Cronet_ErrorPtr self);
CRONET_EXPORT
int32_t Cronet_Error_internal_error_code_get(const Cronet_ErrorPtr self);
CRONET_EXPORT
bool Cronet_Error_immediately_retryable_get(const Cronet_ErrorPtr self);
CRONET_EXPORT
int32_t Cronet_Error_quic_detailed_error_code_get(const Cronet_ErrorPtr self);

///////////////////////
// Struct Cronet_RTTAndThroughput.
CRONET_EXPORT Cronet_RTTAndThroughputPtr Cronet_RTTAndThroughput_Create(void);
CRONET_EXPORT void Cronet_RTTAndThroughput_Destroy(
    Cronet_RTTAndThroughputPtr self);
// Cronet_RTTAndThroughput setters.
CRONET_EXPORT
void Cronet_RTTAndThroughput_watching_group_add(Cronet_RTTAndThroughputPtr self,
                                                const Cronet_String element);
CRONET_EXPORT
void Cronet_RTTAndThroughput_group_transport_rtt_add(
    Cronet_RTTAndThroughputPtr self,
    const int32_t element);
CRONET_EXPORT
void Cronet_RTTAndThroughput_group_http_rtt_add(Cronet_RTTAndThroughputPtr self,
                                                const int32_t element);
CRONET_EXPORT
void Cronet_RTTAndThroughput_http_rtt_ms_set(Cronet_RTTAndThroughputPtr self,
                                             const int32_t http_rtt_ms);
CRONET_EXPORT
void Cronet_RTTAndThroughput_transport_rtt_ms_set(
    Cronet_RTTAndThroughputPtr self,
    const int32_t transport_rtt_ms);
CRONET_EXPORT
void Cronet_RTTAndThroughput_rx_throughput_kbps_set(
    Cronet_RTTAndThroughputPtr self,
    const int32_t rx_throughput_kbps);
// Cronet_RTTAndThroughput getters.
CRONET_EXPORT
uint32_t Cronet_RTTAndThroughput_watching_group_size(
    const Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
Cronet_String Cronet_RTTAndThroughput_watching_group_at(
    const Cronet_RTTAndThroughputPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_RTTAndThroughput_watching_group_clear(
    Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
uint32_t Cronet_RTTAndThroughput_group_transport_rtt_size(
    const Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
int32_t Cronet_RTTAndThroughput_group_transport_rtt_at(
    const Cronet_RTTAndThroughputPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_RTTAndThroughput_group_transport_rtt_clear(
    Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
uint32_t Cronet_RTTAndThroughput_group_http_rtt_size(
    const Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
int32_t Cronet_RTTAndThroughput_group_http_rtt_at(
    const Cronet_RTTAndThroughputPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_RTTAndThroughput_group_http_rtt_clear(
    Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
int32_t Cronet_RTTAndThroughput_http_rtt_ms_get(
    const Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
int32_t Cronet_RTTAndThroughput_transport_rtt_ms_get(
    const Cronet_RTTAndThroughputPtr self);
CRONET_EXPORT
int32_t Cronet_RTTAndThroughput_rx_throughput_kbps_get(
    const Cronet_RTTAndThroughputPtr self);

///////////////////////
// Struct Cronet_PacketLostStats.
CRONET_EXPORT Cronet_PacketLostStatsPtr Cronet_PacketLostStats_Create(void);
CRONET_EXPORT void Cronet_PacketLostStats_Destroy(
    Cronet_PacketLostStatsPtr self);
// Cronet_PacketLostStats setters.
CRONET_EXPORT
void Cronet_PacketLostStats_protocol_set(Cronet_PacketLostStatsPtr self,
                                         const int32_t protocol);
CRONET_EXPORT
void Cronet_PacketLostStats_tx_lost_rate_set(Cronet_PacketLostStatsPtr self,
                                             const double tx_lost_rate);
CRONET_EXPORT
void Cronet_PacketLostStats_tx_lost_var_set(Cronet_PacketLostStatsPtr self,
                                            const double tx_lost_var);
CRONET_EXPORT
void Cronet_PacketLostStats_rx_lost_rate_set(Cronet_PacketLostStatsPtr self,
                                             const double rx_lost_rate);
CRONET_EXPORT
void Cronet_PacketLostStats_rx_lost_var_set(Cronet_PacketLostStatsPtr self,
                                            const double rx_lost_var);
// Cronet_PacketLostStats getters.
CRONET_EXPORT
int32_t Cronet_PacketLostStats_protocol_get(
    const Cronet_PacketLostStatsPtr self);
CRONET_EXPORT
double Cronet_PacketLostStats_tx_lost_rate_get(
    const Cronet_PacketLostStatsPtr self);
CRONET_EXPORT
double Cronet_PacketLostStats_tx_lost_var_get(
    const Cronet_PacketLostStatsPtr self);
CRONET_EXPORT
double Cronet_PacketLostStats_rx_lost_rate_get(
    const Cronet_PacketLostStatsPtr self);
CRONET_EXPORT
double Cronet_PacketLostStats_rx_lost_var_get(
    const Cronet_PacketLostStatsPtr self);

///////////////////////
// Struct Cronet_NetworkInterface.
CRONET_EXPORT Cronet_NetworkInterfacePtr Cronet_NetworkInterface_Create(void);
CRONET_EXPORT void Cronet_NetworkInterface_Destroy(
    Cronet_NetworkInterfacePtr self);
// Cronet_NetworkInterface setters.
CRONET_EXPORT
void Cronet_NetworkInterface_name_set(Cronet_NetworkInterfacePtr self,
                                      const Cronet_String name);
CRONET_EXPORT
void Cronet_NetworkInterface_friendly_name_set(
    Cronet_NetworkInterfacePtr self,
    const Cronet_String friendly_name);
CRONET_EXPORT
void Cronet_NetworkInterface_index_set(Cronet_NetworkInterfacePtr self,
                                       const uint32_t index);
CRONET_EXPORT
void Cronet_NetworkInterface_type_set(Cronet_NetworkInterfacePtr self,
                                      const int32_t type);
CRONET_EXPORT
void Cronet_NetworkInterface_address_set(Cronet_NetworkInterfacePtr self,
                                         const Cronet_String address);
// Cronet_NetworkInterface getters.
CRONET_EXPORT
Cronet_String Cronet_NetworkInterface_name_get(
    const Cronet_NetworkInterfacePtr self);
CRONET_EXPORT
Cronet_String Cronet_NetworkInterface_friendly_name_get(
    const Cronet_NetworkInterfacePtr self);
CRONET_EXPORT
uint32_t Cronet_NetworkInterface_index_get(
    const Cronet_NetworkInterfacePtr self);
CRONET_EXPORT
int32_t Cronet_NetworkInterface_type_get(const Cronet_NetworkInterfacePtr self);
CRONET_EXPORT
Cronet_String Cronet_NetworkInterface_address_get(
    const Cronet_NetworkInterfacePtr self);

///////////////////////
// Struct Cronet_NetworkReport.
CRONET_EXPORT Cronet_NetworkReportPtr Cronet_NetworkReport_Create(void);
CRONET_EXPORT void Cronet_NetworkReport_Destroy(Cronet_NetworkReportPtr self);
// Cronet_NetworkReport setters.
CRONET_EXPORT
void Cronet_NetworkReport_interfaces_add(
    Cronet_NetworkReportPtr self,
    const Cronet_NetworkInterfacePtr element);
CRONET_EXPORT
void Cronet_NetworkReport_has_proxy_set(Cronet_NetworkReportPtr self,
                                        const bool has_proxy);
CRONET_EXPORT
void Cronet_NetworkReport_has_vpn_set(Cronet_NetworkReportPtr self,
                                      const bool has_vpn);
// Cronet_NetworkReport getters.
CRONET_EXPORT
uint32_t Cronet_NetworkReport_interfaces_size(
    const Cronet_NetworkReportPtr self);
CRONET_EXPORT
Cronet_NetworkInterfacePtr Cronet_NetworkReport_interfaces_at(
    const Cronet_NetworkReportPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_NetworkReport_interfaces_clear(Cronet_NetworkReportPtr self);
CRONET_EXPORT
bool Cronet_NetworkReport_has_proxy_get(const Cronet_NetworkReportPtr self);
CRONET_EXPORT
bool Cronet_NetworkReport_has_vpn_get(const Cronet_NetworkReportPtr self);

///////////////////////
// Struct Cronet_TTDnsResult.
CRONET_EXPORT Cronet_TTDnsResultPtr Cronet_TTDnsResult_Create(void);
CRONET_EXPORT void Cronet_TTDnsResult_Destroy(Cronet_TTDnsResultPtr self);
// Cronet_TTDnsResult setters.
CRONET_EXPORT
void Cronet_TTDnsResult_ret_set(Cronet_TTDnsResultPtr self, const int32_t ret);
CRONET_EXPORT
void Cronet_TTDnsResult_source_set(Cronet_TTDnsResultPtr self,
                                   const int32_t source);
CRONET_EXPORT
void Cronet_TTDnsResult_cache_source_set(Cronet_TTDnsResultPtr self,
                                         const int32_t cache_source);
CRONET_EXPORT
void Cronet_TTDnsResult_iplist_add(Cronet_TTDnsResultPtr self,
                                   const Cronet_String element);
CRONET_EXPORT
void Cronet_TTDnsResult_detailed_info_set(Cronet_TTDnsResultPtr self,
                                          const Cronet_String detailed_info);
// Cronet_TTDnsResult getters.
CRONET_EXPORT
int32_t Cronet_TTDnsResult_ret_get(const Cronet_TTDnsResultPtr self);
CRONET_EXPORT
int32_t Cronet_TTDnsResult_source_get(const Cronet_TTDnsResultPtr self);
CRONET_EXPORT
int32_t Cronet_TTDnsResult_cache_source_get(const Cronet_TTDnsResultPtr self);
CRONET_EXPORT
uint32_t Cronet_TTDnsResult_iplist_size(const Cronet_TTDnsResultPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTDnsResult_iplist_at(const Cronet_TTDnsResultPtr self,
                                           uint32_t index);
CRONET_EXPORT
void Cronet_TTDnsResult_iplist_clear(Cronet_TTDnsResultPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTDnsResult_detailed_info_get(
    const Cronet_TTDnsResultPtr self);

///////////////////////
// Struct Cronet_OpaqueData.
CRONET_EXPORT Cronet_OpaqueDataPtr Cronet_OpaqueData_Create(void);
CRONET_EXPORT void Cronet_OpaqueData_Destroy(Cronet_OpaqueDataPtr self);
// Cronet_OpaqueData setters.
CRONET_EXPORT
void Cronet_OpaqueData_data_add(Cronet_OpaqueDataPtr self,
                                const uint8_t element);
// Cronet_OpaqueData getters.
CRONET_EXPORT
uint32_t Cronet_OpaqueData_data_size(const Cronet_OpaqueDataPtr self);
CRONET_EXPORT
uint8_t Cronet_OpaqueData_data_at(const Cronet_OpaqueDataPtr self,
                                  uint32_t index);
CRONET_EXPORT
void Cronet_OpaqueData_data_clear(Cronet_OpaqueDataPtr self);

///////////////////////
// Struct Cronet_ClientOpaqueData.
CRONET_EXPORT Cronet_ClientOpaqueDataPtr Cronet_ClientOpaqueData_Create(void);
CRONET_EXPORT void Cronet_ClientOpaqueData_Destroy(
    Cronet_ClientOpaqueDataPtr self);
// Cronet_ClientOpaqueData setters.
CRONET_EXPORT
void Cronet_ClientOpaqueData_host_list_add(Cronet_ClientOpaqueDataPtr self,
                                           const Cronet_String element);
CRONET_EXPORT
void Cronet_ClientOpaqueData_certificate_add(Cronet_ClientOpaqueDataPtr self,
                                             const uint8_t element);
CRONET_EXPORT
void Cronet_ClientOpaqueData_private_key_add(Cronet_ClientOpaqueDataPtr self,
                                             const uint8_t element);
CRONET_EXPORT
void Cronet_ClientOpaqueData_certificate_chain_add(
    Cronet_ClientOpaqueDataPtr self,
    const Cronet_OpaqueDataPtr element);
CRONET_EXPORT
void Cronet_ClientOpaqueData_algorithm_prefer_set(
    Cronet_ClientOpaqueDataPtr self,
    const Cronet_RawDataPtr algorithm_prefer);
CRONET_EXPORT
void Cronet_ClientOpaqueData_do_sign_set(Cronet_ClientOpaqueDataPtr self,
                                         const Cronet_RawDataPtr do_sign);
// Cronet_ClientOpaqueData getters.
CRONET_EXPORT
uint32_t Cronet_ClientOpaqueData_host_list_size(
    const Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
Cronet_String Cronet_ClientOpaqueData_host_list_at(
    const Cronet_ClientOpaqueDataPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_ClientOpaqueData_host_list_clear(Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
uint32_t Cronet_ClientOpaqueData_certificate_size(
    const Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
uint8_t Cronet_ClientOpaqueData_certificate_at(
    const Cronet_ClientOpaqueDataPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_ClientOpaqueData_certificate_clear(Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
uint32_t Cronet_ClientOpaqueData_private_key_size(
    const Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
uint8_t Cronet_ClientOpaqueData_private_key_at(
    const Cronet_ClientOpaqueDataPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_ClientOpaqueData_private_key_clear(Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
uint32_t Cronet_ClientOpaqueData_certificate_chain_size(
    const Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
Cronet_OpaqueDataPtr Cronet_ClientOpaqueData_certificate_chain_at(
    const Cronet_ClientOpaqueDataPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_ClientOpaqueData_certificate_chain_clear(
    Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_ClientOpaqueData_algorithm_prefer_get(
    const Cronet_ClientOpaqueDataPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_ClientOpaqueData_do_sign_get(
    const Cronet_ClientOpaqueDataPtr self);

///////////////////////
// Struct Cronet_QuicHint.
CRONET_EXPORT Cronet_QuicHintPtr Cronet_QuicHint_Create(void);
CRONET_EXPORT void Cronet_QuicHint_Destroy(Cronet_QuicHintPtr self);
// Cronet_QuicHint setters.
CRONET_EXPORT
void Cronet_QuicHint_host_set(Cronet_QuicHintPtr self,
                              const Cronet_String host);
CRONET_EXPORT
void Cronet_QuicHint_port_set(Cronet_QuicHintPtr self, const int32_t port);
CRONET_EXPORT
void Cronet_QuicHint_alternate_port_set(Cronet_QuicHintPtr self,
                                        const int32_t alternate_port);
// Cronet_QuicHint getters.
CRONET_EXPORT
Cronet_String Cronet_QuicHint_host_get(const Cronet_QuicHintPtr self);
CRONET_EXPORT
int32_t Cronet_QuicHint_port_get(const Cronet_QuicHintPtr self);
CRONET_EXPORT
int32_t Cronet_QuicHint_alternate_port_get(const Cronet_QuicHintPtr self);

///////////////////////
// Struct Cronet_PublicKeyPins.
CRONET_EXPORT Cronet_PublicKeyPinsPtr Cronet_PublicKeyPins_Create(void);
CRONET_EXPORT void Cronet_PublicKeyPins_Destroy(Cronet_PublicKeyPinsPtr self);
// Cronet_PublicKeyPins setters.
CRONET_EXPORT
void Cronet_PublicKeyPins_host_set(Cronet_PublicKeyPinsPtr self,
                                   const Cronet_String host);
CRONET_EXPORT
void Cronet_PublicKeyPins_pins_sha256_add(Cronet_PublicKeyPinsPtr self,
                                          const Cronet_String element);
CRONET_EXPORT
void Cronet_PublicKeyPins_include_subdomains_set(Cronet_PublicKeyPinsPtr self,
                                                 const bool include_subdomains);
CRONET_EXPORT
void Cronet_PublicKeyPins_expiration_date_set(Cronet_PublicKeyPinsPtr self,
                                              const int64_t expiration_date);
// Cronet_PublicKeyPins getters.
CRONET_EXPORT
Cronet_String Cronet_PublicKeyPins_host_get(const Cronet_PublicKeyPinsPtr self);
CRONET_EXPORT
uint32_t Cronet_PublicKeyPins_pins_sha256_size(
    const Cronet_PublicKeyPinsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PublicKeyPins_pins_sha256_at(
    const Cronet_PublicKeyPinsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_PublicKeyPins_pins_sha256_clear(Cronet_PublicKeyPinsPtr self);
CRONET_EXPORT
bool Cronet_PublicKeyPins_include_subdomains_get(
    const Cronet_PublicKeyPinsPtr self);
CRONET_EXPORT
int64_t Cronet_PublicKeyPins_expiration_date_get(
    const Cronet_PublicKeyPinsPtr self);

///////////////////////
// Struct Cronet_TTNetParams.
CRONET_EXPORT Cronet_TTNetParamsPtr Cronet_TTNetParams_Create(void);
CRONET_EXPORT void Cronet_TTNetParams_Destroy(Cronet_TTNetParamsPtr self);
// Cronet_TTNetParams setters.
CRONET_EXPORT
void Cronet_TTNetParams_app_id_set(Cronet_TTNetParamsPtr self,
                                   const Cronet_String app_id);
CRONET_EXPORT
void Cronet_TTNetParams_app_name_set(Cronet_TTNetParamsPtr self,
                                     const Cronet_String app_name);
CRONET_EXPORT
void Cronet_TTNetParams_device_id_set(Cronet_TTNetParamsPtr self,
                                      const Cronet_String device_id);
CRONET_EXPORT
void Cronet_TTNetParams_version_code_set(Cronet_TTNetParamsPtr self,
                                         const Cronet_String version_code);
CRONET_EXPORT
void Cronet_TTNetParams_device_type_set(Cronet_TTNetParamsPtr self,
                                        const Cronet_String device_type);
CRONET_EXPORT
void Cronet_TTNetParams_channel_set(Cronet_TTNetParamsPtr self,
                                    const Cronet_String channel);
CRONET_EXPORT
void Cronet_TTNetParams_device_platform_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String device_platform);
CRONET_EXPORT
void Cronet_TTNetParams_uuid_set(Cronet_TTNetParamsPtr self,
                                 const Cronet_String uuid);
CRONET_EXPORT
void Cronet_TTNetParams_update_version_code_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String update_version_code);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_host_first_set(Cronet_TTNetParamsPtr self,
                                           const Cronet_String tnc_host_first);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_host_second_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String tnc_host_second);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_host_third_set(Cronet_TTNetParamsPtr self,
                                           const Cronet_String tnc_host_third);
CRONET_EXPORT
void Cronet_TTNetParams_is_main_process_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String is_main_process);
CRONET_EXPORT
void Cronet_TTNetParams_is_drop_first_tnc_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String is_drop_first_tnc);
CRONET_EXPORT
void Cronet_TTNetParams_domain_httpdns_set(Cronet_TTNetParamsPtr self,
                                           const Cronet_String domain_httpdns);
CRONET_EXPORT
void Cronet_TTNetParams_domain_netlog_set(Cronet_TTNetParamsPtr self,
                                          const Cronet_String domain_netlog);
CRONET_EXPORT
void Cronet_TTNetParams_domain_boe_set(Cronet_TTNetParamsPtr self,
                                       const Cronet_String domain_boe);
CRONET_EXPORT
void Cronet_TTNetParams_get_domain_default_json_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_String get_domain_default_json);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_headers_add(Cronet_TTNetParamsPtr self,
                                        const Cronet_HttpHeaderPtr element);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_queries_add(Cronet_TTNetParamsPtr self,
                                        const Cronet_QueryPtr element);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_load_flags_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_REQUEST_FLAGS tnc_load_flags);
CRONET_EXPORT
void Cronet_TTNetParams_httpdns_load_flags_set(
    Cronet_TTNetParamsPtr self,
    const Cronet_REQUEST_FLAGS httpdns_load_flags);
CRONET_EXPORT
void Cronet_TTNetParams_use_domestic_store_region_set(
    Cronet_TTNetParamsPtr self,
    const bool use_domestic_store_region);
// Cronet_TTNetParams getters.
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_app_id_get(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_app_name_get(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_device_id_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_version_code_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_device_type_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_channel_get(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_device_platform_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_uuid_get(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_update_version_code_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_tnc_host_first_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_tnc_host_second_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_tnc_host_third_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_is_main_process_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_is_drop_first_tnc_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_domain_httpdns_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_domain_netlog_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_domain_boe_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTNetParams_get_domain_default_json_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_TTNetParams_tnc_headers_size(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_HttpHeaderPtr Cronet_TTNetParams_tnc_headers_at(
    const Cronet_TTNetParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_headers_clear(Cronet_TTNetParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_TTNetParams_tnc_queries_size(const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_QueryPtr Cronet_TTNetParams_tnc_queries_at(
    const Cronet_TTNetParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_TTNetParams_tnc_queries_clear(Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_TTNetParams_tnc_load_flags_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_TTNetParams_httpdns_load_flags_get(
    const Cronet_TTNetParamsPtr self);
CRONET_EXPORT
bool Cronet_TTNetParams_use_domestic_store_region_get(
    const Cronet_TTNetParamsPtr self);

///////////////////////
// Struct Cronet_AuthCredentials.
CRONET_EXPORT Cronet_AuthCredentialsPtr Cronet_AuthCredentials_Create(void);
CRONET_EXPORT void Cronet_AuthCredentials_Destroy(
    Cronet_AuthCredentialsPtr self);
// Cronet_AuthCredentials setters.
CRONET_EXPORT
void Cronet_AuthCredentials_username_set(Cronet_AuthCredentialsPtr self,
                                         const Cronet_String username);
CRONET_EXPORT
void Cronet_AuthCredentials_password_set(Cronet_AuthCredentialsPtr self,
                                         const Cronet_String password);
// Cronet_AuthCredentials getters.
CRONET_EXPORT
Cronet_String Cronet_AuthCredentials_username_get(
    const Cronet_AuthCredentialsPtr self);
CRONET_EXPORT
Cronet_String Cronet_AuthCredentials_password_get(
    const Cronet_AuthCredentialsPtr self);

///////////////////////
// Struct Cronet_EngineParams.
CRONET_EXPORT Cronet_EngineParamsPtr Cronet_EngineParams_Create(void);
CRONET_EXPORT void Cronet_EngineParams_Destroy(Cronet_EngineParamsPtr self);
// Cronet_EngineParams setters.
CRONET_EXPORT
void Cronet_EngineParams_enable_check_result_set(
    Cronet_EngineParamsPtr self,
    const bool enable_check_result);
CRONET_EXPORT
void Cronet_EngineParams_user_agent_set(Cronet_EngineParamsPtr self,
                                        const Cronet_String user_agent);
CRONET_EXPORT
void Cronet_EngineParams_accept_language_set(
    Cronet_EngineParamsPtr self,
    const Cronet_String accept_language);
CRONET_EXPORT
void Cronet_EngineParams_storage_path_set(Cronet_EngineParamsPtr self,
                                          const Cronet_String storage_path);
CRONET_EXPORT
void Cronet_EngineParams_store_idc_rule_json_set(
    Cronet_EngineParamsPtr self,
    const Cronet_String store_idc_rule_json);
CRONET_EXPORT
void Cronet_EngineParams_enable_quic_set(Cronet_EngineParamsPtr self,
                                         const bool enable_quic);
CRONET_EXPORT
void Cronet_EngineParams_enable_http2_set(Cronet_EngineParamsPtr self,
                                          const bool enable_http2);
CRONET_EXPORT
void Cronet_EngineParams_enable_brotli_set(Cronet_EngineParamsPtr self,
                                           const bool enable_brotli);
CRONET_EXPORT
void Cronet_EngineParams_http_cache_mode_set(
    Cronet_EngineParamsPtr self,
    const Cronet_EngineParams_HTTP_CACHE_MODE http_cache_mode);
CRONET_EXPORT
void Cronet_EngineParams_http_cache_max_size_set(
    Cronet_EngineParamsPtr self,
    const int64_t http_cache_max_size);
CRONET_EXPORT
void Cronet_EngineParams_quic_hints_add(Cronet_EngineParamsPtr self,
                                        const Cronet_QuicHintPtr element);
CRONET_EXPORT
void Cronet_EngineParams_public_key_pins_add(
    Cronet_EngineParamsPtr self,
    const Cronet_PublicKeyPinsPtr element);
CRONET_EXPORT
void Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_set(
    Cronet_EngineParamsPtr self,
    const bool enable_public_key_pinning_bypass_for_local_trust_anchors);
CRONET_EXPORT
void Cronet_EngineParams_network_thread_priority_set(
    Cronet_EngineParamsPtr self,
    const double network_thread_priority);
CRONET_EXPORT
void Cronet_EngineParams_experimental_options_set(
    Cronet_EngineParamsPtr self,
    const Cronet_String experimental_options);
CRONET_EXPORT
void Cronet_EngineParams_enable_network_quality_estimator_set(
    Cronet_EngineParamsPtr self,
    const bool enable_network_quality_estimator);
CRONET_EXPORT
void Cronet_EngineParams_proxy_config_set(Cronet_EngineParamsPtr self,
                                          const Cronet_String proxy_config);
CRONET_EXPORT
void Cronet_EngineParams_enable_opaque_data_store_set(
    Cronet_EngineParamsPtr self,
    const bool enable_opaque_data_store);
CRONET_EXPORT
void Cronet_EngineParams_opaque_data_store_add(
    Cronet_EngineParamsPtr self,
    const Cronet_OpaqueDataPtr element);
CRONET_EXPORT
void Cronet_EngineParams_client_opaque_data_store_add(
    Cronet_EngineParamsPtr self,
    const Cronet_ClientOpaqueDataPtr element);
CRONET_EXPORT
void Cronet_EngineParams_enable_verbose_log_set(Cronet_EngineParamsPtr self,
                                                const bool enable_verbose_log);
CRONET_EXPORT
void Cronet_EngineParams_ttnet_params_set(
    Cronet_EngineParamsPtr self,
    const Cronet_TTNetParamsPtr ttnet_params);
// Move data from |ttnet_params|. The caller retains ownership of |ttnet_params|
// and must destroy it.
void Cronet_EngineParams_ttnet_params_move(Cronet_EngineParamsPtr self,
                                           Cronet_TTNetParamsPtr ttnet_params);
CRONET_EXPORT
void Cronet_EngineParams_alog_write_func_set(
    Cronet_EngineParamsPtr self,
    const Cronet_RawDataPtr alog_write_func);
CRONET_EXPORT
void Cronet_EngineParams_enable_modify_mode_set(Cronet_EngineParamsPtr self,
                                                const bool enable_modify_mode);
// Cronet_EngineParams getters.
CRONET_EXPORT
bool Cronet_EngineParams_enable_check_result_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_user_agent_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_accept_language_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_storage_path_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_store_idc_rule_json_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_quic_get(const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_http2_get(const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_brotli_get(const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_EngineParams_HTTP_CACHE_MODE Cronet_EngineParams_http_cache_mode_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
int64_t Cronet_EngineParams_http_cache_max_size_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_EngineParams_quic_hints_size(const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_QuicHintPtr Cronet_EngineParams_quic_hints_at(
    const Cronet_EngineParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_EngineParams_quic_hints_clear(Cronet_EngineParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_EngineParams_public_key_pins_size(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_PublicKeyPinsPtr Cronet_EngineParams_public_key_pins_at(
    const Cronet_EngineParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_EngineParams_public_key_pins_clear(Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
double Cronet_EngineParams_network_thread_priority_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_experimental_options_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_network_quality_estimator_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_String Cronet_EngineParams_proxy_config_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_opaque_data_store_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_EngineParams_opaque_data_store_size(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_OpaqueDataPtr Cronet_EngineParams_opaque_data_store_at(
    const Cronet_EngineParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_EngineParams_opaque_data_store_clear(Cronet_EngineParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_EngineParams_client_opaque_data_store_size(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_ClientOpaqueDataPtr Cronet_EngineParams_client_opaque_data_store_at(
    const Cronet_EngineParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_EngineParams_client_opaque_data_store_clear(
    Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_verbose_log_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_TTNetParamsPtr Cronet_EngineParams_ttnet_params_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_EngineParams_alog_write_func_get(
    const Cronet_EngineParamsPtr self);
CRONET_EXPORT
bool Cronet_EngineParams_enable_modify_mode_get(
    const Cronet_EngineParamsPtr self);

///////////////////////
// Struct Cronet_HttpHeader.
CRONET_EXPORT Cronet_HttpHeaderPtr Cronet_HttpHeader_Create(void);
CRONET_EXPORT void Cronet_HttpHeader_Destroy(Cronet_HttpHeaderPtr self);
// Cronet_HttpHeader setters.
CRONET_EXPORT
void Cronet_HttpHeader_name_set(Cronet_HttpHeaderPtr self,
                                const Cronet_String name);
CRONET_EXPORT
void Cronet_HttpHeader_value_set(Cronet_HttpHeaderPtr self,
                                 const Cronet_String value);
// Cronet_HttpHeader getters.
CRONET_EXPORT
Cronet_String Cronet_HttpHeader_name_get(const Cronet_HttpHeaderPtr self);
CRONET_EXPORT
Cronet_String Cronet_HttpHeader_value_get(const Cronet_HttpHeaderPtr self);

///////////////////////
// Struct Cronet_Query.
CRONET_EXPORT Cronet_QueryPtr Cronet_Query_Create(void);
CRONET_EXPORT void Cronet_Query_Destroy(Cronet_QueryPtr self);
// Cronet_Query setters.
CRONET_EXPORT
void Cronet_Query_name_set(Cronet_QueryPtr self, const Cronet_String name);
CRONET_EXPORT
void Cronet_Query_value_set(Cronet_QueryPtr self, const Cronet_String value);
// Cronet_Query getters.
CRONET_EXPORT
Cronet_String Cronet_Query_name_get(const Cronet_QueryPtr self);
CRONET_EXPORT
Cronet_String Cronet_Query_value_get(const Cronet_QueryPtr self);

///////////////////////
// Struct Cronet_UrlResponseInfo.
CRONET_EXPORT Cronet_UrlResponseInfoPtr Cronet_UrlResponseInfo_Create(void);
CRONET_EXPORT void Cronet_UrlResponseInfo_Destroy(
    Cronet_UrlResponseInfoPtr self);
// Cronet_UrlResponseInfo setters.
CRONET_EXPORT
void Cronet_UrlResponseInfo_url_set(Cronet_UrlResponseInfoPtr self,
                                    const Cronet_String url);
CRONET_EXPORT
void Cronet_UrlResponseInfo_url_chain_add(Cronet_UrlResponseInfoPtr self,
                                          const Cronet_String element);
CRONET_EXPORT
void Cronet_UrlResponseInfo_http_status_code_set(
    Cronet_UrlResponseInfoPtr self,
    const int32_t http_status_code);
CRONET_EXPORT
void Cronet_UrlResponseInfo_http_status_text_set(
    Cronet_UrlResponseInfoPtr self,
    const Cronet_String http_status_text);
CRONET_EXPORT
void Cronet_UrlResponseInfo_all_headers_list_add(
    Cronet_UrlResponseInfoPtr self,
    const Cronet_HttpHeaderPtr element);
CRONET_EXPORT
void Cronet_UrlResponseInfo_was_cached_set(Cronet_UrlResponseInfoPtr self,
                                           const bool was_cached);
CRONET_EXPORT
void Cronet_UrlResponseInfo_negotiated_protocol_set(
    Cronet_UrlResponseInfoPtr self,
    const Cronet_String negotiated_protocol);
CRONET_EXPORT
void Cronet_UrlResponseInfo_proxy_server_set(Cronet_UrlResponseInfoPtr self,
                                             const Cronet_String proxy_server);
CRONET_EXPORT
void Cronet_UrlResponseInfo_received_byte_count_set(
    Cronet_UrlResponseInfoPtr self,
    const int64_t received_byte_count);
// Cronet_UrlResponseInfo getters.
CRONET_EXPORT
Cronet_String Cronet_UrlResponseInfo_url_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
uint32_t Cronet_UrlResponseInfo_url_chain_size(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_UrlResponseInfo_url_chain_at(
    const Cronet_UrlResponseInfoPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_UrlResponseInfo_url_chain_clear(Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
int32_t Cronet_UrlResponseInfo_http_status_code_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_UrlResponseInfo_http_status_text_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
uint32_t Cronet_UrlResponseInfo_all_headers_list_size(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
Cronet_HttpHeaderPtr Cronet_UrlResponseInfo_all_headers_list_at(
    const Cronet_UrlResponseInfoPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_UrlResponseInfo_all_headers_list_clear(
    Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
bool Cronet_UrlResponseInfo_was_cached_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_UrlResponseInfo_negotiated_protocol_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_UrlResponseInfo_proxy_server_get(
    const Cronet_UrlResponseInfoPtr self);
CRONET_EXPORT
int64_t Cronet_UrlResponseInfo_received_byte_count_get(
    const Cronet_UrlResponseInfoPtr self);

///////////////////////
// Struct Cronet_UrlRequestParams.
CRONET_EXPORT Cronet_UrlRequestParamsPtr Cronet_UrlRequestParams_Create(void);
CRONET_EXPORT void Cronet_UrlRequestParams_Destroy(
    Cronet_UrlRequestParamsPtr self);
// Cronet_UrlRequestParams setters.
CRONET_EXPORT
void Cronet_UrlRequestParams_http_method_set(Cronet_UrlRequestParamsPtr self,
                                             const Cronet_String http_method);
CRONET_EXPORT
void Cronet_UrlRequestParams_request_headers_add(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_HttpHeaderPtr element);
CRONET_EXPORT
void Cronet_UrlRequestParams_disable_cache_set(Cronet_UrlRequestParamsPtr self,
                                               const bool disable_cache);
CRONET_EXPORT
void Cronet_UrlRequestParams_priority_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_UrlRequestParams_REQUEST_PRIORITY priority);
CRONET_EXPORT
void Cronet_UrlRequestParams_upload_data_provider_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_UploadDataProviderPtr upload_data_provider);
CRONET_EXPORT
void Cronet_UrlRequestParams_upload_data_provider_executor_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_ExecutorPtr upload_data_provider_executor);
CRONET_EXPORT
void Cronet_UrlRequestParams_allow_direct_executor_set(
    Cronet_UrlRequestParamsPtr self,
    const bool allow_direct_executor);
CRONET_EXPORT
void Cronet_UrlRequestParams_annotations_add(Cronet_UrlRequestParamsPtr self,
                                             const Cronet_RawDataPtr element);
CRONET_EXPORT
void Cronet_UrlRequestParams_request_finished_listener_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_RequestFinishedInfoListenerPtr request_finished_listener);
CRONET_EXPORT
void Cronet_UrlRequestParams_request_finished_executor_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_ExecutorPtr request_finished_executor);
CRONET_EXPORT
void Cronet_UrlRequestParams_idempotency_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_UrlRequestParams_IDEMPOTENCY idempotency);
CRONET_EXPORT
void Cronet_UrlRequestParams_request_timeout_set(
    Cronet_UrlRequestParamsPtr self,
    const int32_t request_timeout);
CRONET_EXPORT
void Cronet_UrlRequestParams_connect_timeout_set(
    Cronet_UrlRequestParamsPtr self,
    const int32_t connect_timeout);
CRONET_EXPORT
void Cronet_UrlRequestParams_read_timeout_set(Cronet_UrlRequestParamsPtr self,
                                              const int32_t read_timeout);
CRONET_EXPORT
void Cronet_UrlRequestParams_write_timeout_set(Cronet_UrlRequestParamsPtr self,
                                               const int32_t write_timeout);
CRONET_EXPORT
void Cronet_UrlRequestParams_load_flags_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_REQUEST_FLAGS load_flags);
CRONET_EXPORT
void Cronet_UrlRequestParams_auth_credentials_set(
    Cronet_UrlRequestParamsPtr self,
    const Cronet_AuthCredentialsPtr auth_credentials);
// Move data from |auth_credentials|. The caller retains ownership of
// |auth_credentials| and must destroy it.
void Cronet_UrlRequestParams_auth_credentials_move(
    Cronet_UrlRequestParamsPtr self,
    Cronet_AuthCredentialsPtr auth_credentials);
// Cronet_UrlRequestParams getters.
CRONET_EXPORT
Cronet_String Cronet_UrlRequestParams_http_method_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_UrlRequestParams_request_headers_size(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_HttpHeaderPtr Cronet_UrlRequestParams_request_headers_at(
    const Cronet_UrlRequestParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_UrlRequestParams_request_headers_clear(
    Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
bool Cronet_UrlRequestParams_disable_cache_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_UrlRequestParams_REQUEST_PRIORITY Cronet_UrlRequestParams_priority_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_UploadDataProviderPtr Cronet_UrlRequestParams_upload_data_provider_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_ExecutorPtr Cronet_UrlRequestParams_upload_data_provider_executor_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
bool Cronet_UrlRequestParams_allow_direct_executor_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_UrlRequestParams_annotations_size(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_UrlRequestParams_annotations_at(
    const Cronet_UrlRequestParamsPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_UrlRequestParams_annotations_clear(Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_RequestFinishedInfoListenerPtr
Cronet_UrlRequestParams_request_finished_listener_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_ExecutorPtr Cronet_UrlRequestParams_request_finished_executor_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_UrlRequestParams_IDEMPOTENCY Cronet_UrlRequestParams_idempotency_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
int32_t Cronet_UrlRequestParams_request_timeout_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
int32_t Cronet_UrlRequestParams_connect_timeout_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
int32_t Cronet_UrlRequestParams_read_timeout_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
int32_t Cronet_UrlRequestParams_write_timeout_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_REQUEST_FLAGS Cronet_UrlRequestParams_load_flags_get(
    const Cronet_UrlRequestParamsPtr self);
CRONET_EXPORT
Cronet_AuthCredentialsPtr Cronet_UrlRequestParams_auth_credentials_get(
    const Cronet_UrlRequestParamsPtr self);

///////////////////////
// Struct Cronet_DateTime.
CRONET_EXPORT Cronet_DateTimePtr Cronet_DateTime_Create(void);
CRONET_EXPORT void Cronet_DateTime_Destroy(Cronet_DateTimePtr self);
// Cronet_DateTime setters.
CRONET_EXPORT
void Cronet_DateTime_value_set(Cronet_DateTimePtr self, const int64_t value);
// Cronet_DateTime getters.
CRONET_EXPORT
int64_t Cronet_DateTime_value_get(const Cronet_DateTimePtr self);

///////////////////////
// Struct Cronet_Metrics.
CRONET_EXPORT Cronet_MetricsPtr Cronet_Metrics_Create(void);
CRONET_EXPORT void Cronet_Metrics_Destroy(Cronet_MetricsPtr self);
// Cronet_Metrics setters.
CRONET_EXPORT
void Cronet_Metrics_request_start_set(Cronet_MetricsPtr self,
                                      const Cronet_DateTimePtr request_start);
// Move data from |request_start|. The caller retains ownership of
// |request_start| and must destroy it.
void Cronet_Metrics_request_start_move(Cronet_MetricsPtr self,
                                       Cronet_DateTimePtr request_start);
CRONET_EXPORT
void Cronet_Metrics_dns_start_set(Cronet_MetricsPtr self,
                                  const Cronet_DateTimePtr dns_start);
// Move data from |dns_start|. The caller retains ownership of |dns_start| and
// must destroy it.
void Cronet_Metrics_dns_start_move(Cronet_MetricsPtr self,
                                   Cronet_DateTimePtr dns_start);
CRONET_EXPORT
void Cronet_Metrics_dns_end_set(Cronet_MetricsPtr self,
                                const Cronet_DateTimePtr dns_end);
// Move data from |dns_end|. The caller retains ownership of |dns_end| and must
// destroy it.
void Cronet_Metrics_dns_end_move(Cronet_MetricsPtr self,
                                 Cronet_DateTimePtr dns_end);
CRONET_EXPORT
void Cronet_Metrics_connect_start_set(Cronet_MetricsPtr self,
                                      const Cronet_DateTimePtr connect_start);
// Move data from |connect_start|. The caller retains ownership of
// |connect_start| and must destroy it.
void Cronet_Metrics_connect_start_move(Cronet_MetricsPtr self,
                                       Cronet_DateTimePtr connect_start);
CRONET_EXPORT
void Cronet_Metrics_connect_end_set(Cronet_MetricsPtr self,
                                    const Cronet_DateTimePtr connect_end);
// Move data from |connect_end|. The caller retains ownership of |connect_end|
// and must destroy it.
void Cronet_Metrics_connect_end_move(Cronet_MetricsPtr self,
                                     Cronet_DateTimePtr connect_end);
CRONET_EXPORT
void Cronet_Metrics_ssl_start_set(Cronet_MetricsPtr self,
                                  const Cronet_DateTimePtr ssl_start);
// Move data from |ssl_start|. The caller retains ownership of |ssl_start| and
// must destroy it.
void Cronet_Metrics_ssl_start_move(Cronet_MetricsPtr self,
                                   Cronet_DateTimePtr ssl_start);
CRONET_EXPORT
void Cronet_Metrics_ssl_end_set(Cronet_MetricsPtr self,
                                const Cronet_DateTimePtr ssl_end);
// Move data from |ssl_end|. The caller retains ownership of |ssl_end| and must
// destroy it.
void Cronet_Metrics_ssl_end_move(Cronet_MetricsPtr self,
                                 Cronet_DateTimePtr ssl_end);
CRONET_EXPORT
void Cronet_Metrics_sending_start_set(Cronet_MetricsPtr self,
                                      const Cronet_DateTimePtr sending_start);
// Move data from |sending_start|. The caller retains ownership of
// |sending_start| and must destroy it.
void Cronet_Metrics_sending_start_move(Cronet_MetricsPtr self,
                                       Cronet_DateTimePtr sending_start);
CRONET_EXPORT
void Cronet_Metrics_sending_end_set(Cronet_MetricsPtr self,
                                    const Cronet_DateTimePtr sending_end);
// Move data from |sending_end|. The caller retains ownership of |sending_end|
// and must destroy it.
void Cronet_Metrics_sending_end_move(Cronet_MetricsPtr self,
                                     Cronet_DateTimePtr sending_end);
CRONET_EXPORT
void Cronet_Metrics_push_start_set(Cronet_MetricsPtr self,
                                   const Cronet_DateTimePtr push_start);
// Move data from |push_start|. The caller retains ownership of |push_start| and
// must destroy it.
void Cronet_Metrics_push_start_move(Cronet_MetricsPtr self,
                                    Cronet_DateTimePtr push_start);
CRONET_EXPORT
void Cronet_Metrics_push_end_set(Cronet_MetricsPtr self,
                                 const Cronet_DateTimePtr push_end);
// Move data from |push_end|. The caller retains ownership of |push_end| and
// must destroy it.
void Cronet_Metrics_push_end_move(Cronet_MetricsPtr self,
                                  Cronet_DateTimePtr push_end);
CRONET_EXPORT
void Cronet_Metrics_response_start_set(Cronet_MetricsPtr self,
                                       const Cronet_DateTimePtr response_start);
// Move data from |response_start|. The caller retains ownership of
// |response_start| and must destroy it.
void Cronet_Metrics_response_start_move(Cronet_MetricsPtr self,
                                        Cronet_DateTimePtr response_start);
CRONET_EXPORT
void Cronet_Metrics_request_end_set(Cronet_MetricsPtr self,
                                    const Cronet_DateTimePtr request_end);
// Move data from |request_end|. The caller retains ownership of |request_end|
// and must destroy it.
void Cronet_Metrics_request_end_move(Cronet_MetricsPtr self,
                                     Cronet_DateTimePtr request_end);
CRONET_EXPORT
void Cronet_Metrics_socket_reused_set(Cronet_MetricsPtr self,
                                      const bool socket_reused);
CRONET_EXPORT
void Cronet_Metrics_sent_byte_count_set(Cronet_MetricsPtr self,
                                        const int64_t sent_byte_count);
CRONET_EXPORT
void Cronet_Metrics_received_byte_count_set(Cronet_MetricsPtr self,
                                            const int64_t received_byte_count);
CRONET_EXPORT
void Cronet_Metrics_host_set(Cronet_MetricsPtr self, const Cronet_String host);
CRONET_EXPORT
void Cronet_Metrics_port_set(Cronet_MetricsPtr self, const int32_t port);
CRONET_EXPORT
void Cronet_Metrics_retry_attempts_set(Cronet_MetricsPtr self,
                                       const int32_t retry_attempts);
// Cronet_Metrics getters.
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_request_start_get(
    const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_dns_start_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_dns_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_connect_start_get(
    const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_connect_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_ssl_start_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_ssl_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_sending_start_get(
    const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_sending_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_push_start_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_push_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_response_start_get(
    const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_DateTimePtr Cronet_Metrics_request_end_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
bool Cronet_Metrics_socket_reused_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
int64_t Cronet_Metrics_sent_byte_count_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
int64_t Cronet_Metrics_received_byte_count_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
Cronet_String Cronet_Metrics_host_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
int32_t Cronet_Metrics_port_get(const Cronet_MetricsPtr self);
CRONET_EXPORT
int32_t Cronet_Metrics_retry_attempts_get(const Cronet_MetricsPtr self);

///////////////////////
// Struct Cronet_RequestFinishedInfo.
CRONET_EXPORT Cronet_RequestFinishedInfoPtr
Cronet_RequestFinishedInfo_Create(void);
CRONET_EXPORT void Cronet_RequestFinishedInfo_Destroy(
    Cronet_RequestFinishedInfoPtr self);
// Cronet_RequestFinishedInfo setters.
CRONET_EXPORT
void Cronet_RequestFinishedInfo_metrics_set(Cronet_RequestFinishedInfoPtr self,
                                            const Cronet_MetricsPtr metrics);
// Move data from |metrics|. The caller retains ownership of |metrics| and must
// destroy it.
void Cronet_RequestFinishedInfo_metrics_move(Cronet_RequestFinishedInfoPtr self,
                                             Cronet_MetricsPtr metrics);
CRONET_EXPORT
void Cronet_RequestFinishedInfo_annotations_add(
    Cronet_RequestFinishedInfoPtr self,
    const Cronet_RawDataPtr element);
CRONET_EXPORT
void Cronet_RequestFinishedInfo_finished_reason_set(
    Cronet_RequestFinishedInfoPtr self,
    const Cronet_RequestFinishedInfo_FINISHED_REASON finished_reason);
CRONET_EXPORT
void Cronet_RequestFinishedInfo_request_finished_log_set(
    Cronet_RequestFinishedInfoPtr self,
    const Cronet_String request_finished_log);
// Cronet_RequestFinishedInfo getters.
CRONET_EXPORT
Cronet_MetricsPtr Cronet_RequestFinishedInfo_metrics_get(
    const Cronet_RequestFinishedInfoPtr self);
CRONET_EXPORT
uint32_t Cronet_RequestFinishedInfo_annotations_size(
    const Cronet_RequestFinishedInfoPtr self);
CRONET_EXPORT
Cronet_RawDataPtr Cronet_RequestFinishedInfo_annotations_at(
    const Cronet_RequestFinishedInfoPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_RequestFinishedInfo_annotations_clear(
    Cronet_RequestFinishedInfoPtr self);
CRONET_EXPORT
Cronet_RequestFinishedInfo_FINISHED_REASON
Cronet_RequestFinishedInfo_finished_reason_get(
    const Cronet_RequestFinishedInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_RequestFinishedInfo_request_finished_log_get(
    const Cronet_RequestFinishedInfoPtr self);

///////////////////////
// Struct Cronet_TTNetBasicRequestInfo.
CRONET_EXPORT Cronet_TTNetBasicRequestInfoPtr
Cronet_TTNetBasicRequestInfo_Create(void);
CRONET_EXPORT void Cronet_TTNetBasicRequestInfo_Destroy(
    Cronet_TTNetBasicRequestInfoPtr self);
// Cronet_TTNetBasicRequestInfo setters.
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_is_background_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const bool is_background);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_start_net_type_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int16_t start_net_type);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_end_net_type_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int16_t end_net_type);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_effective_net_type_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int16_t effective_net_type);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_start_ts_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int64_t start_ts);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_retry_attempts_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int16_t retry_attempts);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_sent_bytes_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int64_t sent_bytes);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_dns_set(Cronet_TTNetBasicRequestInfoPtr self,
                                          const int32_t dns);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_tcp_set(Cronet_TTNetBasicRequestInfoPtr self,
                                          const int32_t tcp);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_ssl_set(Cronet_TTNetBasicRequestInfoPtr self,
                                          const int32_t ssl);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_send_set(Cronet_TTNetBasicRequestInfoPtr self,
                                           const int32_t send);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_proxy_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t proxy);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_ttfb_set(Cronet_TTNetBasicRequestInfoPtr self,
                                           const int32_t ttfb);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_header_recv_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t header_recv);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_body_recv_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t body_recv);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_edge_set(Cronet_TTNetBasicRequestInfoPtr self,
                                           const int32_t edge);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_origin_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t origin);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_inner_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t inner);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_rtt_set(Cronet_TTNetBasicRequestInfoPtr self,
                                          const int32_t rtt);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_code_set(Cronet_TTNetBasicRequestInfoPtr self,
                                           const int16_t code);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_received_bytes_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int64_t received_bytes);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_duration_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t duration);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_http_rtt_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t http_rtt);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_tcp_rtt_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t tcp_rtt);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_downlink_throughput_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const int32_t downlink_throughput);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_pending_requests_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const uint64_t pending_requests);
CRONET_EXPORT
void Cronet_TTNetBasicRequestInfo_total_requests_set(
    Cronet_TTNetBasicRequestInfoPtr self,
    const uint64_t total_requests);
// Cronet_TTNetBasicRequestInfo getters.
CRONET_EXPORT
bool Cronet_TTNetBasicRequestInfo_is_background_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int16_t Cronet_TTNetBasicRequestInfo_start_net_type_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int16_t Cronet_TTNetBasicRequestInfo_end_net_type_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int16_t Cronet_TTNetBasicRequestInfo_effective_net_type_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int64_t Cronet_TTNetBasicRequestInfo_start_ts_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int16_t Cronet_TTNetBasicRequestInfo_retry_attempts_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int64_t Cronet_TTNetBasicRequestInfo_sent_bytes_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_dns_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_tcp_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_ssl_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_send_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_proxy_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_ttfb_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_header_recv_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_body_recv_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_edge_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_origin_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_inner_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_rtt_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int16_t Cronet_TTNetBasicRequestInfo_code_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int64_t Cronet_TTNetBasicRequestInfo_received_bytes_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_duration_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_http_rtt_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_tcp_rtt_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
int32_t Cronet_TTNetBasicRequestInfo_downlink_throughput_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
uint64_t Cronet_TTNetBasicRequestInfo_pending_requests_get(
    const Cronet_TTNetBasicRequestInfoPtr self);
CRONET_EXPORT
uint64_t Cronet_TTNetBasicRequestInfo_total_requests_get(
    const Cronet_TTNetBasicRequestInfoPtr self);

///////////////////////
// Struct Cronet_PublicIPs.
CRONET_EXPORT Cronet_PublicIPsPtr Cronet_PublicIPs_Create(void);
CRONET_EXPORT void Cronet_PublicIPs_Destroy(Cronet_PublicIPsPtr self);
// Cronet_PublicIPs setters.
CRONET_EXPORT
void Cronet_PublicIPs_ipv4_list_add(Cronet_PublicIPsPtr self,
                                    const Cronet_String element);
CRONET_EXPORT
void Cronet_PublicIPs_ipv6_list_add(Cronet_PublicIPsPtr self,
                                    const Cronet_String element);
// Cronet_PublicIPs getters.
CRONET_EXPORT
uint32_t Cronet_PublicIPs_ipv4_list_size(const Cronet_PublicIPsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PublicIPs_ipv4_list_at(const Cronet_PublicIPsPtr self,
                                            uint32_t index);
CRONET_EXPORT
void Cronet_PublicIPs_ipv4_list_clear(Cronet_PublicIPsPtr self);
CRONET_EXPORT
uint32_t Cronet_PublicIPs_ipv6_list_size(const Cronet_PublicIPsPtr self);
CRONET_EXPORT
Cronet_String Cronet_PublicIPs_ipv6_list_at(const Cronet_PublicIPsPtr self,
                                            uint32_t index);
CRONET_EXPORT
void Cronet_PublicIPs_ipv6_list_clear(Cronet_PublicIPsPtr self);

///////////////////////
// Struct Cronet_EventLog.
CRONET_EXPORT Cronet_EventLogPtr Cronet_EventLog_Create(void);
CRONET_EXPORT void Cronet_EventLog_Destroy(Cronet_EventLogPtr self);
// Cronet_EventLog setters.
CRONET_EXPORT
void Cronet_EventLog_log_type_set(Cronet_EventLogPtr self,
                                  const Cronet_String log_type);
CRONET_EXPORT
void Cronet_EventLog_log_content_set(Cronet_EventLogPtr self,
                                     const Cronet_String log_content);
// Cronet_EventLog getters.
CRONET_EXPORT
Cronet_String Cronet_EventLog_log_type_get(const Cronet_EventLogPtr self);
CRONET_EXPORT
Cronet_String Cronet_EventLog_log_content_get(const Cronet_EventLogPtr self);

///////////////////////
// Struct Cronet_InnerRequestFinishedInfo.
CRONET_EXPORT Cronet_InnerRequestFinishedInfoPtr
Cronet_InnerRequestFinishedInfo_Create(void);
CRONET_EXPORT void Cronet_InnerRequestFinishedInfo_Destroy(
    Cronet_InnerRequestFinishedInfoPtr self);
// Cronet_InnerRequestFinishedInfo setters.
CRONET_EXPORT
void Cronet_InnerRequestFinishedInfo_url_set(
    Cronet_InnerRequestFinishedInfoPtr self,
    const Cronet_String url);
CRONET_EXPORT
void Cronet_InnerRequestFinishedInfo_succ_set(
    Cronet_InnerRequestFinishedInfoPtr self,
    const bool succ);
CRONET_EXPORT
void Cronet_InnerRequestFinishedInfo_duration_set(
    Cronet_InnerRequestFinishedInfoPtr self,
    const uint64_t duration);
CRONET_EXPORT
void Cronet_InnerRequestFinishedInfo_request_log_set(
    Cronet_InnerRequestFinishedInfoPtr self,
    const Cronet_String request_log);
// Cronet_InnerRequestFinishedInfo getters.
CRONET_EXPORT
Cronet_String Cronet_InnerRequestFinishedInfo_url_get(
    const Cronet_InnerRequestFinishedInfoPtr self);
CRONET_EXPORT
bool Cronet_InnerRequestFinishedInfo_succ_get(
    const Cronet_InnerRequestFinishedInfoPtr self);
CRONET_EXPORT
uint64_t Cronet_InnerRequestFinishedInfo_duration_get(
    const Cronet_InnerRequestFinishedInfoPtr self);
CRONET_EXPORT
Cronet_String Cronet_InnerRequestFinishedInfo_request_log_get(
    const Cronet_InnerRequestFinishedInfoPtr self);

///////////////////////
// Struct Cronet_HeaderList.
CRONET_EXPORT Cronet_HeaderListPtr Cronet_HeaderList_Create(void);
CRONET_EXPORT void Cronet_HeaderList_Destroy(Cronet_HeaderListPtr self);
// Cronet_HeaderList setters.
CRONET_EXPORT
void Cronet_HeaderList_header_list_add(Cronet_HeaderListPtr self,
                                       const Cronet_HttpHeaderPtr element);
// Cronet_HeaderList getters.
CRONET_EXPORT
uint32_t Cronet_HeaderList_header_list_size(const Cronet_HeaderListPtr self);
CRONET_EXPORT
Cronet_HttpHeaderPtr Cronet_HeaderList_header_list_at(
    const Cronet_HeaderListPtr self,
    uint32_t index);
CRONET_EXPORT
void Cronet_HeaderList_header_list_clear(Cronet_HeaderListPtr self);

///////////////////////
// Struct Cronet_TTDispatchResult.
CRONET_EXPORT Cronet_TTDispatchResultPtr Cronet_TTDispatchResult_Create(void);
CRONET_EXPORT void Cronet_TTDispatchResult_Destroy(
    Cronet_TTDispatchResultPtr self);
// Cronet_TTDispatchResult setters.
CRONET_EXPORT
void Cronet_TTDispatchResult_original_url_set(Cronet_TTDispatchResultPtr self,
                                              const Cronet_String original_url);
CRONET_EXPORT
void Cronet_TTDispatchResult_final_url_set(Cronet_TTDispatchResultPtr self,
                                           const Cronet_String final_url);
CRONET_EXPORT
void Cronet_TTDispatchResult_epoch_set(Cronet_TTDispatchResultPtr self,
                                       const Cronet_String epoch);
CRONET_EXPORT
void Cronet_TTDispatchResult_etag_set(Cronet_TTDispatchResultPtr self,
                                      const Cronet_String etag);
CRONET_EXPORT
void Cronet_TTDispatchResult_state_set(Cronet_TTDispatchResultPtr self,
                                       const Cronet_TTUrlDispatchState state);
// Cronet_TTDispatchResult getters.
CRONET_EXPORT
Cronet_String Cronet_TTDispatchResult_original_url_get(
    const Cronet_TTDispatchResultPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTDispatchResult_final_url_get(
    const Cronet_TTDispatchResultPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTDispatchResult_epoch_get(
    const Cronet_TTDispatchResultPtr self);
CRONET_EXPORT
Cronet_String Cronet_TTDispatchResult_etag_get(
    const Cronet_TTDispatchResultPtr self);
CRONET_EXPORT
Cronet_TTUrlDispatchState Cronet_TTDispatchResult_state_get(
    const Cronet_TTDispatchResultPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_IDL_C_H_
