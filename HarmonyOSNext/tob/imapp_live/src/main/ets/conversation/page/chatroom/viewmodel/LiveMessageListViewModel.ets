import { BIMBlockStatus, BIMConversation, BIMErrorCode, BIMLiveConversationListener, BIMLiveGroupMemberEventListener, BIMLiveMessageListener, BIMMember, BIMMessage, BIMMessagePriority, BIMSendCallback, MemberUpdateInfo } from '@imcloud/imsdk';
import { BIMUIClient } from '@imcloud/im_sdk_ui';
import { ShareElement } from '@imcloud/im_sdk_ui/src/main/ets/components/msg/custom/ShareElement';
import { AbstractMsgListViewModel } from '@imcloud/im_sdk_ui/src/main/ets/components/msg/data/AbstractMsgListViewModel';
import { BIMMessageWrapper } from '@imcloud/im_sdk_ui/src/main/ets/components/msg/data/model/BIMMessageWrapper';
import { CustomToolBtn } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/tools/CustomToolBtn';
import { FileToolBtn } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/tools/FileToolBtn';
import { ImageToolBtn } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/tools/ImageToolBtn';
import { PhotoToolBtn } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/tools/PhotoToolBtn';
import { VideoToolBtn } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/tools/VideoToolBtn';
import { EmojiInfo } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/viewModel/EmojiHelper';
import { VEBaseTool } from '@imcloud/im_sdk_ui/src/main/ets/components/widget/input/viewModel/VEToolsViewModel';
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog';
import { promptAction } from '@kit.ArkUI';
import { LiveUserProvider } from './LiveUserProvider';
import { fileUri } from '@kit.CoreFileKit';
import { IMPage, IMRouter } from '@imcloud/imapp_router';

@ObservedV2
class ChatRoomState{
  @Trace convName:string=''
}
@Observed
export class LiveMessageListViewModel extends AbstractMsgListViewModel {
  uiState = new ChatRoomState()
  private hasMore: boolean = true;
  private cursor: number = 0;
  private isLoading = false;
  private limit = 20
  private conversation: BIMConversation | undefined
  private tag = "LiveMsgModel"
  private readonly EXT_ALIAS_NAME = "a:live_group_member_alias_name";
  private readonly EXT_AVATAR_URL = "a:live_group_member_avatar_url";
  private liveUserProvider = new LiveUserProvider()
  private priority:BIMMessagePriority = BIMMessagePriority.NORMAL
  constructor(cid: string) {
    super(cid)
  }

  public async refreshTitle() {
    if (this.cid) {
      let r = await BIMUIClient.getInstance().getLiveService()?.getLiveGroup(this.cid)
      if (r?.code == BIMErrorCode.BIM_OK) {
        if (r.data) {
          this.updateConversation(r.data)
        }
      } else {
        this.uiState.convName = this.cid
      }
    }
  }
  isShowInputPriority(): boolean {
    return true
  }
  onPriorityChanged(priority: BIMMessagePriority): void {
    BIMUILog.debug(this.tag, `onPriorityChanged() priority: ${priority} `)

    this.priority = priority
  }

  private updateConversation(conversation: BIMConversation) {
    this.conversation = conversation
    this.uiState.convName = this.conversation?.getName() ?? this.cid
    let curMember = conversation.getCurrentMember()
    if(curMember){
      this.cacheMemberInfoByMemberList([curMember])
    }
  }

  public async joinGroup(memUpdateInfo: MemberUpdateInfo) {
    BIMUILog.debug(this.tag, `joinGroup() name: ${memUpdateInfo.getAlias()} url:${memUpdateInfo.getAvatarUrl()}`)
    let r = await BIMUIClient.getInstance().getLiveService()?.joinLiveGroupWithInfo(this.cid, memUpdateInfo)
    if (r?.code == BIMErrorCode.BIM_OK) {
      let result = r.data
      if (result) {
        this.cursor = result.getJoinMessageCursor()
        let conv = result.getConversation()
        if (conv) {
          this.updateConversation(conv)
        }
        BIMUILog.debug(this.tag, `joinGroup() success cid:${this.cid} cursor:${this.cursor}`)
        this.loadMore()
      }
    } else {
      BIMUILog.debug(this.tag, `joinGroup() failed！${r?.code}`)
      promptAction.showToast({ message: `加入直播群失败 ${r?.code}` })
      IMRouter.pop()
    }
  }

  public async leaveGroup() {
    let r = await BIMUIClient.getInstance().getLiveService()?.leaveLiveGroup(this.cid)
    // if (r?.code == BIMErrorCode.BIM_OK) {
    //   promptAction.showToast({ message: "退出直播群成功" })
    // } else {
    //   promptAction.showToast({ message: `退出直播群失败 ${r?.code}` })
    // }
  }

  override async loadMore() {
    if (this.isLoading) {
      return
    }
    BIMUILog.debug(this.tag, `load more start cid: ${this.cid} hasMore: ${this.hasMore} cursor:${this.cursor}}`)
    this.isLoading = true
    if (this.hasMore) {
      let r = await BIMUIClient.getInstance().getLiveService()?.getLiveGroupHistoryMessageList(this.cid, this.cursor, this.limit)
      if (r?.code == BIMErrorCode.BIM_OK) {
        let msgListResult = r.data
        this.hasMore = msgListResult.isHasMore()
        this.cursor = msgListResult.getNextCursor()
        let msgList = msgListResult.getMessageList()
        let wrapList = msgList.map((msg) => new BIMMessageWrapper(msg, this.liveUserProvider))
        this.data.addLiveMsgOlderData(wrapList)
        BIMUILog.debug(this.tag, `load more success result: hasmore: ${this.hasMore} cursor:${this.cursor} size:${msgList.length}`)
      } else {
        promptAction.showToast({ message: "加载更多失败" })
      }
      BIMUILog.debug(this.tag, "load page end: " + this.cursor)
    } else {
      BIMUILog.debug(this.tag, "load more All end: " + this.cursor)
      promptAction.showToast({ message: "没有更多了" })
    }
    this.isLoading = false
  }


  private async sendImageMessage(uri: string) {
    let imageMessage = await BIMUIClient.getInstance().createImageMessage(uri)
    this.sendMessage(imageMessage)
  }

  private async sendVideoMessage(uri: string) {
    let videoMessage = await BIMUIClient.getInstance().createVideoMessage(uri)
    this.sendMessage(videoMessage)
  }

  private async  sendFileMessage(uri: string) {
    let fileMessage = await BIMUIClient.getInstance().createFileMessage(uri)
    this.sendMessage(fileMessage)
  }

  private sendCustomMessage() {
    let shareElement = new ShareElement("https://www.volcengine.com/", "欢迎体验火山引擎即时通信IM Demo")
    let msg = BIMUIClient.getInstance().createCustomMessageWithElement(shareElement)
    this.sendMessage(msg)
  }

  override onSendText(text: string, bimMsg: BIMMessage | undefined, mentionIds: string[]): void {
    let textMessage = BIMUIClient.getInstance().createTextMessage(text)
    this.sendMessage(textMessage)
  }

  override onSendEditText(text: string, oldMsg: BIMMessage, mentionIds: string[]): void {

  }

  override async onRecordAudioComplete(path: string) {
    let uri = fileUri.getUriFromPath(path)
    let audioMsg = await BIMUIClient.getInstance().createAudioMessage(uri)
    this.sendMessage(audioMsg)
  }

  override onRecordAudioCancel(): void {

  }

  override addListener(): void {
    BIMUILog.debug(this.tag, "addListener")
    BIMUIClient.getInstance().getLiveService()?.addLiveGroupMessageListener(this.msgListener)
    BIMUIClient.getInstance().getLiveService()?.addLiveConversationListener(this.convListener)
    BIMUIClient.getInstance().getLiveService()?.addLiveGroupMemberListener(this.memberListener)
  }

  override removeListener(): void {
    BIMUILog.debug(this.tag, "removeListener")
    BIMUIClient.getInstance().getLiveService()?.removeLiveGroupMessageListener(this.msgListener)
    BIMUIClient.getInstance().getLiveService()?.removeLiveConversationListener(this.convListener)
    BIMUIClient.getInstance().getLiveService()?.removeLiveGroupMemberListener(this.memberListener)
  }

  override markConversationRead(): void {
  }

  override startReadRefresh(): void {

  }

  override stopReadRefresh(): void {

  }


  override onReSendMessage(msg: BIMMessage): void {
    if (this.conversation) {
      BIMUIClient.getInstance().getLiveService()?.sendLiveGroupMessage(msg, this.conversation, this.priority, this.sendCallback)
    }
  }

  override onReadListClick(msg: BIMMessage): void {

  }

  override onLikeEmojiClick(msg: BIMMessage, emoji: EmojiInfo): void {

  }

  private sendMessage(msg: BIMMessage|undefined) {
    if (this.conversation && msg) {
      let myUserInfo = this.conversation.getCurrentMember()
      let myName = myUserInfo?.getAlias()
      let myUrl = myUserInfo?.getAvatarUrl()
      if (myName) {
        msg.getExtra().set(this.EXT_ALIAS_NAME, myName)
      }
      if (myUrl) {
        msg.getExtra().set(this.EXT_AVATAR_URL, myUrl)
      }
      BIMUIClient.getInstance().getLiveService()?.sendLiveGroupMessage(msg, this.conversation, this.priority, this.sendCallback)
    }
  }

  initToolBtn(tools: VEBaseTool[]): void {
    tools.push(new ImageToolBtn((isSuccess, uris) => {
      if (isSuccess && uris.length > 0) {
        uris.forEach((uri) => {
          this.sendImageMessage(uri)
        })
      }
    }))
    this.tools.push(new VideoToolBtn((isSuccess, uris) => {
      if (isSuccess && uris.length > 0) {
        uris.forEach((uri) => {
          this.sendVideoMessage(uri)
        })
      }
    }))
    this.tools.push(new PhotoToolBtn((isSuccess, uri) => {
      if (isSuccess) {
        this.sendImageMessage(uri)
      }
    }))
    this.tools.push(new FileToolBtn((isSuccess, uri) => {
      if (isSuccess) {
        this.sendFileMessage(uri)
      }
    }))
    this.tools.push(new CustomToolBtn(() => {
      this.sendCustomMessage()
    }))
  }

  private msgListener: BIMLiveMessageListener = {
    onReceiveMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this.tag, `msgListener onReceiveMessage uuid ${message.getUuid()} status: ${message.getMsgStatus()}`)
      this.cacheMemberInfoByMessage(message)
      let isSelf = message.getSenderUID() == BIMUIClient.getInstance().getCurrentUserID()
      this.data.appendLiveMsgOrUpdate(this.genMessageWrapper(message), !isSelf)
    },
    onSendMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this.tag, `msgListener onSendMessage uuid ${message.getUuid()} status: ${message.getMsgStatus()}`)
    },
    onDeleteMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this.tag, `msgListener onDeleteMessage uuid ${message.getUuid()} status: ${message.getMsgStatus()}`)
      this.data.deleteMessage(message)
    },
    onUpdateMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this.tag, `msgListener onUpdateMessage uuid ${message.getUuid()} status: ${message.getMsgStatus()}`)
      this.data.updateSendStatus(message)
    }
  }
  // 注意：这里是在构造期间生成的，this指针不是修饰过的
  private convListener: BIMLiveConversationListener = {
    onConversationChanged: (conversation: BIMConversation): void => {
      BIMUILog.debug(this.tag, `convListener onConversationChanged cid: ${conversation.getConversationId()} onlinCount: ${conversation.getOnLineMemberCount()}`)
      if (this.conversation?.getConversationId() == conversation.getConversationId()) {
        this.updateConversation(conversation)
      }
    }
  }

  private memberListener: BIMLiveGroupMemberEventListener = {
    onMemberJoined: (conversation: BIMConversation, memberList: BIMMember[]): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberJoined ${this.genUidListStr(memberList)}`)
      this.cacheMemberInfoByMemberList(memberList)
    },
    onMemberLeave: (conversation: BIMConversation, memberList: BIMMember[]): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberLeave ${this.genUidListStr(memberList)}`)
    },

    onMemberKicked: (conversation: BIMConversation, memberList: BIMMember[], operatorID: string): void => {
      if (conversation.getConversationId() != this.conversation?.getConversationId()) {
        return
      }
      for (let element of memberList) {
        if (element.getUserID() == this.conversation.getCurrentMember()?.getUserID()) {
          IMRouter.popToName(IMPage.TOB_MAIN)
          return
        }
      }
    },
    onMemberOwnerChanged: (conversation: BIMConversation, fromUID: string, toUID: string): void => {
    },
    onMemberSilent: (conversation: BIMConversation, memberSilentList: BIMMember[], status: BIMBlockStatus, operatorId: string): void => {
    },
    onAllMemberSilent: (conversation: BIMConversation, status: BIMBlockStatus, operatorId: string): void => {
    },
    onAddAdmin: (conversation: BIMConversation, adminList: BIMMember[], operatorId: string): void => {
    },
    onRemoveAdmin: (conversation: BIMConversation, uidList: BIMMember[], operatorId: string): void => {
    },
    onMemberInfoChanged: (conversation: BIMConversation, member: BIMMember): void => {
    },
    onBatchMemberInfoChanged: (conversation: BIMConversation, members: BIMMember[]): void => {
    }
  }

  genUidListStr(memberList: BIMMember[]): string {
    return memberList.map((m) => m.getUserID()).toString()
  }

  genMessageWrapper(msg: BIMMessage) {
    return new BIMMessageWrapper(msg, this.liveUserProvider)
  }

  cacheMemberInfoByMemberList(memberList: BIMMember[]) {
    for (let m of memberList) {
      this.insertOrUpdateUserInfo(m.getUserID(), m.getAlias(), m.getAvatarUrl())
    }
  }
  cacheMemberInfoByMessage(bimMessage: BIMMessage){
    let memberName = bimMessage.getExtra().get(this.EXT_ALIAS_NAME) ?? ""
    let memberUrl = bimMessage.getExtra().get(this.EXT_AVATAR_URL) ?? ""
    this.insertOrUpdateUserInfo(bimMessage.getSenderUID(), memberName, memberUrl)
  }

  insertOrUpdateUserInfo(uid: string, memberName: string, memberUrl: string) {
    let needUpdateUserUI = this.liveUserProvider.addCache(uid, memberName, memberUrl)
    BIMUILog.debug(this.tag, `addUserCache uid:${uid} needUpdateUserUI:${needUpdateUserUI}`)
    if (needUpdateUserUI) {
      let updateList = this.data.getMsgListBySenderUID(uid)
      for (let w of updateList) {
        w.updateHead() //头像刷新
      }
    }
  }

  private sendCallback: BIMSendCallback = {
    onProgress: (message: BIMMessage, progress: number) => {
      BIMUILog.debug(this.tag, `sendMessage() onProgress uuid :${message.getUuid()} status:${message.getMsgStatus()} progress:${progress}`)
      this.data.updateProgress(message, progress)
    },
    onSaved: (message: BIMMessage) => {
      BIMUILog.debug(this.tag, `sendMessage() onSaved uuid :${message.getUuid()} status:${message.getMsgStatus()}`)
      this.data.appendLiveMsgOrUpdate(this.genMessageWrapper(message), true)
      this.data.updateSendStatus(message)
      this.listScroller.scrollEdge(Edge.Top)
    },
    onSuccess: (message: BIMMessage) => {
      BIMUILog.debug(this.tag, `sendMessage() onSuccess uuid :${message.getUuid()} status:${message.getMsgStatus()} indexInConversation:${message.innerMessage.indexInConversationV2}`)
      this.data.updateSendStatus(message)
    },
    onError: (message: BIMMessage, code: BIMErrorCode) => {
      BIMUILog.debug(this.tag, `sendMessage() onError code:${code} uuid :${message.getUuid()} status:${message.getMsgStatus()} content:${message.innerMessage.content} status:${message.getMsgStatus()} `)
      if (code == BIMErrorCode.BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
        promptAction.showToast({ message: "消息发送失败: 文件大小超过限制" })
        return
      }
      promptAction.showToast({ message: "消息发送失败：" + code })
      this.data.updateSendStatus(message)
      this.listScroller.scrollEdge(Edge.Top)
    }
  }
}