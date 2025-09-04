import {  NapiVideoUploader } from 'libttuploader.so';
import hilog from '@ohos.hilog';
import { BDVideoInfo, EmptyVideoListener, ExternFileReaderListener, LogInfo, VideoInfoListener} from './Listener';
import { UploadKeys,UploadState } from './UploadKeys';
import { TTUploaderUtil } from './TTUploaderUtil';

interface Notifier {
  onInfo(what: number, arg1: number, arg2: number, info: string): void;

  onError(what: number, msg: String): void;
  onReadSlice(sliceId: number, buffer: ArrayBuffer, size: number): number;
  onReadSliceByOffset(offset: number, buffer: ArrayBuffer, maxSize: number, minSize: number): number;

}

export enum TTVideoUploadNotifier {
  MsgIsComplete = 0,
  MsgIsUpdateProgress = 1,
  MsgIsFail = 2,
  MsgIsUploadCancel = 3,
  MsgIsSingleVideoComplete = 8,
  MsgIsSingleVideoFail = 9,
  MsgIsAllVideosComplete = 10,
  MsgIsFlushComplete = 50,
  MessageIsDiskResumeInfoError = 120,
  MessageIsReadSliceUserCancel = 121,
}

export class TTVideoUploader implements Notifier {
  /**
   * Notice: this player is private
   */
  private videoUploader?: NapiVideoUploader;
  private mExternFileReaderListener: ExternFileReaderListener;
  private mVideoInfoListener: VideoInfoListener;
  private mEndTime?: number;
  private mState?: number = -1;

  constructor() {

    let videoUploader = new NapiVideoUploader(this, this.onInfo, this.onError, this.onReadSlice);
    this.videoUploader = videoUploader;
    let emptyListener = new EmptyVideoListener();
    this.mExternFileReaderListener = emptyListener;
    this.mVideoInfoListener = emptyListener;
    this.mState = UploadState.IsInit;
    // 边合成边上传
    // videoUploader.setExternFileReader(this, this.onReadSlice, this.onReadSliceByOffset, this.onGetCrc32ByOffset, this.onGetValue, this.onCancel);
    // enable native log
    videoUploader.setEnableNativeLog(TTUploaderUtil.getEnableNativeLog());
  }

  onInfo(what: number, parameter: number, code: number, notify: string): void {
    let info: BDVideoInfo | null = null;
    switch (what) {
      case TTVideoUploadNotifier.MsgIsSingleVideoComplete: {
        let tempParameter = parameter;
        let vid:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetVideoId, tempParameter);
        let coverUri:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetCoverUrI, tempParameter);
        let tosKey:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetTosKey, tempParameter);
        let encryptionMeta:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetEncryptionMeta, tempParameter);
        let callbackArgs:string = "";
        callbackArgs = this.getStrByKeyAndIndex(UploadKeys.KeyIsCallbackArgs, tempParameter);
        let videoMediaInfo:string = "";
        videoMediaInfo = this.getStrByKeyAndIndex(UploadKeys.KeyIsMediaInfo, tempParameter);
        info = new BDVideoInfo(vid, coverUri, parameter, code, "", tosKey, videoMediaInfo, encryptionMeta, callbackArgs);
        break;
      }

      case TTVideoUploadNotifier.MsgIsSingleVideoFail: {
        info = new BDVideoInfo("", "",  parameter, code, notify, "", "", "", "");
        break;
      }

      case TTVideoUploadNotifier.MsgIsComplete:
      case TTVideoUploadNotifier.MsgIsFlushComplete: {
        this.mEndTime = new Date().getTime();
        let vid:string  = this.getStringValue(UploadKeys.KeyIsGetVideoId);
        let coverUri:string  = this.getStringValue(UploadKeys.KeyIsGetCoverUrI);
        let tosKey:string  = this.getStringValue(UploadKeys.KeyIsGetTosKey);
        let encryptionMeta:string  = this.getStringValue(UploadKeys.KeyIsGetEncryptionMeta);
        let callbackArgs:string  = "";
        callbackArgs = this.getStringValue(UploadKeys.KeyIsCallbackArgs);
        let videoMediaInfo:string  = "";
        videoMediaInfo = this.getStringValue(UploadKeys.KeyIsMediaInfo);
        info = new BDVideoInfo(vid, coverUri, parameter, code, "", tosKey, videoMediaInfo,
          encryptionMeta, callbackArgs);
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        // TODO:liuxiaoli.lxl log埋点上报
        // addLogToManager(log);
        this.mState = UploadState.IsComplete;
        break;
      }
      case TTVideoUploadNotifier.MsgIsFail: {
        let location:string = this.getStringValue(UploadKeys.KeIsGetRedirectLocation);
        let errorMsg:string = this.getStringValue(UploadKeys.KeyIsGetUploadErrorMessage);
        info = new BDVideoInfo("", "",  parameter, code, errorMsg, location, "", "", "");
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        this.mState = UploadState.IsFail;
        break;
      }
      case TTVideoUploadNotifier.MessageIsReadSliceUserCancel: {
        let location:string = this.getStringValue(UploadKeys.KeIsGetRedirectLocation);
        let errorMsg:string = this.getStringValue(UploadKeys.KeyIsGetUploadErrorMessage);
        info = new BDVideoInfo("", "",  parameter, code, errorMsg, location, "", "", "");
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        this.mState = UploadState.IsFail;
        break;
      }
      case TTVideoUploadNotifier.MessageIsDiskResumeInfoError:
      case TTVideoUploadNotifier.MsgIsUpdateProgress: {
        info = new BDVideoInfo("", "", parameter, code, "", "", "", "", "");
          break;
      }
      case TTVideoUploadNotifier.MsgIsUploadCancel: {
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        let location:string = this.getStringValue(UploadKeys.KeIsGetRedirectLocation);
        info = new BDVideoInfo("", "", parameter, code, "", location, "", "", "");
        break;
      }
      case TTVideoUploadNotifier.MsgIsAllVideosComplete: {
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        info = new BDVideoInfo("", "", parameter, code, "", "", "", "", "");
        this.mState = UploadState.IsComplete;
        break;
      }
      default:
        break;
    }

    this.mVideoInfoListener.onNotify(what, info);

  }

  onLogInfo(what: number, code:number, info:string) {
    if (this.mState != UploadState.IsStart) {
      return;
    }
    let logInfo:LogInfo = new LogInfo(code, info);
    this.mVideoInfoListener.onLog(what, logInfo)
  }

  onError(what: number, msg: String): void {

  }



  setTopAccessKey(mAk: string): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTopAccessKey(mAk);
    }
  }

  setTopSecretKey(mSk: string): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTopSecretKey(mSk);
    }
  }

  setTopSessionToken(mSt: string): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTopSessionToken(mSt);
    }
  }

  setUploadDomain(mApplyHost: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setUploadDomain(mApplyHost);
    }
  }

  setSpaceName(mSpaceName: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSpaceName(mSpaceName);
    }
  }

  setServerParameter(mParameter: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setServerParameter(mParameter);
    }
  }

  setFileName(mFileName: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setFileName(mFileName);
    }
  }

  setFileTitle(mFileTitle: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setFileTitle(mFileTitle);
    }
  }

  setFileExtension(mFileExtension: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setFileExtension(mFileExtension);
    }
  }

  setFilePrefix(mFilePrefix: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setFilePrefix(mFilePrefix);
    }
  }

  setClassificationId(mClassificationId: number):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setClassificationId(mClassificationId);
    }
  }

  setPoster(mPosterTime: number):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setPoster(mPosterTime);
    }
  }

  setGetMetaMode(mGetMetaMode: number):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setGetMetaMode(mGetMetaMode);
    }
  }

  setTemplateId(mTemplateId: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTemplateId(mTemplateId);
    }
  }

  setRegionName(regionName: string):void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setRegionName(regionName);
    }
  }

  start(): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.start();
    }
  }

  stop(): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.stop();
    }
  }

  close(): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.close();
    }
    this.videoUploader = undefined;
  }

  allowMergeUpload(): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.allowMerge();
    }

    this.videoUploader = undefined;
  }

  cancelUpload(): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.cancelUpload();
    }
  }

  setPreUploadEncryptionMode(encryptionMode: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setPreUploadEncryptionMode(encryptionMode);
    }
  }

  setPathName(path: string): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setPathName(path);
    }
  }

  setPrivateVideo(val: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setPrivateVideo(val);
    }
  }

  setProcessActionType(val: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setProcessActionType(val);
    }
  }

  setSliceReTryCount(retryCount: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSliceReTryCount(retryCount);
    }
  }

  setFileRetryCount(retryCount: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setFileRetryCount(retryCount);
    }
  }

  setRWTimeout(timeOut: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setRWTimeout(timeOut);
    }
  }

  setSliceSize(size: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSliceSize(size);
    }
  }

  setSocketNum(num: number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSocketNum(num);
    }
  }

  setMaxFailTime(maxTime:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setMaxFailTime(maxTime);
    }
  }

  setSDKMaxRetryTimeout(timeout: number): void {  // only for ttnet
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSDKMaxRetryTimeout(timeout);
    }
  }

  setSDKMaxRetryCount(count: number): void {  // only for ttnet
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setSDKMaxRetryCount(count);
    }
  }

  setTTNetTimeoutParams(conn: number, read: number, write: number, totalReq: number, trans: number, policy: number): void { // only for ttnet
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTTNetTimeoutParams(conn, read, write, totalReq, trans, policy);
    }
  }

  setAliveMaxFailTime(maxFailTime:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setAliveMaxFailTime(maxFailTime);
    }
  }

  setTranTimeOutUnit(tranTimeOutUnit:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTranTimeOutUnit(tranTimeOutUnit);
    }
  }

  setTcpOpenTimeOutMilliSec(openTimeOutMilliSec:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setTcpOpenTimeOutMilliSec(openTimeOutMilliSec);
    }
  }

  setEnableHttps(isEnableHttps:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setEnableHttps(isEnableHttps);
    }
  }

  setNetworkType(type: number, value:number): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      videoUploader.setNetworkType(type, value);
    }
  }

  getStrByKeyAndIndex(key: number, index: number): string{
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      return videoUploader.getStrByKeyAndIndex(key, index);
    }
    return "";
  }

  getStringValue(key: number): string{
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      return videoUploader.getStringValue(key);
    }
    return "";
  }

  onReadSlice(sliceId: number, buffer: ArrayBuffer, size: number): number {
    return this.mExternFileReaderListener.onReadSlice(this, sliceId, buffer, size);
  }

  onReadSliceByOffset(offset: number, buffer: ArrayBuffer, maxSize: number, minSize: number): number {
    return this.mExternFileReaderListener.onReadSliceByOffset(this, offset, buffer, maxSize, minSize);
  }

  onGetCrc32ByOffset(offset: number, length: number): number {
    return this.mExternFileReaderListener.onGetCrc32ByOffset(this, offset, length);
  }

  onGetValue(key: number): number {
    return this.mExternFileReaderListener.onGetValue(this, key);
    // if (key == KeyIsGetFileSize) {
    //   return mFileLength;
    // } else if (key == KeyIsGetHeaderSize){
    //   return mHeaderLen;
    // }

    return -1;
  }

  onCancel(): void {
    this.mExternFileReaderListener.onCancel(this);

  }

  onSetValue(): void {

  }

  onGetAWSSignedHeaders(): void {

  }

  // setExternFileReader(): void {
  //   let videoUploader = this.videoUploader;
  //   if (videoUploader) {
  //     videoUploader.setExternFileReader(this, this.onReadSlice, this.onReadSliceByOffset, this.onGetCrc32ByOffset, this.onGetValue, this.onCancel);
  //   }
  // }

  setExternFileReaderListener(listener: ExternFileReaderListener): void {
    this.mExternFileReaderListener = listener;

  }

  setVideoInfoListener(listener: VideoInfoListener): void {
    this.mVideoInfoListener = listener;
  }

  setPolicyParams(policyParams: Record<string, Object>): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      let policyParamsStr : string = JSON.stringify(policyParams);
      videoUploader.setPolicyParams(policyParamsStr);
    }
  }

  setConfig(config: Record<string, Object>): void {
    let videoUploader = this.videoUploader;
    if (videoUploader) {
      let configStr : string = JSON.stringify(config);
      videoUploader.setConfig(configStr);
    }
  }
}



