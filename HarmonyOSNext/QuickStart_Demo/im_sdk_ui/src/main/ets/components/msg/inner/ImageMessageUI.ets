import { BIMImageElement } from '@imcloud/imsdk'
import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper'
import { OptionConfig } from '../../widget/input/msgpop/opt/OptionConfig'
import { BIMUIClient } from '../../../api/BIMUIClient'
import { BIMErrorCode, BIMMessage, BIMMessageStatus } from '@imcloud/imsdk'
import BIMUILog from '../../../log/BIMUILog'
import { fileUri } from '@kit.CoreFileKit'


@Builder
export function buildImageMessageUI(wrapper: BIMMessageWrapper) {
  ImageMessageUI({ msgWrapper: wrapper })
}

@Component
export struct ImageMessageUI {
  private readonly TAG = "ImageMessageUI"
  @Consume itemMsgWidth: number
  @ObjectLink msgWrapper: BIMMessageWrapper
  imageElement: BIMImageElement | undefined
  showWidth: number = 200
  showHeight: number = 200
  @State url: ResourceStr = $r('app.media.imsdk_emoji_60')
  retryCount = 0;

  aboutToAppear(): void {
    this.imageElement = this.msgWrapper?.msg?.content as BIMImageElement
    this.showWidth = px2vp(this.imageElement?.largeImg?.width ?? 200)
    this.showHeight = px2vp(this.imageElement?.largeImg?.height ?? 200)
    let maxWidth = this.itemMsgWidth / 2
    if (this.showWidth > maxWidth) {
      let scale = maxWidth / this.showWidth
      this.showWidth = maxWidth
      this.showHeight = Math.floor(this.showHeight * scale)
    }
    console.debug(this.TAG,`image load url localUri:${this.imageElement?.localUri} largeUrl:${this.imageElement?.largeImg?.url}`)
    if (this.imageElement?.localUri) {
      this.url = this.imageElement?.localUri
    } else if (this.imageElement?.largeImg?.url) {
      this.url = this.imageElement?.largeImg?.url
    } else {
      this.url = $r('app.media.imsdk_emoji_60')
    }
    console.debug(this.TAG,`image load real url:${this.url}`)
  }

  build() {
    Stack() {
      Image(this.url)
        .width(this.showWidth)
        .height(this.showHeight)
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
    }.width(this.showWidth)
    .height(this.showHeight)
    .alignContent(Alignment.Center)
  }

  private async refreshUrl() {
    let msg = this.msgWrapper.msg
    if (msg && this.retryCount < 3) {
      let r = await BIMUIClient.getInstance().refreshMediaMessage(msg)
      if (r.code == BIMErrorCode.BIM_OK) {
        let imageContent = r.data?.content as BIMImageElement
        let newUrl = imageContent.largeImg?.url ?? ""
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

export class ImageOptionConfig extends OptionConfig {
  onInit(bimMessage:BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableCopy = false
    this.isEnableEdit = false
  }
}

