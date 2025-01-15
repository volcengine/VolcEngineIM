import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper';
import { BIMErrorCode, BIMMessage, BIMMessageType, BIMVideoElement } from '@imcloud/imsdk';
import { BIMMessageStatus } from '@imcloud/imsdk';
import { OptionConfig } from '../../widget/input/msgpop/opt/OptionConfig';
import { BIMUIClient } from '../../../api/BIMUIClient';
import BIMUILog from '../../../log/BIMUILog';

@Builder
export function buildVideoMessageUI(wrapper: BIMMessageWrapper) {
  VideoMessageUI({ msgWrapper: wrapper })
}

@Component
export struct VideoMessageUI {
  private readonly TAG = "VideoMessageUI"
  @Consume itemMsgWidth: number
  @ObjectLink msgWrapper: BIMMessageWrapper
  videoElement: BIMVideoElement | undefined
  videoWidth: number = 200
  videoHeight: number = 200
  @State url: PixelMap | ResourceStr | undefined = ""
  retryCount = 0

  aboutToAppear(): void {
    this.videoElement = this.msgWrapper?.msg?.getElement() as BIMVideoElement
    let orginWidth = 200
    let orginHeight = 200
    let elementWidth = this.videoElement?.coverImg?.width ?? 0
    let elementHeight = this.videoElement?.coverImg?.height ?? 0
    if (elementWidth > 0) {
      orginWidth = px2vp(elementWidth)
    }
    if (elementHeight > 0) {
      orginHeight = px2vp(elementHeight)
    }
    console.debug(this.TAG, `video load url videoElement:${this.videoElement} orginWidth:${orginWidth} orginHeight:${orginHeight}`)
    let videoCoverUrl = this.videoElement?.coverImg?.url
    let maxWidth = this.itemMsgWidth / 2
    let scale = maxWidth / orginWidth
    this.videoWidth = maxWidth
    this.videoHeight = orginHeight * scale
    console.debug(this.TAG, `video load url coverUrl:${videoCoverUrl}`)
    if (videoCoverUrl && videoCoverUrl.length>0) {
      this.url = videoCoverUrl
    } else {
      this.url = $r('app.media.imsdk_emoji_60')
    }
    console.debug(this.TAG, `video real use url url:${this.url} width:${this.videoWidth} height:${this.videoHeight}`)
  }

  build() {
    Stack() {
      Image(this.url)
        .width(this.videoWidth)
        .height(this.videoHeight)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .onError(() => {
          this.refreshUrl()
        })
      Progress({ value: this.msgWrapper.progress, total: 100, type: ProgressType.Ring })
        .width(30)
        .height(30)
        .color(Color.Blue)
        .backgroundColor(Color.Gray)
        .visibility(this.msgWrapper.sendStatus == BIMMessageStatus.BIM_MESSAGE_STATUS_SENDING ? Visibility.Visible : Visibility.Hidden)
      Image($r('app.media.icon_im_video_play'))
        .width(36)
        .height(36)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .visibility((this.msgWrapper.sendStatus == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS
          || this.msgWrapper.sendStatus == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL) ? Visibility.Visible : Visibility.None)
    }.width(this.videoWidth)
    .height(this.videoHeight)
    .clip(true)
    .alignContent(Alignment.Center)
  }

  private async refreshUrl() {
    let msg = this.msgWrapper.msg
    if (msg && this.retryCount < 3) {
      let r = await BIMUIClient.getInstance().refreshMediaMessage(msg)
      if (r.code == BIMErrorCode.BIM_OK) {
        let videoElement = r.data?.getElement() as BIMVideoElement
        let newUrl = videoElement.coverImg?.url ?? ""
        BIMUILog.debug(this.TAG, `refreshUrl oldUrl:${this.url} newUrl:${newUrl}`)
        this.url = newUrl
      } else {
        BIMUILog.debug(this.TAG, `refreshUrl failed:${r.code}`)
      }
    } else {
      this.url = $r('app.media.imsdk_emoji_60') //兜底
    }
    this.retryCount++;
  }
}

export class VideoOptionConfig extends OptionConfig {
  onInit(bimMessage: BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableCopy = false
    this.isEnableEdit = false
  }
}

