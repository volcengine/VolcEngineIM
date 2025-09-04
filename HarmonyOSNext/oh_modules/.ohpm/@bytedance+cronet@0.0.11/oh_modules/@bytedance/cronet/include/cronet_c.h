// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef COMPONENTS_CRONET_NATIVE_INCLUDE_CRONET_C_H_
#define COMPONENTS_CRONET_NATIVE_INCLUDE_CRONET_C_H_

#include "cronet_export.h"

// Cronet public C API is generated from cronet.idl
#include "cronet.idl_c.h"
// #if BUILDFLAG(TTNET_IMPLEMENT)
#include "cronet_bis.idl_c.h"
#include "cronet_detector.idl_c.h"
#include "cronet_diagnosis.idl_c.h"
#include "cronet_frontier.idl_c.h"
#include "cronet_mdns.idl_c.h"
#include "cronet_socket.idl_c.h"
#include "cronet_throttle.idl_c.h"
#include "cronet_ws.idl_c.h"
//#if BUILD(TTQUICHE_IMPLEMENT)
#include "tt_quiche.idl_c.h"
//#endif
// #endif

#ifdef __cplusplus
extern "C" {
#endif

// Stream Engine used by Bidirectional Stream C API for GRPC.
typedef struct stream_engine stream_engine;

// Additional Cronet C API not generated from cronet.idl.

// Sets net::CertVerifier* raw_mock_cert_verifier for testing of Cronet_Engine.
// Must be called before Cronet_Engine_InitWithParams().
CRONET_EXPORT void Cronet_Engine_SetMockCertVerifierForTesting(
    Cronet_EnginePtr engine,
    /* net::CertVerifier* */ void* raw_mock_cert_verifier);

// Returns "stream_engine" interface for bidirectionsl stream support for GRPC.
// Returned stream engine is owned by Cronet Engine and is only valid until
// Cronet_Engine_Shutdown().
CRONET_EXPORT stream_engine* Cronet_Engine_GetStreamEngine(
    Cronet_EnginePtr engine);

#ifdef __cplusplus
}
#endif

#endif  // COMPONENTS_CRONET_NATIVE_INCLUDE_CRONET_C_H_
