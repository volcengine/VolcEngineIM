import { BIMConversationType, BIMMessage, BIMMessageStatus } from '@imcloud/imsdk'
import { BIMUIClient } from '../../../../../api/BIMUIClient'

export abstract class OptionConfig {
  isEnablePoP:boolean = true //总开关
  isEnableOption: boolean = true
  isEnableLike: boolean = true
  isEnableCopy: boolean = true
  isEnableDelete: boolean = true
  isEnableRecall: boolean = true
  isEnableRef: boolean = true
  isEnableEdit: boolean = true
  isEnablePin: boolean = true
  isEnableTop: boolean = true
  isEnableFav: boolean = true
  isEnablePriority: boolean = true
  isForceHeadHidden:boolean = false //不展示头像
  isForceHiddenReadStatus:boolean = false//优先级


  /**
   * 配置功能
   */
  onInit(bimMessage:BIMMessage) {
    this.isEnablePoP =!bimMessage.isRecalled() && (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL)
    let isSelf = bimMessage?.getSenderUID() == BIMUIClient.getInstance().getCurrentUserID()
    if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
      this.isEnableLike = false
      this.isEnableCopy = true
      this.isEnableDelete = false
      this.isEnableRecall = false
      this.isEnableRef = false
      this.isEnableEdit = false
      this.isEnablePin = false
      this.isEnableTop = false
      this.isEnableFav = false
      this.isEnablePriority = true
    } else {
      this.isEnableRef = true
      this.isEnableRecall = isSelf
      this.isEnableDelete = true
      this.isEnableEdit = false
      this.isForceHeadHidden = false
      this.isForceHiddenReadStatus = false
      this.isEnablePriority = false
    }
  }


  getCopyText(bimMessage: BIMMessage): string {
    return ""
  }
}