import { IMPage, IMRouter } from "@imcloud/imapp_router";
import {
  BIMBlockStatus,
  BIMConversation, BIMErrorCode,
  BIMLiveConversationListener,
  BIMLiveGroupMemberEventListener,
  BIMMember,
  BIMMemberRole } from "@imcloud/imsdk";
import { BIMUIClient } from "@imcloud/im_sdk_ui";
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog";
import { promptAction } from "@kit.ArkUI";
import { VELiveUserHorizonSource } from "./components/hor/VELiveUserHorizonSource";
import { VELiveUserWrapper } from "./VELiveUserWrapper";

@ObservedV2
export class LiveSettingState {
  @Trace onlineMemberCount: number = 0
  @Trace convName: string = '未命名群聊'
  @Trace convIntroduction: string = "未设置简介"
  @Trace convNotice: string = '未设置公告'
  @Trace myAvatarURL: string = ''
  @Trace myAlias: string = ''
  userList: VELiveUserHorizonSource = new VELiveUserHorizonSource()
  @Trace isConversationSilent: boolean = false
  @Trace isAdminOrOwner: boolean = false
  @Trace isOwner: boolean = false
}

export class VELiveGroupDetailConversationViewModel {
  tag: string = 'LiveGroupDetailConversation'
  uiState: LiveSettingState = new LiveSettingState()
  private conversation: BIMConversation | undefined
  private cid: string

  constructor(cid: string) {
    this.cid = cid
  }

  aboutToAppear(): void {
    if (this.cid.length > 0) {
      this.requestConversation(this.cid)
      this.requestOnlineMembers()
    }
    this.addListener()
  }

  aboutToDisappear(): void {
    this.removeListener()
  }

  async requestOnlineMembers() {
    let liveService = BIMUIClient.getInstance().getLiveService();
    if (!liveService) {
      return
    }
    this.uiState.userList.clear()
    let result = await liveService.getLiveGroupMemberOnlineList(this.cid, 0, 5);
    let memberList = result.data.getMemberList()
    if (memberList) {
      let list = memberList.map((member) => new VELiveUserWrapper(BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID()), member, false, false))
      this.uiState.userList.reload(list)
    }
  }

  async requestConversation(cid: string) {
    let liveService = BIMUIClient.getInstance().getLiveService();
    if (!liveService) {
      return
    }
    let result = await liveService.getLiveGroup(cid)
    if (result.data) {
      this.updateConversation(result.data)
    }
  }

  updateConversation(conversation: BIMConversation) {
    this.conversation = conversation
    this.uiState.onlineMemberCount = conversation.getOnLineMemberCount()
    this.uiState.convName = conversation?.getName()?.length ? conversation.getName() as string : "未命名群聊"
    this.uiState.convIntroduction = conversation?.getIntroduction()?.length ? conversation.getIntroduction() as string : "未设置简介"
    this.uiState.convNotice = conversation?.getNotice()?.length ? conversation.getNotice() as string : "未设置公告"
    this.uiState.isConversationSilent = (conversation?.getBlockStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK)
    this.uiState.myAlias = conversation?.getCurrentMember()?.getAlias() ?? ''
    this.uiState.isAdminOrOwner = this.isAdminOrOwner()
    this.uiState.isOwner = this.isOwner()
  }

  isOwner(): boolean {
    return this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER
  }

  isAdminOrOwner(): boolean {
    let role = this.conversation?.getCurrentMember()?.getRole()
    return role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN
  }

  addListener(): void {
    BIMUIClient.getInstance().getLiveService()?.addLiveConversationListener(this.convListener)
    BIMUIClient.getInstance().getLiveService()?.addLiveGroupMemberListener(this.memberListener)
  }

  removeListener(): void {
    BIMUIClient.getInstance().getLiveService()?.removeLiveConversationListener(this.convListener)
    BIMUIClient.getInstance().getLiveService()?.removeLiveGroupMemberListener(this.memberListener)
  }


  private convListener: BIMLiveConversationListener = {
    onConversationChanged: (conversation: BIMConversation): void => {
      if (conversation.getConversationId() == this.cid) {
        this.updateConversation(conversation)
        return
      }
    }
  }

  private memberListener: BIMLiveGroupMemberEventListener = {
    onMemberJoined: (conversation: BIMConversation, memberList: BIMMember[]): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberJoined ${memberList}`)
      this.requestOnlineMembers()
    },
    onMemberLeave: (conversation: BIMConversation, memberList: BIMMember[]): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberLeave ${memberList}`)
      this.requestOnlineMembers()
    },
    onMemberKicked: (conversation: BIMConversation, memberList: BIMMember[], operatorID: string): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberKicked ${memberList} operatorID:${operatorID}`)
      this.requestOnlineMembers()
    },
    onMemberOwnerChanged: (conversation: BIMConversation, fromUID: string, toUID: string): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberOwnerChanged fromUID:${fromUID} toUID:${toUID}`)
    },
    onMemberSilent: (conversation: BIMConversation, memberSilentList: BIMMember[], status: BIMBlockStatus, operatorId: string): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberSilent status:${status} operatorId:${operatorId}`)
    },
    onAllMemberSilent: (conversation: BIMConversation, status: BIMBlockStatus, operatorId: string): void => {
      BIMUILog.debug(this.tag, `memberListener onAllMemberSilent status:${status} operatorId:${operatorId}`)
    },
    onAddAdmin: (conversation: BIMConversation, adminList: BIMMember[], operatorId: string): void => {
      BIMUILog.debug(this.tag, `memberListener , operatorId:${operatorId}`)
    },
    onRemoveAdmin: (conversation: BIMConversation, uidList: BIMMember[], operatorId: string): void => {
      BIMUILog.debug(this.tag, `memberListener onRemoveAdmin operatorId:${operatorId}`)
    },
    onMemberInfoChanged: (conversation: BIMConversation, member: BIMMember): void => {
      BIMUILog.debug(this.tag, `memberListener onMemberInfoChanged`)
      this.requestOnlineMembers()
    },
    onBatchMemberInfoChanged: (conversation: BIMConversation, members: BIMMember[]): void => {
      BIMUILog.debug(this.tag, `memberListener onBatchMemberInfoChanged`)
      this.requestOnlineMembers()
    }
  }

  /*************** 跳转 *****************/

  onUserHorizonListViewClick() {
    this.jumpToOnlineListPage(false)
  }

  onUserHorizonListViewRemoveClick() {
    this.jumpToOnlineListPage(true)
  }
  
  jumpToOnlineQuery() {
    let map = new Map<string, string>()
    map["cid"] = this.cid;
    IMRouter.push(IMPage.LIVE_MEMBER_ONLINE_QUERY, map)

  }

  // 修改群名称
  jumpToEditGroupName() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getName() ?? '')
    arg.set('limit', 10)
    if (this.isAdminOrOwner()) {
      arg.set("title", '编辑群名称')
      arg.set("editable", true)
    } else {
      arg.set("title", '群名称')
      arg.set("editable", false)
    }

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }
        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupName(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
            promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
          } else {
            promptAction.showToast({ message: '更改群聊名称失败:' + result.code })
          }
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 修改群头像
  jumpToEditGroupIcon() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getPortraitURL() ?? '')
    arg.set('limit', 1000)
    if (this.isAdminOrOwner()) {
      arg.set("title", '编辑群头像')
      arg.set("editable", true)
    } else {
      arg.set("title", '群头像')
      arg.set("editable", false)
    }

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }
        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupIcon(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          promptAction.showToast({ message: '更改群头像失败:' + result.code })
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 修改群简介
  jumpToEditGroupDesc() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getDescription() ?? '')
    arg.set('limit', 100)
    if (this.isAdminOrOwner()) {
      arg.set("title", '编辑群简介')
      arg.set("editable", true)
    } else {
      arg.set("title", '群简介')
      arg.set("editable", false)
    }

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }
        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupDescription(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
            promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
          } else {
            promptAction.showToast({ message: '更改群聊名称失败:' + result.code })
          }
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 修改群公告
  jumpToEditGroupNotice() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getNotice() ?? '')
    arg.set('limit', 100)
    if (this.isAdminOrOwner()) {
      arg.set("title", '编辑群公告')
      arg.set("editable", true)
    } else {
      arg.set("title", '群公告')
      arg.set("editable", false)
    }

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }
        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupNotice(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
            promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
          } else {
            promptAction.showToast({ message: '更改群公告失败:' + result.code })
          }
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 修改我的群昵称
  jumpToEditGroupMyAlias() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getCurrentMember()?.getAlias() ?? '')
    arg.set('limit', 100)
    arg.set("title", '编辑我的群昵称')
    arg.set("editable", true)

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }
        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupMemberAlias(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
            promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
          } else {
            promptAction.showToast({ message: '更改我的群昵称失败:' + result.code })
          }
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 修改我的群头像
  jumpToEditGroupMyIcon() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', this.conversation?.getCurrentMember()?.getAvatarUrl() ?? '')
    arg.set('limit', 1000)
    arg.set("title", '编辑我的群头像')
    arg.set("editable", true)

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }

        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        let result = await liveService.setLiveGroupMemberAvatar(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          promptAction.showToast({ message: '更改我的群头像失败:' + result.code })
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

 async setLiveGroupSilent(isSilent: boolean) {
   let liveService = BIMUIClient.getInstance().getLiveService();
   if (!liveService) {
     return
   }
   liveService.setLiveGroupSilent(this.cid, isSilent)
  }

  // 禁言白名单
  jumpToSilentWhiteListPage() {
    let map = new Map<string, string>()
    map.set('cid', this.cid)
    IMRouter.push(IMPage.LIVE_MEMBER_SILENT_WHITE_LIST, map)
  }

  // 禁言名单
  jumpToSilentListPage() {
    let map = new Map<string, string>()
    map.set('cid', this.cid)
    IMRouter.push(IMPage.LIVE_MEMBER_SILENT_LIST, map)
  }

  // 进群黑名单
  jumpToBlockListPage() {
    let map = new Map<string, string>()
    map.set('cid', this.cid)
    IMRouter.push(IMPage.LIVE_MEMBER_BLOCK_LIST, map)
  }

  // 在线列表
  jumpToOnlineListPage(isEdit: boolean) {
    let map = new Map<string, string | boolean>()
    map.set('cid', this.cid)
    map.set('isEdit', isEdit)
    IMRouter.push(IMPage.LIVE_MEMBER_ONLINE_LIST, map)
  }

  // 设置管理员
  jumpToSettingAdminPage() {
    let map = new Map<string, string>()
    map.set('cid', this.cid)
    IMRouter.push(IMPage.LIVE_MEMBER_ADMIN_LIST, map)
  }

  // 转让群主
  jumpToTransLiveGroupPage() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('content', '')
    arg.set('limit', 19)
    arg.set("title", '转让群主')
    arg.set("editable", true)

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }

        let map = popInfo.result as Map<string, string>
        let cid =  this.cid
        let result = await liveService.transLiveGroupOwner(cid, map.get('content') as string)
        if (result.code != BIMErrorCode.BIM_OK) {
          promptAction.showToast({ message: '转让群主失败:' + result.code })
        } else {
          // this.requestConversation(cid)
        }
      }
    )
  }

  // 解散直播群
  async dissolveLiveGroup() {
    let result = await promptAction.showDialog({ title: '解散直播群', message: '确定要解散直播群吗？', buttons: [{ text: '取消', color: '#0000FF' }, { text: '确定', color: '#FF0000' }] })
    if (result.index == 1) {
      let liveService = BIMUIClient.getInstance().getLiveService()
      if (!liveService) {
        return
      }
      let result = await liveService.dissolveLiveGroup(this.cid)
      if (result.code != BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: '解散直播群失败:' + result.code })
      } else {
        const data: Record<string, string> = { "operation": "dissolve" }
        IMRouter.pop(data)
      }
    }
  }

  // 退出直播群
  async leaveLiveGroup() {
    let result = await promptAction.showDialog({ title: '退出直播群', message: '确定要退出直播群吗？', buttons: [{ text: '取消', color: '#0000FF' }, { text: '确定', color: '#FF0000' }] })
    if (result.index == 1) {
      let liveService = BIMUIClient.getInstance().getLiveService()
      if (!liveService) {
        return
      }
      let result = await liveService.leaveLiveGroup(this.cid)
      if (result.code != BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: '退出直播群失败:' + result.code })
      } else {
        const data: Record<string, string> = { "operation": "quit" }
        IMRouter.pop(data)
      }
    }
  }

}


