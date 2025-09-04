import { BIMActionType, BIMErrorCode, BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { ComponentContent } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';
import { systemDateTime } from '@kit.BasicServicesKit'

export class PinOption extends OptionInfo {
  private readonly tag = "PinOption"
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_read_callback');
  title: string = "pin"

  onClick(msg: BIMMessage): void {
    BIMUILog.debug("MsgOption", `PinOption ${msg.getUuid()}`)
    this.showCustomDialog(msg)
  }

  private showCustomDialog(msg: BIMMessage) {
    let promptAction = this.uiContext.getPromptAction();
    let tags = ["0", "1", "2", "3"]
    let contentNode = new ComponentContent(this.uiContext, wrapBuilder(buildText), new Params(tags, async (tag) => {
      promptAction.closeCustomDialog(contentNode)
      let time = systemDateTime.getTime()
      let tagNumber = Number.parseInt(tag)
      let r = await BIMUIClient.getInstance().markMessage(msg, BIMActionType.BIM_ACTION_PIN, true, time, tagNumber)
      if (r?.code == BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: `pin 成功` })
      } else {
        promptAction.showToast({ message: `pin 失败` })
      }
    }))
    try {
      promptAction.openCustomDialog(contentNode);
    } catch (error) {
      BIMUILog.error(this.tag, `OpenCustomDialog args error code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
}

class Params {
  tags: string[]
  listener: (tag: string) => void

  constructor(tags: string[], listener: (tag: string) => void) {
    this.tags = tags;
    this.listener = listener;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text("Pin 消息")
      .fontSize(20)
      .fontColor(Color.Black)
      .width('80%')
      .textAlign(TextAlign.Start)
    List() {
      ForEach(params.tags, (item: string, index) => {
        ListItem() {
          Row() {
            Text(item).fontColor(18).fontColor(Color.Black)
          }.height(60).width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            params.listener(item)
          })
        }
      })
    }.width('80%')
  }.backgroundColor(Color.White)
  .padding(16)
  .borderRadius(6)
}