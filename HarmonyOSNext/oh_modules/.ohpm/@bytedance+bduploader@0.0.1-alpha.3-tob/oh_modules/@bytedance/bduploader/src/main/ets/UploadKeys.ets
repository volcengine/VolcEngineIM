
export enum UploadState {
  IsInit = 0,
  IsStart = 1,
  IsFail = 2,
  IsComplete = 3,
  IsStop = 4,
  IsClose = 5,
}

export enum UploadType {
  InnerUploaderTypeVodImage,
  InnerUploaderTypeImageX,
  InnerUploaderTypeObject,
}

export enum CommitType {
  CommitTypeNoCommit = 0, // 1003和1004完成，上传对象生命周期就结束了 ，不走1005阶段，
  CommitTypeCommit = 1, // 走1005阶段，1005 成功结束，才认为上传成功，生命周期结束
  CommitTypeNoDepend = 2, // // 不依赖1005阶段，即1003和1004完成，就可以认为是上传成功，但是需要在1005完成之后再释放上传对象
}

export enum UploadGetMetaMode {
  GET_META_SYNC = 0,
  GET_META_ASYNC = 1,
}

export enum UploadKeys {

  // TOB KEYS
  KeyIsFileName = 1000,
  KeyIsOptionInfo = 1001,
  KeyIsCallbackArgs = 1002,
  KeyIsTitle = 1003,
  KeyIsTags = 1004,
  KeyIsDescription = 1005,
  KeyIsCategory = 1006,
  KeyIsFormat = 1007,
  KeyIsRecordType = 1008,
  KeyIsClassificationId = 1009,

  KeyIsFileExtension  = 1010,
  KeyIsFilePrefix  = 1011,
  KeyIsFlushUploadMode = 1012,
  KeyIsMd5StoreKey = 1013,
  KeyIsGetMetaMode = 1014,
  KeyIsOverwrite = 1015,
  KeyIsTemplateId = 1016,

  // INNER KEYS
  KeyIsGetVideoId = 10,
  KeyIsGetCoverUrl = 11,
  KeyIsGetCoverUrI = 12,
  KeyIsMaxFailTime = 13,
  KeIsGetRedirectLocation = 14,
  KeIsAuthorization = 15,
  KeyIsServerParameter = 16,
  KeyIsIsUseServerHost = 17,
  KeyIsIsUseUpHost = 18,
  KeyIsEnableHttps = 19,
  KeyIsEnableKeepAlive = 20,
  KeyIsEnableExternDNS = 21,
  KeyIsAliveMaxFailTime = 22,
  KeyIsEnablePostMethod = 23,
  KeyIsTcpOpenTimeOutMilliSec = 24,
  KeyIsEnableFileTryHttps = 25,
  KeyIsEnableExternNet = 26,
  KeyIsExternNetLoader = 27,
  KeyIsEnableQuic = 28,
  KeyIsEnableMutiTask = 29,
  KeyIsNewHttpProxyLoader = 40,
  KeyIsMediaInfo = 68,
  KeyIsSetfileNum = 71,
  KeyIsGetLog = 100,
  KeyIsGetTosKey = 300,
  KeyIsEnableVideoBatch = 304,
  KeyIsMaxConcurrentFile = 400,
  KeyIsGetEncryptionMeta = 407,
  KeyIsGetImageURI = 409,
  KeyIsGetImageMeta = 410,
  KeyIsGetUploadErrorMessage = 415,
  KeyIsSkipMeta = 435,
  KeyIsEstimatedVideoInfo = 436,
  KeyIsTTNetEngineFallback = 437,
  // skip 438
  KeyIsEnd2EndEncryptionOption = 439,
  KeyIsEnd2EndEncryptionPublicKey = 440,
  KeyIsEnd2EndEncryptionAESKey = 441,
  KeyIsGetVideoURI = 442,
  KeyIsGetVideoMeta = 443,

  // INTELLIGENT CASES
  KeyIsIntelligentInitialRouting = 0,
  KeyIsIntelligentPredictRouting = 1,
  KeyIsIntelligentInitialSpeedTest = 2,
  KeyIsIntelligentPredictSpeedTest = 3,
  KeyIsIntelligentInitialSpeedTestTTNet = 4,
  KeyIsIntelligentPredictSpeedTestTTNet = 5,
}
