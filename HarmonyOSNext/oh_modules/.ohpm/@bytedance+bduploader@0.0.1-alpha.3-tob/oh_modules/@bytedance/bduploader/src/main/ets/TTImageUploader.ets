import {  NapiImageUploader } from 'libttuploader.so';
import hilog from '@ohos.hilog';
import ApplicationStateChangeCallback from '@ohos.app.ability.ApplicationStateChangeCallback';
import { BDImageInfo, EmptyImageListener, LogInfo, ImageInfoListener, TTImageUploadNotifier} from './Listener';
import { UploadKeys,UploadState} from './UploadKeys';
import { TTUploaderUtil } from './TTUploaderUtil';
import { JSON } from '@kit.ArkTS';

interface Notifier {
  onInfo(what: number, arg1: number, arg2: number, info: string): void;
  onError(what: number, msg: String): void;
}
export class TTImageUploader implements Notifier {
  /**
   * Notice: this uploader is private
   */
  private imageUploader?: NapiImageUploader;
  private mImageInfoListener: ImageInfoListener;
  private mEndTime?: number;
  private mState?: number = -1;
  private uploadType?: number = 0;
  // private log?: string = null;

  constructor(uploadType:number) {
    this.uploadType = uploadType;
    let imageUploader = new NapiImageUploader(this, this.onInfo, this.onError, this.uploadType);
    this.imageUploader = imageUploader;
    let emptyListener = new EmptyImageListener();
    this.mImageInfoListener = emptyListener;
    this.mState = UploadState.IsInit;

    imageUploader.setEnableNativeLog(TTUploaderUtil.getEnableNativeLog());
  }

  onInfo(what: number, parameter: number, code: number, notify: string): void {
    let info: BDImageInfo | null = null;
    hilog.info(0x0000, 'UploaderImageListener', 'onInfo:%{public}d', what);
    switch (what) {
      case TTImageUploadNotifier.MsgIsSingleImageComplete: {
        let tempParameter = parameter;
        let uri:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetImageURI, tempParameter);
        let metaInfo:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetImageMeta, tempParameter);
        let encInfo:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetEncryptionMeta, tempParameter);
        info = new BDImageInfo(uri, 0, "", tempParameter, metaInfo, encInfo);
        break;
      }

      case TTImageUploadNotifier.MsgIsSingleImageFail: {
        let tempParameter = parameter;
        let errorMsg:string = this.getStrByKeyAndIndex(UploadKeys.KeyIsGetUploadErrorMessage, tempParameter);
        info = new BDImageInfo("", code, notify, tempParameter, "", "");
        break;
      }

      case TTImageUploadNotifier.MsgIsComplete: {
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        // TODO:liuxiaoli.lxl log埋点上报
        // addLogToManager(log);
        this.mState = UploadState.IsComplete;
        break;
      }
      case TTImageUploadNotifier.MsgIsFail: {
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        // addLogToManager(log);
        this.mState = UploadState.IsFail;
        break;
      }
      case TTImageUploadNotifier.MsgIsUploadCancel: {
        let log:string = this.getStringValue(UploadKeys.KeyIsGetLog);
        // addLogToManager(log);
        this.mState = UploadState.IsFail;
        break;
      }
      case TTImageUploadNotifier.MsgIsUpdateProgress: {
        let tempParameter = parameter;
        info = new BDImageInfo("", code, "", tempParameter, "", "");
        break;
      }
      case TTImageUploadNotifier.MessageIsUploadCompleteTos: {
        break;
      }
      case TTImageUploadNotifier.MessageIsPreHeatComplete: {
        let tempParameter = parameter;
        info = new BDImageInfo("", code, "", tempParameter, "", "");
        break;
      }
      case TTImageUploadNotifier.MessageIsPreHeatResultUsed: {
        let tempParameter = parameter;
        if (tempParameter == 0) { // S_OK is 0
          tempParameter = 1;
        } else {
          tempParameter = 0;
        }
        break;
      }
      default:
        break;
    }

    this.mImageInfoListener.onNotify(what, info);
  }

  onLogInfo(what: number, code:number, info:string) {
    if (this.mState != UploadState.IsStart) {
      return;
    }
    let logInfo:LogInfo = new LogInfo(code, info);
    this.mImageInfoListener.onLog(what, logInfo)
  }

  onError(what: number, msg: String): void {

  }

  setTopAccessKey(mAk: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setTopAccessKey(mAk);
    }
  }

  setTopSecretKey(mSk: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setTopSecretKey(mSk);
    }
  }

  setTopSessionToken(mSt: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setTopSessionToken(mSt);
    }
  }

  setUploadDomain(mApplyHost: string):void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setUploadDomain(mApplyHost);
    }
  }

  setSpaceName(mSpaceName: string):void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSpaceName(mSpaceName);
    }
  }

  setServiceID(mServiceID: string):void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setServiceID(mServiceID);
    }
  }

  setServerParameter(mParameter: string):void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setServerParameter(mParameter);
    }
  }

  setSliceSize(size: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSliceSize(size);
    }
  }

  start(): void {
    let imageUploader = this.imageUploader;
    switch(this.mState) {
      case UploadState.IsStart:
        hilog.info(0x0000, 'ttmn_upload', 'start:%{public}s', 'Already started');
        break;
      case UploadState.IsFail:
      case UploadState.IsComplete:
      case UploadState.IsClose:
        hilog.info(0x0000, 'ttmn_upload', '%{public}s:%{public}d', 'no need to start', this.mState);
        break;
      default:
        if (imageUploader) {
          imageUploader.start();
          this.mState = UploadState.IsStart;
        }
        break;
    }

  }

  setFilePath(fileNum: number, path:string[]): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setFilePath(fileNum, path);
    }
  }

  setFileStoreKeys(fileNum: number, storeKeys: string[]): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setFileStoreKeys(fileNum, storeKeys);
    }
  }

  setFileExtension(fileExtension: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setFileExtension(fileExtension);
    }
  }

  setFilePrefix(filePrefix: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setFilePrefix(filePrefix);
    }
  }

  setEnableMd5StoryKey(enableMd5StoryKey: boolean): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setEnableMd5StoryKey(enableMd5StoryKey);
    }
  }

  setRegionName(regionName: string):void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setRegionName(regionName);
    }
  }

  setEnableOverwrite(overrite: boolean): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setEnableOverwrite(overrite);
    }
  }

  setEnableSkipMeta(skipMeta: boolean): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setEnableSkipMeta(skipMeta);
    }
  }

  setSliceThreshold(sliceThreshold: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSliceThreshold(sliceThreshold);
    }
  }

  stop(): void {
    let imageUploader = this.imageUploader;
    switch(this.mState) {
      case UploadState.IsFail:
      case UploadState.IsComplete:
      case UploadState.IsStop:
      case UploadState.IsClose:
        hilog.info(0x0000, 'ttmn_upload', 'stop:state is %{public}d,no need to stop',  this.mState);
        break;
      default:
        if (imageUploader) {
          imageUploader.stop();
          this.mState = UploadState.IsStop;
        }
        break;
    }
  }

  close(): void {
    let imageUploader = this.imageUploader;
    switch (this.mState) {
      case UploadState.IsClose:
        hilog.info(0x0000, 'ttmn_upload', 'state is :%{public}d,no need to close', this.mState);
        break;
      default:
        if (imageUploader) {
          imageUploader.close();
          this.mState = UploadState.IsClose;
          this.imageUploader = undefined;
        }
        break;
    }
  }

  allowMergeUpload(): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.allowMerge();
    }
  }

  cancelUpload(): void {
    let imageUploader = this.imageUploader;
    switch (this.mState) {
      case UploadState.IsClose:
        hilog.info(0x0000, 'ttmn_upload', 'state is :%{public}d,no need to cancelUpload', this.mState);
        break;
      default:
        if (imageUploader) {
          imageUploader.cancelUpload();
        }
        break;
    }
  }

  setPreUploadEncryptionMode(encryptionMode: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setPreUploadEncryptionMode(encryptionMode);
    }
  }

  setPathName(path: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setPathName(path);
    }
  }

  setSliceReTryCount(retryCount: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSliceReTryCount(retryCount);
    }
  }

  setFileRetryCount(retryCount: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setFileRetryCount(retryCount);
    }
  }

  setRWTimeout(timeOut: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setRWTimeout(timeOut);
    }
  }

  setSocketNum(num: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSocketNum(num);
    }
  }

  setMaxFailTime(maxTime: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setMaxFailTime(maxTime);
    }
  }

  setSDKMaxRetryTimeout(timeout: number): void {  // only for ttnet
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSDKMaxRetryTimeout(timeout);
    }
  }

  setSDKMaxRetryCount(count: number): void {  // only for ttnet
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setSDKMaxRetryCount(count);
    }
  }

  setTTNetTimeoutParams(conn: number, read: number, write: number, totalReq: number, trans: number, policy: number): void { // only for ttnet
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setTTNetTimeoutParams(conn, read, write, totalReq, trans, policy);
    }
  }

  setEnableHttps(isEnableHttps:number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setEnableHttps(isEnableHttps);
    }

  }
  setNetworkType(type: number, value:number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setNetworkType(type, value);
    }
  }

  setProcessActionType(val: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setProcessActionType(val);
    }
  }

  setObjectType(type: string): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setObjectType(type);
    }
  }

  getStrByKeyAndIndex(key: number, index: number): string{
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      return imageUploader.getStrByKeyAndIndex(key, index);
    }
    return "";
  }

  getStringValue(key: number): string{
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      return imageUploader.getStringValue(key);
    }
    return "";
  }

  setEnableCommitUpload(commitType: number): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      imageUploader.setEnableCommitUpload(commitType);
    }
  }

  setImageInfoListener(listener: ImageInfoListener): void {
    this.mImageInfoListener = listener;
  }

  setPolicyParams(policyParams: Record<string, Object>): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      let policyParamsStr : string = JSON.stringify(policyParams);
      imageUploader.setPolicyParams(policyParamsStr);
    }
  }

  setConfig(config: Record<string, Object>): void {
    let imageUploader = this.imageUploader;
    if (imageUploader) {
      let configStr : string = JSON.stringify(config);
      imageUploader.setConfig(configStr);
    }
  }
}



