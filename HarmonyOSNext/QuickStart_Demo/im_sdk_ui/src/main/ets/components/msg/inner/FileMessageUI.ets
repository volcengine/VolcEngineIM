import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper'
import { BIMFileElement } from '@imcloud/imsdk'
import { OptionConfig } from '../../widget/input/msgpop/opt/OptionConfig'
import { BIMMessage } from '@imcloud/imsdk'
import { BIMUIClient } from '../../../api/BIMUIClient'


@Builder
export function buildFileMessageUI(wrapper: BIMMessageWrapper) {
  FileMessageUI({ msgWrapper: wrapper })
}

@Component
export struct FileMessageUI {
  @ObjectLink msgWrapper: BIMMessageWrapper
  name: string = ""
  length: string = ""
  fileElement: BIMFileElement | undefined

  aboutToAppear(): void {
    this.fileElement = this.msgWrapper.msg?.getElement() as BIMFileElement
    this.name = this.fileElement.fileName
    let suffix = "B"
    let l = this.fileElement.fileSize
    this.length = `${l}${suffix}`
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Column() {
        Text(this.name)
          .fontSize(18)
          .fontColor(Color.White)
          .maxLines(2)
          .width(150)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
        Text(this.length)
          .fontSize(15)
          .fontColor(Color.White)
          .maxLines(1)
          .width(150)
          .margin({top:2})
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 8 })

      Stack() {
        Image($r('app.media.icon_file_msg'))
          .width(60)
          .height(60)
          .margin(10)
        Progress({ value: this.msgWrapper.progress, total: 100, type: ProgressType.Ring })
          .width(30)
          .height(30)
          .visibility(this.msgWrapper.progress > 0 && this.msgWrapper.progress < 100 ? Visibility.Visible : Visibility.None)
      }.width(70)
      .height(70)
      .alignContent(Alignment.Center)
    }.width(240)
    .height(80)
    .backgroundColor('#5692ff')
    .borderRadius(6)
  }
}

export class FileOptionConfig extends OptionConfig {

  onInit(bimMessage:BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableCopy = false
    this.isEnableEdit = false

  }
}

