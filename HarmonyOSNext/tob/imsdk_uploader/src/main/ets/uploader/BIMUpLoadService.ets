import { IMAccessor, IMImageUploadResult, IMUploaderService, IMUploadListener, IMUploadTokenInfo, IMVideoUploadResult } from '@imcloud/imsdk_common';
import { TTUploaderUtil } from '@bytedance/bduploader';
import { BIMImageUploader } from './BIMImageUploader';
import { BIMVideoUploader } from './BIMVideoUploader';

export class BIMUpLoadService extends IMUploaderService {

  private imageUploader: BIMImageUploader | undefined
  private videoUploader: BIMVideoUploader | undefined

  init(context: Context, imAccessor: IMAccessor): void {
    console.debug("BIMUpLoadService init")
    this.imageUploader = new BIMImageUploader(imAccessor)
    this.videoUploader = new BIMVideoUploader(imAccessor)
    TTUploaderUtil.setEnableNativeLog(1)
  }

  public uploadImage(path: string, type: number, encrypt: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMImageUploadResult>): void {
    this.imageUploader?.uploadImage(path, type, encrypt, tokenInfo, listener)
  }

  public uploadVideo(path: string, type: number, encrypt: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMVideoUploadResult>): void {
    this.videoUploader?.uploadVideo(path, type, encrypt, tokenInfo, listener)
  }
}