// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* DO NOT EDIT. Generated from
 * components/cronet/native/generated/cronet_socket.idl */

#ifndef COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_SOCKET_IDL_C_H_
#define COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_SOCKET_IDL_C_H_
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
typedef struct Cronet_TcpClientSocketDelegate Cronet_TcpClientSocketDelegate;
typedef struct Cronet_TcpClientSocketDelegate*
    Cronet_TcpClientSocketDelegatePtr;
typedef struct Cronet_TcpServerSocketDelegate Cronet_TcpServerSocketDelegate;
typedef struct Cronet_TcpServerSocketDelegate*
    Cronet_TcpServerSocketDelegatePtr;
typedef struct Cronet_UdpClientSocketDelegate Cronet_UdpClientSocketDelegate;
typedef struct Cronet_UdpClientSocketDelegate*
    Cronet_UdpClientSocketDelegatePtr;
typedef struct Cronet_UdpServerSocketDelegate Cronet_UdpServerSocketDelegate;
typedef struct Cronet_UdpServerSocketDelegate*
    Cronet_UdpServerSocketDelegatePtr;
typedef struct Cronet_TcpClientSocket Cronet_TcpClientSocket;
typedef struct Cronet_TcpClientSocket* Cronet_TcpClientSocketPtr;
typedef struct Cronet_TcpServerSocket Cronet_TcpServerSocket;
typedef struct Cronet_TcpServerSocket* Cronet_TcpServerSocketPtr;
typedef struct Cronet_UdpClientSocket Cronet_UdpClientSocket;
typedef struct Cronet_UdpClientSocket* Cronet_UdpClientSocketPtr;
typedef struct Cronet_UdpServerSocket Cronet_UdpServerSocket;
typedef struct Cronet_UdpServerSocket* Cronet_UdpServerSocketPtr;

// Forward declare structs.
typedef struct Cronet_SocketParams Cronet_SocketParams;
typedef struct Cronet_SocketParams* Cronet_SocketParamsPtr;

// Declare enums

// Declare constants

///////////////////////
// Abstract interface Cronet_TcpClientSocketDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TcpClientSocketDelegate.
CRONET_EXPORT void Cronet_TcpClientSocketDelegate_Destroy(
    Cronet_TcpClientSocketDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TcpClientSocketDelegate_SetClientContext(
    Cronet_TcpClientSocketDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TcpClientSocketDelegate_GetClientContext(
    Cronet_TcpClientSocketDelegatePtr self);
// Abstract interface Cronet_TcpClientSocketDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TcpClientSocketDelegate_OnCreateSocket(
    Cronet_TcpClientSocketDelegatePtr self);
CRONET_EXPORT
void Cronet_TcpClientSocketDelegate_OnConnected(
    Cronet_TcpClientSocketDelegatePtr self);
CRONET_EXPORT
void Cronet_TcpClientSocketDelegate_OnError(
    Cronet_TcpClientSocketDelegatePtr self,
    int32_t error);
CRONET_EXPORT
void Cronet_TcpClientSocketDelegate_OnReceivedData(
    Cronet_TcpClientSocketDelegatePtr self,
    Cronet_String data,
    uint64_t size);
// The app implements abstract interface Cronet_TcpClientSocketDelegate by
// defining custom functions for each method.
typedef void (*Cronet_TcpClientSocketDelegate_OnCreateSocketFunc)(
    Cronet_TcpClientSocketDelegatePtr self);
typedef void (*Cronet_TcpClientSocketDelegate_OnConnectedFunc)(
    Cronet_TcpClientSocketDelegatePtr self);
typedef void (*Cronet_TcpClientSocketDelegate_OnErrorFunc)(
    Cronet_TcpClientSocketDelegatePtr self,
    int32_t error);
typedef void (*Cronet_TcpClientSocketDelegate_OnReceivedDataFunc)(
    Cronet_TcpClientSocketDelegatePtr self,
    Cronet_String data,
    uint64_t size);
// The app creates an instance of Cronet_TcpClientSocketDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_TcpClientSocketDelegatePtr
Cronet_TcpClientSocketDelegate_CreateWith(
    Cronet_TcpClientSocketDelegate_OnCreateSocketFunc OnCreateSocketFunc,
    Cronet_TcpClientSocketDelegate_OnConnectedFunc OnConnectedFunc,
    Cronet_TcpClientSocketDelegate_OnErrorFunc OnErrorFunc,
    Cronet_TcpClientSocketDelegate_OnReceivedDataFunc OnReceivedDataFunc);

///////////////////////
// Abstract interface Cronet_TcpServerSocketDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_TcpServerSocketDelegate.
CRONET_EXPORT void Cronet_TcpServerSocketDelegate_Destroy(
    Cronet_TcpServerSocketDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TcpServerSocketDelegate_SetClientContext(
    Cronet_TcpServerSocketDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TcpServerSocketDelegate_GetClientContext(
    Cronet_TcpServerSocketDelegatePtr self);
// Abstract interface Cronet_TcpServerSocketDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_TcpServerSocketDelegate_OnCreateSocket(
    Cronet_TcpServerSocketDelegatePtr self);
CRONET_EXPORT
void Cronet_TcpServerSocketDelegate_OnAccepted(
    Cronet_TcpServerSocketDelegatePtr self,
    Cronet_TcpClientSocketPtr accepted_socket);
CRONET_EXPORT
void Cronet_TcpServerSocketDelegate_OnError(
    Cronet_TcpServerSocketDelegatePtr self,
    int32_t error);
// The app implements abstract interface Cronet_TcpServerSocketDelegate by
// defining custom functions for each method.
typedef void (*Cronet_TcpServerSocketDelegate_OnCreateSocketFunc)(
    Cronet_TcpServerSocketDelegatePtr self);
typedef void (*Cronet_TcpServerSocketDelegate_OnAcceptedFunc)(
    Cronet_TcpServerSocketDelegatePtr self,
    Cronet_TcpClientSocketPtr accepted_socket);
typedef void (*Cronet_TcpServerSocketDelegate_OnErrorFunc)(
    Cronet_TcpServerSocketDelegatePtr self,
    int32_t error);
// The app creates an instance of Cronet_TcpServerSocketDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_TcpServerSocketDelegatePtr
Cronet_TcpServerSocketDelegate_CreateWith(
    Cronet_TcpServerSocketDelegate_OnCreateSocketFunc OnCreateSocketFunc,
    Cronet_TcpServerSocketDelegate_OnAcceptedFunc OnAcceptedFunc,
    Cronet_TcpServerSocketDelegate_OnErrorFunc OnErrorFunc);

///////////////////////
// Abstract interface Cronet_UdpClientSocketDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_UdpClientSocketDelegate.
CRONET_EXPORT void Cronet_UdpClientSocketDelegate_Destroy(
    Cronet_UdpClientSocketDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UdpClientSocketDelegate_SetClientContext(
    Cronet_UdpClientSocketDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UdpClientSocketDelegate_GetClientContext(
    Cronet_UdpClientSocketDelegatePtr self);
// Abstract interface Cronet_UdpClientSocketDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_UdpClientSocketDelegate_OnCreateSocket(
    Cronet_UdpClientSocketDelegatePtr self);
CRONET_EXPORT
void Cronet_UdpClientSocketDelegate_OnError(
    Cronet_UdpClientSocketDelegatePtr self,
    int32_t error);
CRONET_EXPORT
void Cronet_UdpClientSocketDelegate_OnReceivedData(
    Cronet_UdpClientSocketDelegatePtr self,
    Cronet_String data,
    uint64_t size);
// The app implements abstract interface Cronet_UdpClientSocketDelegate by
// defining custom functions for each method.
typedef void (*Cronet_UdpClientSocketDelegate_OnCreateSocketFunc)(
    Cronet_UdpClientSocketDelegatePtr self);
typedef void (*Cronet_UdpClientSocketDelegate_OnErrorFunc)(
    Cronet_UdpClientSocketDelegatePtr self,
    int32_t error);
typedef void (*Cronet_UdpClientSocketDelegate_OnReceivedDataFunc)(
    Cronet_UdpClientSocketDelegatePtr self,
    Cronet_String data,
    uint64_t size);
// The app creates an instance of Cronet_UdpClientSocketDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_UdpClientSocketDelegatePtr
Cronet_UdpClientSocketDelegate_CreateWith(
    Cronet_UdpClientSocketDelegate_OnCreateSocketFunc OnCreateSocketFunc,
    Cronet_UdpClientSocketDelegate_OnErrorFunc OnErrorFunc,
    Cronet_UdpClientSocketDelegate_OnReceivedDataFunc OnReceivedDataFunc);

///////////////////////
// Abstract interface Cronet_UdpServerSocketDelegate is implemented by the app.

// There is no method to create a concrete implementation.

// Destroy an instance of Cronet_UdpServerSocketDelegate.
CRONET_EXPORT void Cronet_UdpServerSocketDelegate_Destroy(
    Cronet_UdpServerSocketDelegatePtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UdpServerSocketDelegate_SetClientContext(
    Cronet_UdpServerSocketDelegatePtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UdpServerSocketDelegate_GetClientContext(
    Cronet_UdpServerSocketDelegatePtr self);
// Abstract interface Cronet_UdpServerSocketDelegate is implemented by the app.
// The following concrete methods forward call to app implementation.
// The app doesn't normally call them.
CRONET_EXPORT
void Cronet_UdpServerSocketDelegate_OnCreateSocket(
    Cronet_UdpServerSocketDelegatePtr self);
CRONET_EXPORT
void Cronet_UdpServerSocketDelegate_OnReceivedData(
    Cronet_UdpServerSocketDelegatePtr self,
    Cronet_SocketParamsPtr client_socket,
    Cronet_String data,
    uint64_t size);
CRONET_EXPORT
void Cronet_UdpServerSocketDelegate_OnError(
    Cronet_UdpServerSocketDelegatePtr self,
    int32_t error);
// The app implements abstract interface Cronet_UdpServerSocketDelegate by
// defining custom functions for each method.
typedef void (*Cronet_UdpServerSocketDelegate_OnCreateSocketFunc)(
    Cronet_UdpServerSocketDelegatePtr self);
typedef void (*Cronet_UdpServerSocketDelegate_OnReceivedDataFunc)(
    Cronet_UdpServerSocketDelegatePtr self,
    Cronet_SocketParamsPtr client_socket,
    Cronet_String data,
    uint64_t size);
typedef void (*Cronet_UdpServerSocketDelegate_OnErrorFunc)(
    Cronet_UdpServerSocketDelegatePtr self,
    int32_t error);
// The app creates an instance of Cronet_UdpServerSocketDelegate by providing
// custom functions for each method.
CRONET_EXPORT Cronet_UdpServerSocketDelegatePtr
Cronet_UdpServerSocketDelegate_CreateWith(
    Cronet_UdpServerSocketDelegate_OnCreateSocketFunc OnCreateSocketFunc,
    Cronet_UdpServerSocketDelegate_OnReceivedDataFunc OnReceivedDataFunc,
    Cronet_UdpServerSocketDelegate_OnErrorFunc OnErrorFunc);

///////////////////////
// Concrete interface Cronet_TcpClientSocket.

// Create an instance of Cronet_TcpClientSocket.
CRONET_EXPORT Cronet_TcpClientSocketPtr Cronet_TcpClientSocket_Create(void);
// Destroy an instance of Cronet_TcpClientSocket.
CRONET_EXPORT void Cronet_TcpClientSocket_Destroy(
    Cronet_TcpClientSocketPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TcpClientSocket_SetClientContext(
    Cronet_TcpClientSocketPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TcpClientSocket_GetClientContext(Cronet_TcpClientSocketPtr self);
// Concrete methods of Cronet_TcpClientSocket implemented by Cronet.
// The app calls them to manipulate Cronet_TcpClientSocket.
CRONET_EXPORT
void Cronet_TcpClientSocket_CreateSocket(Cronet_TcpClientSocketPtr self,
                                         Cronet_SocketParamsPtr params);
CRONET_EXPORT
void Cronet_TcpClientSocket_Connect(Cronet_TcpClientSocketPtr self);
CRONET_EXPORT
bool Cronet_TcpClientSocket_IsConnected(Cronet_TcpClientSocketPtr self);
CRONET_EXPORT
void Cronet_TcpClientSocket_Disconnect(Cronet_TcpClientSocketPtr self);
CRONET_EXPORT
void Cronet_TcpClientSocket_WriteData(Cronet_TcpClientSocketPtr self,
                                      Cronet_String data,
                                      uint64_t size);
CRONET_EXPORT
void Cronet_TcpClientSocket_AddDelegate(
    Cronet_TcpClientSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_TcpClientSocket_RemoveDelegate(
    Cronet_TcpClientSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_TcpClientSocket is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_TcpClientSocket_CreateSocketFunc)(
    Cronet_TcpClientSocketPtr self,
    Cronet_SocketParamsPtr params);
typedef void (*Cronet_TcpClientSocket_ConnectFunc)(
    Cronet_TcpClientSocketPtr self);
typedef bool (*Cronet_TcpClientSocket_IsConnectedFunc)(
    Cronet_TcpClientSocketPtr self);
typedef void (*Cronet_TcpClientSocket_DisconnectFunc)(
    Cronet_TcpClientSocketPtr self);
typedef void (*Cronet_TcpClientSocket_DestroyFunc)(
    Cronet_TcpClientSocketPtr self);
typedef void (*Cronet_TcpClientSocket_WriteDataFunc)(
    Cronet_TcpClientSocketPtr self,
    Cronet_String data,
    uint64_t size);
typedef void (*Cronet_TcpClientSocket_AddDelegateFunc)(
    Cronet_TcpClientSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_TcpClientSocket_RemoveDelegateFunc)(
    Cronet_TcpClientSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_TcpClientSocket is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_TcpClientSocketPtr Cronet_TcpClientSocket_CreateWith(
    Cronet_TcpClientSocket_CreateSocketFunc CreateSocketFunc,
    Cronet_TcpClientSocket_ConnectFunc ConnectFunc,
    Cronet_TcpClientSocket_IsConnectedFunc IsConnectedFunc,
    Cronet_TcpClientSocket_DisconnectFunc DisconnectFunc,
    Cronet_TcpClientSocket_DestroyFunc DestroyFunc,
    Cronet_TcpClientSocket_WriteDataFunc WriteDataFunc,
    Cronet_TcpClientSocket_AddDelegateFunc AddDelegateFunc,
    Cronet_TcpClientSocket_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Concrete interface Cronet_TcpServerSocket.

// Create an instance of Cronet_TcpServerSocket.
CRONET_EXPORT Cronet_TcpServerSocketPtr Cronet_TcpServerSocket_Create(void);
// Destroy an instance of Cronet_TcpServerSocket.
CRONET_EXPORT void Cronet_TcpServerSocket_Destroy(
    Cronet_TcpServerSocketPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_TcpServerSocket_SetClientContext(
    Cronet_TcpServerSocketPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_TcpServerSocket_GetClientContext(Cronet_TcpServerSocketPtr self);
// Concrete methods of Cronet_TcpServerSocket implemented by Cronet.
// The app calls them to manipulate Cronet_TcpServerSocket.
CRONET_EXPORT
void Cronet_TcpServerSocket_CreateSocket(Cronet_TcpServerSocketPtr self,
                                         Cronet_SocketParamsPtr params);
CRONET_EXPORT
void Cronet_TcpServerSocket_Accept(Cronet_TcpServerSocketPtr self);
CRONET_EXPORT
void Cronet_TcpServerSocket_AddDelegate(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpServerSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_TcpServerSocket_RemoveDelegate(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpServerSocketDelegatePtr delegate);
CRONET_EXPORT
void Cronet_TcpServerSocket_AddClientDelegate(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_TcpServerSocket_RemoveClientDelegate(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_TcpServerSocket is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_TcpServerSocket_CreateSocketFunc)(
    Cronet_TcpServerSocketPtr self,
    Cronet_SocketParamsPtr params);
typedef void (*Cronet_TcpServerSocket_AcceptFunc)(
    Cronet_TcpServerSocketPtr self);
typedef void (*Cronet_TcpServerSocket_DestroyFunc)(
    Cronet_TcpServerSocketPtr self);
typedef void (*Cronet_TcpServerSocket_AddDelegateFunc)(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpServerSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_TcpServerSocket_RemoveDelegateFunc)(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpServerSocketDelegatePtr delegate);
typedef void (*Cronet_TcpServerSocket_AddClientDelegateFunc)(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_TcpServerSocket_RemoveClientDelegateFunc)(
    Cronet_TcpServerSocketPtr self,
    Cronet_TcpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_TcpServerSocket is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_TcpServerSocketPtr Cronet_TcpServerSocket_CreateWith(
    Cronet_TcpServerSocket_CreateSocketFunc CreateSocketFunc,
    Cronet_TcpServerSocket_AcceptFunc AcceptFunc,
    Cronet_TcpServerSocket_DestroyFunc DestroyFunc,
    Cronet_TcpServerSocket_AddDelegateFunc AddDelegateFunc,
    Cronet_TcpServerSocket_RemoveDelegateFunc RemoveDelegateFunc,
    Cronet_TcpServerSocket_AddClientDelegateFunc AddClientDelegateFunc,
    Cronet_TcpServerSocket_RemoveClientDelegateFunc RemoveClientDelegateFunc);

///////////////////////
// Concrete interface Cronet_UdpClientSocket.

// Create an instance of Cronet_UdpClientSocket.
CRONET_EXPORT Cronet_UdpClientSocketPtr Cronet_UdpClientSocket_Create(void);
// Destroy an instance of Cronet_UdpClientSocket.
CRONET_EXPORT void Cronet_UdpClientSocket_Destroy(
    Cronet_UdpClientSocketPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UdpClientSocket_SetClientContext(
    Cronet_UdpClientSocketPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UdpClientSocket_GetClientContext(Cronet_UdpClientSocketPtr self);
// Concrete methods of Cronet_UdpClientSocket implemented by Cronet.
// The app calls them to manipulate Cronet_UdpClientSocket.
CRONET_EXPORT
void Cronet_UdpClientSocket_CreateSocket(Cronet_UdpClientSocketPtr self,
                                         Cronet_SocketParamsPtr params);
CRONET_EXPORT
void Cronet_UdpClientSocket_Close(Cronet_UdpClientSocketPtr self);
CRONET_EXPORT
void Cronet_UdpClientSocket_WriteData(Cronet_UdpClientSocketPtr self,
                                      Cronet_String data,
                                      uint64_t size);
CRONET_EXPORT
void Cronet_UdpClientSocket_AddDelegate(
    Cronet_UdpClientSocketPtr self,
    Cronet_UdpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_UdpClientSocket_RemoveDelegate(
    Cronet_UdpClientSocketPtr self,
    Cronet_UdpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_UdpClientSocket is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_UdpClientSocket_CreateSocketFunc)(
    Cronet_UdpClientSocketPtr self,
    Cronet_SocketParamsPtr params);
typedef void (*Cronet_UdpClientSocket_CloseFunc)(
    Cronet_UdpClientSocketPtr self);
typedef void (*Cronet_UdpClientSocket_DestroyFunc)(
    Cronet_UdpClientSocketPtr self);
typedef void (*Cronet_UdpClientSocket_WriteDataFunc)(
    Cronet_UdpClientSocketPtr self,
    Cronet_String data,
    uint64_t size);
typedef void (*Cronet_UdpClientSocket_AddDelegateFunc)(
    Cronet_UdpClientSocketPtr self,
    Cronet_UdpClientSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_UdpClientSocket_RemoveDelegateFunc)(
    Cronet_UdpClientSocketPtr self,
    Cronet_UdpClientSocketDelegatePtr delegate);
// Concrete interface Cronet_UdpClientSocket is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_UdpClientSocketPtr Cronet_UdpClientSocket_CreateWith(
    Cronet_UdpClientSocket_CreateSocketFunc CreateSocketFunc,
    Cronet_UdpClientSocket_CloseFunc CloseFunc,
    Cronet_UdpClientSocket_DestroyFunc DestroyFunc,
    Cronet_UdpClientSocket_WriteDataFunc WriteDataFunc,
    Cronet_UdpClientSocket_AddDelegateFunc AddDelegateFunc,
    Cronet_UdpClientSocket_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Concrete interface Cronet_UdpServerSocket.

// Create an instance of Cronet_UdpServerSocket.
CRONET_EXPORT Cronet_UdpServerSocketPtr Cronet_UdpServerSocket_Create(void);
// Destroy an instance of Cronet_UdpServerSocket.
CRONET_EXPORT void Cronet_UdpServerSocket_Destroy(
    Cronet_UdpServerSocketPtr self);
// Set and get app-specific Cronet_ClientContext.
CRONET_EXPORT void Cronet_UdpServerSocket_SetClientContext(
    Cronet_UdpServerSocketPtr self,
    Cronet_ClientContext client_context);
CRONET_EXPORT Cronet_ClientContext
Cronet_UdpServerSocket_GetClientContext(Cronet_UdpServerSocketPtr self);
// Concrete methods of Cronet_UdpServerSocket implemented by Cronet.
// The app calls them to manipulate Cronet_UdpServerSocket.
CRONET_EXPORT
void Cronet_UdpServerSocket_CreateSocket(Cronet_UdpServerSocketPtr self,
                                         Cronet_SocketParamsPtr params);
CRONET_EXPORT
void Cronet_UdpServerSocket_WriteData(Cronet_UdpServerSocketPtr self,
                                      Cronet_SocketParamsPtr params,
                                      Cronet_String data,
                                      uint64_t size);
CRONET_EXPORT
void Cronet_UdpServerSocket_Close(Cronet_UdpServerSocketPtr self);
CRONET_EXPORT
void Cronet_UdpServerSocket_AddDelegate(
    Cronet_UdpServerSocketPtr self,
    Cronet_UdpServerSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
CRONET_EXPORT
void Cronet_UdpServerSocket_RemoveDelegate(
    Cronet_UdpServerSocketPtr self,
    Cronet_UdpServerSocketDelegatePtr delegate);
// Concrete interface Cronet_UdpServerSocket is implemented by Cronet.
// The app can implement these for testing / mocking.
typedef void (*Cronet_UdpServerSocket_CreateSocketFunc)(
    Cronet_UdpServerSocketPtr self,
    Cronet_SocketParamsPtr params);
typedef void (*Cronet_UdpServerSocket_WriteDataFunc)(
    Cronet_UdpServerSocketPtr self,
    Cronet_SocketParamsPtr params,
    Cronet_String data,
    uint64_t size);
typedef void (*Cronet_UdpServerSocket_CloseFunc)(
    Cronet_UdpServerSocketPtr self);
typedef void (*Cronet_UdpServerSocket_DestroyFunc)(
    Cronet_UdpServerSocketPtr self);
typedef void (*Cronet_UdpServerSocket_AddDelegateFunc)(
    Cronet_UdpServerSocketPtr self,
    Cronet_UdpServerSocketDelegatePtr delegate,
    Cronet_ExecutorPtr executor);
typedef void (*Cronet_UdpServerSocket_RemoveDelegateFunc)(
    Cronet_UdpServerSocketPtr self,
    Cronet_UdpServerSocketDelegatePtr delegate);
// Concrete interface Cronet_UdpServerSocket is implemented by Cronet.
// The app can use this for testing / mocking.
CRONET_EXPORT Cronet_UdpServerSocketPtr Cronet_UdpServerSocket_CreateWith(
    Cronet_UdpServerSocket_CreateSocketFunc CreateSocketFunc,
    Cronet_UdpServerSocket_WriteDataFunc WriteDataFunc,
    Cronet_UdpServerSocket_CloseFunc CloseFunc,
    Cronet_UdpServerSocket_DestroyFunc DestroyFunc,
    Cronet_UdpServerSocket_AddDelegateFunc AddDelegateFunc,
    Cronet_UdpServerSocket_RemoveDelegateFunc RemoveDelegateFunc);

///////////////////////
// Struct Cronet_SocketParams.
CRONET_EXPORT Cronet_SocketParamsPtr Cronet_SocketParams_Create(void);
CRONET_EXPORT void Cronet_SocketParams_Destroy(Cronet_SocketParamsPtr self);
// Cronet_SocketParams setters.
CRONET_EXPORT
void Cronet_SocketParams_ip_addr_set(Cronet_SocketParamsPtr self,
                                     const Cronet_String ip_addr);
CRONET_EXPORT
void Cronet_SocketParams_port_set(Cronet_SocketParamsPtr self,
                                  const int32_t port);
CRONET_EXPORT
void Cronet_SocketParams_key_add(Cronet_SocketParamsPtr self,
                                 const uint8_t element);
CRONET_EXPORT
void Cronet_SocketParams_nonce_add(Cronet_SocketParamsPtr self,
                                   const uint8_t element);
// Cronet_SocketParams getters.
CRONET_EXPORT
Cronet_String Cronet_SocketParams_ip_addr_get(
    const Cronet_SocketParamsPtr self);
CRONET_EXPORT
int32_t Cronet_SocketParams_port_get(const Cronet_SocketParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_SocketParams_key_size(const Cronet_SocketParamsPtr self);
CRONET_EXPORT
uint8_t Cronet_SocketParams_key_at(const Cronet_SocketParamsPtr self,
                                   uint32_t index);
CRONET_EXPORT
void Cronet_SocketParams_key_clear(Cronet_SocketParamsPtr self);
CRONET_EXPORT
uint32_t Cronet_SocketParams_nonce_size(const Cronet_SocketParamsPtr self);
CRONET_EXPORT
uint8_t Cronet_SocketParams_nonce_at(const Cronet_SocketParamsPtr self,
                                     uint32_t index);
CRONET_EXPORT
void Cronet_SocketParams_nonce_clear(Cronet_SocketParamsPtr self);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_GENERATED_CRONET_SOCKET_IDL_C_H_
