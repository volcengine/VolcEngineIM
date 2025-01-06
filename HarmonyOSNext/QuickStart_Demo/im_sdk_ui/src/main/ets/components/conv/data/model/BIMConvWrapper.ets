import { BIMUIClient } from '../../../../api/BIMUIClient';
import { intl } from '@kit.LocalizationKit';
import { BIMConversation, BIMConversationType, BIMMessageType } from '@imcloud/imsdk';
import { BIMUIUtils } from '../../../../utils/BIMUIUtils';

@Observed
export class BIMConvWrapper {
  conv: BIMConversation
  isCheck: boolean
  portraitUrl: string | Resource = $r('app.media.default_icon_group')
  time: string
  lastMsgHint: string = "";
  isShowUnread: boolean = false;
  lastMsgType: BIMMessageType;
  unReadStr: string = '0';
  conversationName: string = "未命名群聊";
  type: number;

  constructor(conv: BIMConversation, type: number) {
    this.conv = conv;
    this.type = type;
    this.isCheck = false;
    if (conv.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
      let oppositeUid = conv.getOppositeUserID(BIMUIClient.getInstance().uid)
      if (oppositeUid) {
        let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(oppositeUid)
        this.portraitUrl = user.portraitUrl
        this.conversationName = user.nickName
      }
    } else if (conv.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
      this.portraitUrl = $r('app.media.default_icon_group')

      let name = this.conv?.getName()
      if (name?.length) {
        this.conversationName = name
      } else {
        this.conversationName = "未命名群聊"
      }
    }

    let lastMsg = conv.getLastMessage()
    let time = lastMsg?.getCreatedTime() ?? 0
    let data = new Date()
    data.setTime(time)
    let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' });
    this.time = dateFormat.format(data)

    this.lastMsgType = conv.getLastMessage()?.getMsgType() ?? BIMMessageType.BIM_MESSAGE_TYPE_UNKNOWN
    let sendUid = conv.getLastMessage()?.getSendUid();
    let sendName: string = `${sendUid}`
    if (sendUid) {
      let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(sendUid)
      sendName = user.nickName
    }
    if (conv.getDraftText()) {
        this.lastMsgHint = `[草稿]${conv.getDraftText()}`
    } else {
      let mentionMsgList = conv.getUnreadMentionMessageList()
      if (mentionMsgList && mentionMsgList.length > 0) {
        //有人at你
        let atMsg = mentionMsgList[0]
        this.lastMsgHint = "[有人@你]"
        this.lastMsgHint += ` ${sendName}:${BIMUIUtils.generateHint(atMsg)}`
      } else if (lastMsg) {
        if (lastMsg.isRecalled()) {
          if (lastMsg.getSendUid() == BIMUIClient.getInstance().getCurrentUserID()) {
            this.lastMsgHint = `你 撤回了一条消息`
          } else {
            let recallUser = BIMUIClient.getInstance().getUserProvider().getUserInfo(lastMsg.getSendUid())
            this.lastMsgHint = `${recallUser.nickName} 撤回了一条消息`
          }
        } else {
          let hint = BIMUIUtils.generateHint(lastMsg)
          if (hint.indexOf("@所有人") >= 0 && BIMUIClient.getInstance().getCurrentUserID() != lastMsg.getSendUid()) {
            this.lastMsgHint = `[有人@你] ${sendName}:${hint}`
          } else {
            this.lastMsgHint = `${sendName}:${hint}`
          }
        }
      } else {
        this.lastMsgHint = ""
      }
    }

    let unReadCount = conv.getUnreadCount()
    this.isShowUnread = unReadCount > 0
    this.unReadStr = unReadCount > 99 ? "99+" : unReadCount.toString()
  }

  public static TYPE_CONV = 0;
  public static TYPE_STRANGE_BOX = 1;
}