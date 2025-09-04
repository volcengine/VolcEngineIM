import { vibrator } from "@kit.SensorServiceKit";

/**
 * List All Napi Wrapper Class And Napi Function
 */
export class NapiVideoUploader {
  constructor(recv, onInfo, onError, onReadSlice);
  setTopAccessKey(mAk: string): void;
  setTopSecretKey(mSk: string): void;
  setTopSessionToken(mSt: string): void;
  setUploadDomain(mApplyHost: string): void;
  setSpaceName(mSpaceName: string): void;
  setServerParameter(mParameter: string): void;
  setUserReference(extraPreference: string): void;
  setProcessActionType(processType: number): void;
  setSliceReTryCount(retryCount: number): void;
  setFileRetryCount(retryCount: number): void;
  setRWTimeout(timeOut: number): void;
  setSliceSize(size: number): void;
  setSocketNum(num: number): void;
  setMaxFailTime(maxTime: number): void;
  setSDKMaxRetryTimeout(timeout: number): void; // only for ttnet
  setSDKMaxRetryCount(count: number): void; // only for ttnet
  setTTNetTimeoutParams(conn: number, read: number, write: number, totalReq: number, trans: number, policy: number): void;  // only for ttnet
  setAliveMaxFailTime(maxFailTime:number): void;
  setTranTimeOutUnit(tranTimeOutUnit:number): void;
  setTcpOpenTimeOutMilliSec(openTimeOutMilliSec:number): void;
  setEnableHttps(isEnableHttps:number): void;
  setNetworkType(type: number, value:number): void;
  setServerParameter(finalServerParam: string): void;
  setObjectType(objectType: string): void;
  setPathName(pathName: string): void;
  setPrivateVideo(val: number): void;
  setProcessActionType(val: number): void;
  setEnableNativeLog(enableNativeLog: number): void;
  setFileName(name: string): void; // 设置云端存储路径
  setFileExtension(fileExtension: string): void; // 设置文件后缀
  setFilePrefix(filePrefix: string): void; // 设置文件前缀
  setFileTitle(fileTitle: string): void; // 设置文件标题
  setClassificationId(classificationId: number): void; // 设置分类
  setPoster(posterTime: number): void; // 设置封面图抽帧时间, 单位:秒
  setGetMetaMode(mode: number): void; // 设置全异步抽取 Meta
  setTemplateId(templateId: string): void; // 设置工作流模板 ID
  setRegionName(regionName: String): void; // 设置regionName
  start(): void;
  stop(): void;
  close(): void;
  allowMerge(): void;
  cancelUpload(): void;
  setPreUploadEncryptionMode(encryptionMode: number): void;
  setPathName(path: string): void;
  setExternFileReader(reader: object, callback1, callback2, callback3, callback4, callback5): void;
  getStrByKeyAndIndex(key: number, index: number): string;
  getStringValue(key: number): string;
  setPolicyParams(policyParams: string): void;
  setConfig(config: string): void;
}

export class NapiImageUploader {
  constructor(recv, onInfo, onError, onReadSlice);
  setTopAccessKey(mAk: string): void;
  setTopSecretKey(mSk: string): void;
  setTopSessionToken(mSt: string): void;
  setUploadDomain(mApplyHost: string): void;
  setSpaceName(mSpaceName: string): void;
  setServiceID(mServiceID: string): void;
  setUserReference(extraPreference: string): void;
  setProcessActionType(processType: number): void;
  setServerParameter(finalServerParam: string): void;
  setObjectType(objectType: string): void;
  setPathName(pathName: string): void;
  setSliceReTryCount(retryCount: number): void;
  setFileRetryCount(retryCount: number): void;
  setRWTimeout(timeOut: number): void;
  setSocketNum(num: number): void;
  setMaxFailTime(maxTime:number): void;
  setSDKMaxRetryTimeout(timeout: number): void; // only for ttnet
  setSDKMaxRetryCount(count: number): void; // only for ttnet
  setTTNetTimeoutParams(conn: number, read: number, write: number, totalReq: number, trans: number, policy: number): void;  // only for ttnet
  setEnableHttps(isEnableHttps:number): void;
  setNetworkType(type: number, value:number): void;
  setEnableNativeLog(enableNativeLog: number): void;
  start(): void;
  stop(): void;
  close(): void;
  allowMerge(): void;
  cancelUpload(): void;
  setPreUploadEncryptionMode(encryptionMode: number): void;
  setPathName(path: string): void;
  setPrivateVideo(val: number): void;
  getStrByKeyAndIndex(key: number, index: number): string;
  getStringValue(key: number): string;
  setEnableCommitUpload(commitType: number): void;
  setFilePath(fileNum: number, path: string[]): void;
  setFileStoreKeys(fileNum: number, storeKeys: string[]): void; // 设置fileStoreKeys
  setFileExtension(fileExtension: string): void; // 设置文件后缀
  setFilePrefix(filePrefix: string): void; // 设置文件前缀
  setEnableMd5StoryKey(enableMd5StoryKey: boolean): void; // 设置是否使用md5作为文件名
  setRegionName(regionName: String): void; // 设置regionName
  setEnableOverwrite(overrite: boolean): void; // 设置是否开启文件重名覆盖上传
  setEnableSkipMeta(skipMeta: boolean): void; // 设置是否返回图片 Meta 信息，默认值为 false
  setSliceThreshold(sliceThreshold: number): void; // 设置是否分片，直传传入1024 * 1024 * 1024，分片传入1024 * 1024
  setSliceSize(size: number): void;
  setPolicyParams(policyParams: string): void;
  setConfig(config: string): void;
}

