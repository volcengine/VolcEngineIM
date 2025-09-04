import { BIMConversation, BIMConversationType, BIMErrorCode, BIMMessage, BIMMessagePriority, BIMTextElement } from '@imcloud/imsdk'
import { OnEmojiClickListener } from '../VEEmojiPanel'
import { EmojiHelper, EmojiInfo } from './EmojiHelper'
import { BIMUIUtils } from '../../../../utils/BIMUIUtils'
import { BIMUIClient } from '../../../../api/BIMUIClient'
import { promptAction } from '@kit.ArkUI'

export class VEInputViewModel implements OnEmojiClickListener {
  private tag = "VEInputViewModel"
  private MAX_LENGTH = 500;
  editText: string = ""
  isShowEdit: Visibility = Visibility.Visible
  isShowAudio: Visibility = Visibility.None
  isShowMore: Visibility = Visibility.Visible
  isShowSend: Visibility = Visibility.None
  isShowEmojiPanel: Visibility = Visibility.None
  isShowToolPanel: Visibility = Visibility.None
  isShowPanel: Visibility = Visibility.None
  isShowKeyBoard: boolean = false
  controller: RichEditorController
  isShowTopHint: boolean = false
  topHint: string = ""
  isShowRefHint: boolean = false
  refMsg: BIMMessage | undefined
  editMsg: BIMMessage | undefined
  mentionIds: string[] = []
  conversationId: string = ""
  priorityTitle: string = "普通"
  priority: BIMMessagePriority = BIMMessagePriority.NORMAL
  isShowPriority:boolean = false
  private _onSendListener: OnSendTextListener | undefined = undefined
  private _onPriorityListener: OnPriorityListener | undefined = undefined

  public set onPriorityListener(value: OnPriorityListener | undefined) {
    this._onPriorityListener = value
  }
  readonly inputTextColor = "FF000000"
  readonly inputTextSize = 16

  public set onSendListener(value: OnSendTextListener | undefined) {
    this._onSendListener = value
  }


  constructor(controller: RichEditorController) {
    this.controller = controller
  }

  onEmojiClick(info: EmojiInfo): void {
    this.controller.addImageSpan(info.res,
      {
        imageStyle:
        {
          size: [this.inputTextSize, this.inputTextSize],
          objectFit: ImageFit.ScaleDown
        }
      })
    this.updateSendBtn()
  }

  onEmojiDeleteClick(): void {
    let spanList = this.controller.getSpans()
    if (spanList.length > 0) {
      let lastSpan = spanList[spanList.length-1]
      let range = lastSpan.spanPosition.spanRange
      this.controller.deleteSpans({ start: range[0], end: range[1] })
      if (typeof (lastSpan as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
        let textSpan = lastSpan as RichEditorTextSpanResult
        let oldStr: string = textSpan.value
        let nStr = oldStr.substring(0, oldStr.length - 1)
        this.controller.addTextSpan(nStr)
      }
    }
  }

  onSendClick() {
    let text = this.getText();
    if (text.length > this.MAX_LENGTH) {
      promptAction.showToast({ message: `文本过长,超过 ${this.MAX_LENGTH} 字符,发送失败` })
      return
    }
    if (this.editMsg != null) { //编辑消息
      this._onSendListener?.onSendEditText(text, this.editMsg, this.mentionIds)
    } else { //发送文本消息
      this._onSendListener?.onSendText(text, this.refMsg, this.mentionIds)
    }
    this.controller.deleteSpans()
    this.updateSendBtn()
    this.clearTopHint()
    this.mentionIds = []
  }

  getText(): string {
    let text = ""
    let spans = this.controller.getSpans()
    spans?.forEach((item) => {
      if (typeof (item as RichEditorImageSpanResult)['imageStyle'] != 'undefined') {
        let imageSpan = item as RichEditorImageSpanResult
        text += EmojiHelper.getInstance().getEmojiText(imageSpan.valueResourceStr as string)
      } else {
        let textSpan = item as RichEditorTextSpanResult
        text += textSpan.value
      }
    })
    return text
  }


  updateSendBtn() {
    if (this.getText().length == 0) {
      this.isShowSend = Visibility.None
      this.isShowMore = Visibility.Visible
    } else {
      this.isShowSend = Visibility.Visible
      this.isShowMore = Visibility.None
    }
  }


  genRefHint(bimMessage: BIMMessage): string {
    this.refMsg = bimMessage
    return `引用:${BIMUIUtils.generateRefHint("", bimMessage)}`
  }

  genEditHint(bimMessage: BIMMessage): string {
    this.editMsg = bimMessage
    let oldElement = bimMessage.getElement() as BIMTextElement
    return `旧内容:${oldElement.text}`
  }

  clearTopHint() {
    this.refMsg = undefined
    this.editMsg = undefined
  }

  addMentionId(id: string) {
    this.mentionIds.push(id)
    let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(id)
    this.controller.addTextSpan(user.nickName)
  }

  addMentionAll() {
    this.controller.addTextSpan("所有人")
    this.mentionIds.push("0")
  }

  async saveDraft() {
    let result = await BIMUIClient.getInstance().getConversation(this.conversationId)
    if (result.code != BIMErrorCode.BIM_OK || !result.data?.isMember()) {
      return
    }

    BIMUIClient.getInstance().setConversationDraft(this.getText(), this.conversationId)
  }

  async initDraft() {
    let result = await BIMUIClient.getInstance().getConversation(this.conversationId)
    if (result.code == BIMErrorCode.BIM_OK) {
      let conv = result.data
      if (conv) {
        EmojiHelper.instance.setTextWithEmoji(this.controller, conv.getDraftText(), this.inputTextColor, this.inputTextSize)
        this.updateSendBtn()
      }
    }
  }

  updatePriority(priority:BIMMessagePriority){
    this.priority = priority
    switch (priority) {
      case BIMMessagePriority.LOW:
        this.priorityTitle = "低"
        break
      case BIMMessagePriority.NORMAL:
        this.priorityTitle = "普通"
        break
      case BIMMessagePriority.HIGH:
        this.priorityTitle = "高"
        break
    }
    this._onPriorityListener?.onPriorityChanged(this.priority)
  }
}


export interface OnSendTextListener {
  onSendText(text: string, bimMsg: BIMMessage | undefined, mentionIds: string[]): void

  onSendEditText(text: string, oldMsg: BIMMessage, mentionIds: string[]): void
}

export interface OnPriorityListener {
  onPriorityChanged(priority: BIMMessagePriority): void
}