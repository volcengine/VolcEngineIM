import { BIMMessage, BIMMessageStatus } from '@imcloud/imsdk'
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
  isForceHeadHidden:boolean = false //不展示头像
  isForceHiddenReadStatus:boolean = false//不展示已读未读


  /**
   * 配置功能
   */
  onInit(bimMessage:BIMMessage) {
    let isSelf = bimMessage?.getSendUid() == BIMUIClient.getInstance().getCurrentUserID()
    this.isEnableRecall = isSelf
    this.isEnableDelete = isSelf
    this.isEnableEdit = false
    this.isForceHeadHidden = false
    this.isForceHiddenReadStatus = false
    this.isEnablePoP = bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL
  }


  getCopyText(bimMessage: BIMMessage): string {
    return ""
  }
}