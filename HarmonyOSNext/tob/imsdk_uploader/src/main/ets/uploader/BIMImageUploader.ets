import { IMImageUploadResult, IMLogService, IMUploadListener, IMUploadTokenInfo } from '@imcloud/imsdk_common';
import { BDImageInfo, LogInfo, TTImageUploader, TTImageUploadNotifier, TTUploaderUtil, UploadType } from '@bytedance/bduploader';
import { IMAccessor } from '@imcloud/imsdk_common';

export class BIMImageUploader {
  private tag = "INIMImageUploader"
  private logger: IMLogService
  private imAccessor: IMAccessor
  private imageUploader: TTImageUploader | undefined

  constructor(imAccessor: IMAccessor) {
    this.logger = imAccessor.logger;
    this.imAccessor = imAccessor
    TTUploaderUtil.setEnableNativeLog(1)
  }

  public async uploadImage(path: string, type: number, encrypt: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMImageUploadResult>) {
    this.logger.log(IMLogService.level_info, this.tag, `uploadImage path:${path}  type:${type} isEncrpty:${encrypt} token:${JSON.stringify(tokenInfo)} `)
    listener.onStart()
    TTUploaderUtil.setEnableNativeLog(1); // 0: disable native log, 1: enable native log
    this.imageUploader = new TTImageUploader(UploadType.InnerUploaderTypeImageX);
    this.imageUploader.setFilePath(1, [path]);
    this.imageUploader.setTopAccessKey(tokenInfo.access_key);
    this.imageUploader.setTopSecretKey(tokenInfo.secret_access_key);
    this.imageUploader.setTopSessionToken(tokenInfo.token)
    this.imageUploader.setServiceID(tokenInfo.service_id);
    this.imageUploader.setUploadDomain("imagex.volcengineapi.com");
    this.imageUploader.setRegionName("cn-north-1");
    this.imageUploader.setEnableMd5StoryKey(false);
    this.imageUploader.setEnableSkipMeta(true); //跳过回调图片信息
    this.imageUploader.setEnableOverwrite(false); //同名文件覆盖
    this.imageUploader.setImageInfoListener({
      onNotify: (what: number, info: BDImageInfo | null) => {
        this.logger.log(IMLogService.level_debug, this.tag, `onNotify what:${what} info:${JSON.stringify(info)}`)
        if (what == TTImageUploadNotifier.MsgIsSingleImageComplete) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify MsgIsSingleImageComplete`)
          let imImageUploadResult = new IMImageUploadResult()
          if (info?.mEncryptionMeta) {
            let encryptionObj: object = JSON.parse(info?.mEncryptionMeta)
            let encryTosKey: string = encryptionObj["Uri"];
            let secretKey: string = encryptionObj["SecretKey"]
            let algorithm: string = encryptionObj["Algorithm"]
            imImageUploadResult.encryptTosKey = encryTosKey
            imImageUploadResult.secKey = secretKey
            imImageUploadResult.algorithm = algorithm
          }
          imImageUploadResult.isEncrypt = encrypt
          imImageUploadResult.originTosKey = info?.mImageTosKey
          listener?.onSuccess(imImageUploadResult)
        } else if (what == TTImageUploadNotifier.MsgIsSingleImageFail) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify MsgIsSingleImageFail`)
          this.imageUploader?.close()
          listener?.onFailed(info?.mErrorCode, info?.mErrorMsg)
        } else if (what == TTImageUploadNotifier.MsgIsUpdateProgress) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify MsgIsUpdateProgress progress:${info?.mProgress}`)
          listener?.onProgress(info?.mProgress)
        } else if (what == TTImageUploadNotifier.MsgIsComplete) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify MsgIsComplete progress:${info?.mProgress}`)
        } else if (what == TTImageUploadNotifier.MsgIsFail) {
          this.imageUploader?.close()
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify MsgIsComplete MsgIsFail info:${JSON.stringify(info)}`)
        } else {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify default! `)
        }
      },
      onLog: (what: number, info: LogInfo) => {
        this.logger.log(IMLogService.level_debug, this.tag, `onLog what:${what} info:${JSON.stringify(info)}`)
      }
    })
    this.imageUploader.start()
  }
}