import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper'
import { BIMConversationType, BIMTextElement } from '@imcloud/imsdk'
import { EmojiHelper } from '../../widget/input/viewModel/EmojiHelper'
import { OptionConfig } from '../../widget/input/msgpop/opt/OptionConfig'
import { BIMMessage } from '@imcloud/imsdk'
import { BIMUIClient } from '../../../api/BIMUIClient'
import { BIMUIUtils } from '../../../utils/BIMUIUtils'
import { Prompt, promptAction } from '@kit.ArkUI'


@Builder
export function buildTextMessageUI(wrapper: BIMMessageWrapper) {
  TextMessageUI({ msgWrapper: wrapper })
}

@Component
export struct TextMessageUI {
  msgWrapper: BIMMessageWrapper = new BIMMessageWrapper()
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  @State widthRich: number = 0
  @Consume itemMsgWidth: number
  isShowRef: boolean = true
  refText: string = "引用"
  textContent: string = ""

  aboutToAppear(): void {
    this.textContent = (this.msgWrapper.msg?.getElement() as BIMTextElement).text
    if (!this.textContent) {
      this.textContent = "[暂不支持]"
    }
    let editInfo = this.msgWrapper.msg?.getEditInfo()
    if (editInfo && editInfo.isEdit()) {
      this.textContent += "(已编辑)"
    }


    let measuredWidth = EmojiHelper.instance.measureTextWidth(this.textContent) + 32
    if (measuredWidth >= this.itemMsgWidth) {
      this.widthRich = this.itemMsgWidth
    } else {
      this.widthRich = measuredWidth
    }
  }

  build() {
    Column() {
      Row() {
        RichEditor(this.options)
          .border({ radius: 6 })
          .padding({
            left: 16,
            right: 16,
            top: 8,
            bottom: 8
          })
          .width(this.widthRich)
          .onTouchIntercept(() => {
            return HitTestMode.None //不相应触
          })
          .backgroundColor(this.msgWrapper?.isSelf ? '#5692ff' : '#f1f1f1')
          .onReady(() => {
            EmojiHelper.instance.setTextWithEmoji(this.controller, this.textContent, this.msgWrapper?.isSelf ? '#ffffff' : '#222222') + 32
          })
      }.onClick(() => {
        let uids = this.msgWrapper.msg?.getMentionUIDList()
        if (uids && uids.length > 0) {
          let uidStr = uids?.reduce((pre, cur) => {
            return `${pre},${cur}`
          }, "")
          promptAction.showToast({ message: `提醒的用户:${uidStr?.substring(1)}` })
        }
      })
    }.alignItems(this.msgWrapper.isSelf ? HorizontalAlign.End : HorizontalAlign.Start)
  }
}

export class TextOptionConfig extends OptionConfig {
  onInit(bimMessage: BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableEdit = bimMessage?.getSenderUID() == BIMUIClient.getInstance().getCurrentUserID() && bimMessage.getConversationType() != BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT
  }

  getCopyText(bimMessage: BIMMessage): string {
    let textElement = bimMessage?.getElement() as BIMTextElement
    return textElement.text
  }
}

