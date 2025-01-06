import { BIMMessage } from '@imcloud/imsdk';
import { intl } from '@kit.LocalizationKit';
import { BIMUIUser } from '../../../../api/BIMUIUser';
import { BIMUIClient } from '../../../../api/BIMUIClient';
import { BIMMessageType } from '@imcloud/imsdk';
import { BIMMessageStatus } from '@imcloud/imsdk';
import { BIMConversationType, BIMCustomElement, BIMMessageReadStatusModel, MessageReadStatusModel } from '@imcloud/imsdk';
import { BaseCustomElement } from '../../custom/BaseCustomElement';
import { BIMUIUtils } from '../../../../utils/BIMUIUtils';

@Observed
export class BIMMessageWrapper {
  msg: BIMMessage | undefined
  timeStr: string = "1111"
  isShowTime: boolean = false
  user: BIMUIUser = new BIMUIUser()
  isSelf: boolean = false;
  elementType = ""
  commonInfo: MsgCommonInfo = new MsgCommonInfo()
  progress: number = 0
  baseCustomElement: BaseCustomElement | undefined
  likeText: string = ""
  isShowLike: boolean = false
  sendStatus: BIMMessageStatus = BIMMessageStatus.BIM_MESSAGE_STATUS_SENDING
  forceHiddenHead: boolean = false
  forceHiddenReadStatus: boolean = false
  uuid:string = ""
  constructor(bimMessage?: BIMMessage) {
    if (bimMessage) {
      this.msg = bimMessage
      this.uuid = bimMessage.getUuid()
      let data = new Date()
      const time = bimMessage.getCreatedTime()
      data.setTime(time)
      let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' });
      this.timeStr = dateFormat.format(data)
      this.user = BIMUIClient.getInstance().getUserProvider().getUserInfo(bimMessage.getSendUid())
      this.isSelf = BIMUIClient.getInstance().uid == bimMessage.getSendUid()
      if (bimMessage.getMsgType() != BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
        this.elementType = bimMessage.getMsgType().toString()
      } else {
        let bimCustom = this.msg?.content as BIMCustomElement
        if (bimMessage.isRecalled()) { //recall会删除content，导致自定义消息无法解析
          this.baseCustomElement = new BaseCustomElement();
          this.elementType = this.baseCustomElement.type
        } else {
          this.baseCustomElement = BIMUIClient.getInstance().parseCustomElement(bimCustom)
          this.elementType = this.baseCustomElement.type
        }
      }
      let config = BIMUIClient.getInstance().msgOptManager.getOptionConfigByMsg(this.msg)
      this.forceHiddenHead = config.isForceHeadHidden
      this.forceHiddenReadStatus = config.isForceHiddenReadStatus
      this.updateSendStatus(bimMessage)
      this.updateRecall(bimMessage)
      this.updateLike(bimMessage)
      this.updateRef(bimMessage)
    }
  }

  //部分刷新recall
  updateRecall(bimMessage: BIMMessage) {
    this.msg = bimMessage
    if (bimMessage.isRecalled()) {
      if (bimMessage.getSendUid() == BIMUIClient.getInstance().getCurrentUserID()) {
        this.commonInfo.recallStr = `你 撤回了一条消息`
      } else {
        let recallUser = BIMUIClient.getInstance().getUserProvider().getUserInfo(bimMessage.getSendUid())
        this.commonInfo.recallStr = `${recallUser.nickName} 撤回了一条消息`
      }
      this.commonInfo.isRecall = true
    } else {
      this.commonInfo.recallStr = ""
      this.commonInfo.isRecall = false
    }
  }

  updateReadStatus(bimMessage: BIMMessage, status: BIMMessageReadStatusModel) {
    if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
      if (status.readUidList.length >= 1) {
        this.commonInfo.isReadStr = `已读`
      } else {
        this.commonInfo.isReadStr = `未读`
      }
    } else {
      this.commonInfo.isReadStr = `[${status.readUidList.length}/${status.allUidList.length}]`
    }
  }

  //部分刷新发送状态
  updateSendStatus(bimMessage: BIMMessage) {
    this.msg = bimMessage
    this.commonInfo.sendStatus = bimMessage.getMsgStatus()
    this.sendStatus = bimMessage.getMsgStatus()
    this.commonInfo.isShowRead = this.isSelf && this.sendStatus != BIMMessageStatus.BIM_MESSAGE_STATUS_FAILED && !this.forceHiddenReadStatus
  }

  updateProgress(bimMessage: BIMMessage, progress: number) {
    this.msg = bimMessage
    this.progress = progress
  }

  updateLike(bimMessage: BIMMessage) {
    this.likeText = ""
    let map = bimMessage.getProperties()
    map?.forEach((proList, emoji) => {
      let curEmojiText = `${emoji}:`
      proList.forEach((property) => {
        let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(property.getUid())
        curEmojiText += `${user.nickName},`
      })
      this.likeText += curEmojiText
    })
    if (this.likeText.length > 0) {
      this.likeText = this.likeText.substring(0, this.likeText.length - 1) //去掉最后一个逗号
      this.isShowLike = true
    } else {
      this.isShowLike = false
    }
  }

  updateRef(bimMessage: BIMMessage) {
    let ref = bimMessage.getReferenceInfo()
    if (ref) {
      this.commonInfo.isShowRef = true
      let msg = ref.getRefMessage()
      if (ref.isRecall()) {
        this.commonInfo.refText = "已撤回"
      } else if (ref.isDelete()) {
        this.commonInfo.refText = "已删除"
      } else {
        this.commonInfo.refText = BIMUIUtils.generateRefHint(ref.getHint(), msg)
      }
      if (this.commonInfo.refText == "[未知消息]" && ref.getHint()) {
        this.commonInfo.refText = ref.getHint() + "(兜底)"
      }
    } else {
      this.commonInfo.isShowRef = false
    }
  }
}


@Observed
export class MsgCommonInfo {
  isRecall: boolean = false
  recallStr: string = ""
  sendStatus: BIMMessageStatus = BIMMessageStatus.BIM_MESSAGE_STATUS_SENDING
  isShowRead: boolean = false
  isReadStr: string = ""
  refText:string = ""
  isShowRef:boolean = false
}