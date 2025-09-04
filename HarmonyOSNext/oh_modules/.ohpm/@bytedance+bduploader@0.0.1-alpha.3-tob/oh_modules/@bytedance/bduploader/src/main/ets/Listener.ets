import { TTVideoUploader } from './TTVideoUploader';
import { TTImageUploader } from './TTImageUploader';
import constant from '@ohos.bluetooth.constant';

export interface ExternFileReaderListener {
  onReadSlice(uploader:TTVideoUploader, sliceId: number, buffer: ArrayBuffer, size: number): number;
  onReadSliceByOffset(uploader:TTVideoUploader, offset: number, buffer: ArrayBuffer, maxSize: number, minSize: number): number;
  onGetCrc32ByOffset(uploader:TTVideoUploader, offset: number, length: number): number;
  onGetValue(uploader:TTVideoUploader, key: number): number;
  onCancel(uploader:TTVideoUploader, ): void;
}

export interface VideoInfoListener {
  onNotify(what: number, info: BDVideoInfo | null): void;
  onLog(what: number, info:LogInfo): void;
}

export interface ImageInfoListener {
  onNotify(what: number, info: BDImageInfo | null): void;
  onLog(what: number, info:LogInfo): void;
}
export enum TTImageUploadNotifier {
  MsgIsComplete = 0,
  MsgIsUpdateProgress = 1,
  MsgIsFail = 2,
  MsgIsUploadCancel = 3,
  MsgIsSingleImageComplete = 6,
  MsgIsSingleImageFail = 7,
  MessageIsUploadCompleteTos = 122,
  MessageIsPreHeatComplete = 123,
  MessageIsPreHeatResultUsed = 124,
}

export class EmptyVideoListener implements ExternFileReaderListener, VideoInfoListener {
  onReadSlice(uploader:TTVideoUploader, sliceId: number, buffer: ArrayBuffer, size: number): number {
    const uint8View = new Uint8Array(buffer);

    // 填充数组的内容
    for (let i = 0; i < uint8View.length; i++) {
      uint8View[i] = i;

    }
    // 返回实际读到的size返回给native层
    return 1;
  }

  onReadSliceByOffset(uploader:TTVideoUploader, offset: number, buffer: ArrayBuffer, maxSize: number, minSize: number): number {
    const uint8View = new Uint8Array(buffer);

    // 填充数组的内容
    for (let i = 0; i < uint8View.length; i++) {
      uint8View[i] = i;

    }
    // 返回实际读到的size返回给native层
    return 1;
  }

  onGetCrc32ByOffset(uploader:TTVideoUploader, offset: number, length: number): number {
    return 123456;
  }

  onGetValue(uploader:TTVideoUploader, key: number): number {
    return -1;
  }

  onCancel(uploader:TTVideoUploader ): void {

  }

  onNotify(what: number, info: BDVideoInfo | null): void {

  }

  onLog(what:number, info:LogInfo):void {

  }

}

export class EmptyImageListener implements ImageInfoListener {
  onCancel(uploader:TTImageUploader ): void {

  }

  onNotify(what: number, info: BDImageInfo): void {

  }

  onLog(what:number, info:LogInfo):void {

  }

}
export class BDVideoInfo {
  public mVideoId? :string;
  public mCoverUri? :string;
  public mTosKey? :string;
  public mProgress? :number;
  public mErrorCode? :number;
  public mErrorMsg? :string;
  public mVideoMediaInfo? :string;
  public mEncryptionMeta? :string;
  public mCallbackArgs? :string;
  public mFileIndex? :number;

  constructor(vid: string, coverUri: string, parameter: number, progress: number, msg: string, tosKey: string,
              videoInfo: string, encryption: string, callbackArgs: string) {
    this.mVideoId = vid;
    this.mCoverUri = coverUri;
    this.mProgress = parameter;
    this.mFileIndex = parameter;
    this.mErrorCode = progress;
    this.mErrorMsg = msg;
    this.mTosKey = tosKey;
    this.mVideoMediaInfo = videoInfo;
    this.mEncryptionMeta = encryption;
    this.mCallbackArgs = callbackArgs;
  }
}

export class BDImageInfo {
  public mImageTosKey: string;
  public mFileIndex: number = -1;
  public mProgress: number;
  public mErrorCode: number;
  public mErrorMsg: string;
  public mMetaInfo: string;
  public mEncryptionMeta: string;

  constructor(uri: string, parameter: number, msg: string, fileIndex: number, metaInfo: string,
              encInfo: string) {
    this.mImageTosKey = uri;
    this.mProgress = parameter;
    this.mErrorCode = parameter;
    this.mErrorMsg = msg;
    this.mFileIndex = fileIndex;
    this.mMetaInfo = metaInfo;
    this.mEncryptionMeta = encInfo;
  }
}


export class LogInfo {
  private code:number;
  private info:string;

  getCode():number {
    return this.code;
  }

  getInfo():string {
    return this.info;
  }

  constructor(code:number, info:string) {
    this.code = code;
    this.info = info;
  }
}
