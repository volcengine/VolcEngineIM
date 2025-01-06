import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper'
import { BIMAudioElement } from '@imcloud/imsdk'
import { OptionConfig } from '../../widget/input/msgpop/opt/OptionConfig'
import { BIMMessage } from '@imcloud/imsdk'


@Builder
export function buildAudioMessageUI(wrapper: BIMMessageWrapper) {
  AudioMessageUI({ msgWrapper: wrapper })
}

@Component
export struct AudioMessageUI {
  @ObjectLink msgWrapper: BIMMessageWrapper
  audioElement: BIMAudioElement | undefined
  duration: string = ""
  audioWidth: number = 0
  aboutToAppear(): void {
    this.audioElement = this.msgWrapper?.msg?.content as BIMAudioElement
    this.duration = `${this.audioElement.duration}'`
    this.audioWidth = this.audioElement.duration * 4
    if (this.audioWidth > 180) {
      this.audioWidth = 180
    }
  }

  build() {
    Row() {
      Row() {
        Row() {
          Image($r('app.media.icon_im_voice_recevie'))
            .width(18)
            .height(18)
            .objectFit(ImageFit.Contain)
          Text(this.duration).fontColor(Color.Black).fontSize(16).maxLines(1)
        }.visibility(this.msgWrapper.isSelf ? Visibility.None : Visibility.Visible)

        Row() {
          Text(this.duration).fontColor(Color.White).fontSize(16).maxLines(1)
          Image($r('app.media.icon_im_voice_send'))
            .width(18)
            .height(18)
            .objectFit(ImageFit.Contain)
        }.visibility(this.msgWrapper.isSelf ? Visibility.Visible : Visibility.None)
      }
      .backgroundColor(this.msgWrapper.isSelf ? '#5692ff' : '#f1f1f1')
      .padding({ left: 12, right: 12 })
      .height(40)
      .justifyContent(this.msgWrapper.isSelf ? FlexAlign.End : FlexAlign.Start)
      .width(60 + this.audioWidth)
      .borderRadius(6)

      Circle({width:6, height:6})
        .foregroundColor(Color.Red)
        .margin({left: 5})
        .visibility(!this.msgWrapper.isSelf && !this.msgWrapper.msg?.getLocalExt().get('hasPlay') ? Visibility.Visible : Visibility.None)
    }
  }
}

export class AudioOptionConfig extends OptionConfig {
  onInit(bimMessage:BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableCopy = false
  }
}

