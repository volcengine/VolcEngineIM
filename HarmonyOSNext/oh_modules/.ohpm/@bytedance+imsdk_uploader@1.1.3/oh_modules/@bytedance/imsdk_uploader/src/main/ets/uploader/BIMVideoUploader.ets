import { IMAccessor, IMLogService, IMUploadListener, IMUploadTokenInfo, IMVideoUploadResult } from '@imcloud/imsdk_common'
import { BDVideoInfo, LogInfo, TTVideoUploader, TTVideoUploadNotifier } from '@bytedance/bduploader'

export class BIMVideoUploader {
  private tag = "INIMVideoUploader"
  private logger: IMLogService
  private imAccessor: IMAccessor
  private videoUploader: TTVideoUploader | undefined

  constructor(imAccessor: IMAccessor) {
    this.logger = imAccessor.logger;
    this.imAccessor = imAccessor
  }

  public async uploadVideo(path: string, type: number, encrypt: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMVideoUploadResult>) {
    this.logger.log(IMLogService.level_info, this.tag, `uploadVideo  path:${path} type:${type} isEncrpty:${encrypt} token:${JSON.stringify(tokenInfo)}`)
    listener.onStart()
    this.videoUploader = new TTVideoUploader();
    if (tokenInfo.hosts.length == 0) {
      this.videoUploader.setUploadDomain("vod.volcengineapi.com")
    } else {
      this.videoUploader.setUploadDomain(tokenInfo.hosts[0])
    }
    this.videoUploader.setRegionName("cn-north-1")
    this.videoUploader.setTopAccessKey(tokenInfo.access_key)
    this.videoUploader.setTopSecretKey(tokenInfo.secret_access_key)
    this.videoUploader.setTopSessionToken(tokenInfo.token)
    this.videoUploader.setSpaceName(tokenInfo.space_name)
    this.videoUploader.setPathName(path)

    this.videoUploader.setVideoInfoListener({
      onNotify: (what: number, info: BDVideoInfo | null) => {
        this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo what:${what} info:${JSON.stringify(info)}`)
        if (what == TTVideoUploadNotifier.MsgIsUpdateProgress) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo MsgIsUpdateProgress progress:${info?.mProgress}`)
          listener?.onProgress(info?.mProgress)
        } else if (what == TTVideoUploadNotifier.MsgIsComplete) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo MsgIsComplete`)
          let videoUploadResult = new IMVideoUploadResult(info?.mTosKey ?? "", info?.mCoverUri ?? "", info?.mVideoId)
          this.videoUploader?.close()
          listener?.onSuccess(videoUploadResult)
        } else if (what == TTVideoUploadNotifier.MsgIsSingleVideoFail) {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo MsgIsSingleVideoFail info:${JSON.stringify(info)}`)
          this.videoUploader?.close()
          listener?.onFailed(info?.mErrorCode, info?.mErrorMsg)
        } else {
          this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo default! `)
        }
      },
      onLog: (what: number, info: LogInfo) => {
        this.logger.log(IMLogService.level_debug, this.tag, `onLog uploadVideo what:${what} info:${JSON.stringify(info)}`)
      }
    })
    this.logger.log(IMLogService.level_debug, this.tag, `onNotify uploadVideo real start`)
    this.videoUploader.start()
  }
}