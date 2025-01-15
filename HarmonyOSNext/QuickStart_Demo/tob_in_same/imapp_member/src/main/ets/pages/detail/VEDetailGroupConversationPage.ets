import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMConversation, BIMConversationListListener, BIMConversationType, BIMErrorCode, BIMMemberRole, BIMMessage, BIMSendCallback, BIMUnReadInfo } from '@imcloud/imsdk'
import { MainItem } from '../../components/Setting/VEIMMainItem'
import { ToggleItem } from '../../components/Setting/VEIMToggleItem'
import { BIMUIClient, BIMUIUser } from '@imcloud/im_sdk_ui'
import { promptAction } from '@kit.ArkUI'
import { VEMemberActionBar } from '../../components/VEMemberActionBar'
import { VEUserWrapper } from '../create/VEUserWrapper'
import { GroupNotifyElement } from '@imcloud/im_sdk_ui/src/main/ets/components/msg/custom/GroupNotifyElement'
import { VEUserHorizonListView } from '../../components/hor/VEUserHorizonListView'
import { VEUserHorizonSource } from '../../components/hor/VEUserHorizonSource'
import { VEIMDividerTmp } from '../../components/Setting/VEIMDividerTmp'
import { HashMap } from '@kit.ArkTS'


@Component
export struct VEDetailGroupConversationPage {
  private tag = `VEDetail`
  arg: Map<string, string> = new Map<string, string>()
  @State cid: string = ''
  @State conversation: BIMConversation | undefined = undefined
  @State stickTop: boolean = false
  @State mute: boolean = false
  @State userList: VEUserHorizonSource = new VEUserHorizonSource()
  egDivider: VEIMDividerTmp = new VEIMDividerTmp(1, 10, 10, '#ffe9f0f0')

  async setupData(): Promise<void> {
    let cid = this.arg.get('cid')
    if (cid) {
      let r = await BIMUIClient.getInstance().getConversation(cid)
      this.conversation = r.data
      this.cid = cid
      this.stickTop = this.conversation?.isStickTop() ?? false
      this.mute = this.conversation?.isMute() ?? false

      this.userList.clear()
      let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
      if (result.data) {
        result.data.forEach((member) => {
          let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
          this.userList.addData(userInfo)
        })
      }
    }

  }

  private convListener: BIMConversationListListener = {
    onConversationChanged: (conversationList: BIMConversation[]): void => {
      for (let conv of conversationList) {
        if (conv.getConversationId() == this.cid) {
          this.setupData()
          return
        }
      }
    },
    onNewConversation: (conversationList: BIMConversation[]): void => {

    },
    onConversationDelete: (conversationList: BIMConversation[]): void => {

    },
    onTotalUnreadMessageCountChanged: (unreadCount: number): void => {

    }
  }

  addConversationListener(): void {

    BIMUIClient.getInstance().addConversationListener(this.convListener)
  }

  removeConversationListener(): void {

    BIMUIClient.getInstance().removeConversationListener(this.convListener)
  }

  aboutToAppear(): void {
    this.addConversationListener()
    this.setupData()
  }

  aboutToDisappear(): void {
    this.removeConversationListener()
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        VEMemberActionBar({
          title: '聊天详情',
        })
        List({ space: 30 }) {

          ListItem() {
            VEUserHorizonListView({
              data: this.userList,
              rightText: '',
              canAdd: this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER ? true : false,
              canRemove: (this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) ? true : false,
              onAddClick: async () => {
                let arg = new Map<string, string | number>()
                arg.set("title", '添加成员')
                arg.set('cid', this.cid)
                arg.set('userAddShowType', 1)
                IMRouter.push(IMPage.IM_MEMBER_CREATE_GROUP, arg, async (popInfo) => {
                  let uidStringList = popInfo.result as string[]
                  if (uidStringList.length == 0) {
                    return
                  }

                  let result = await BIMUIClient.getInstance().addGroupMemberList(this.cid, uidStringList)
                  if (result.code == BIMErrorCode.BIM_OK) {
                    let systemMsg = `${BIMUIClient.getInstance().getCurrentUserID()} 邀请 `
                    uidStringList.forEach((uid) => {
                      let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid)
                      if (uidStringList[uidStringList.length - 1] != uid) {
                        systemMsg += (userInfo.nickName + '、')
                      } else {
                        systemMsg += (userInfo.nickName + ' 加入群聊')
                      }
                    })
                    let message = BIMUIClient.getInstance().createCustomMessageWithElement(new GroupNotifyElement(systemMsg))
                    if (message) {
                      BIMUIClient.getInstance().sendMessage(message, this.cid)
                    }

                    let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                    this.userList.clear()
                    if (result.data) {
                      result.data.forEach((member) => {
                        let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
                        this.userList.addData(userInfo)
                      })
                    }
                  } else {
                    if (result.code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                      promptAction.showToast({ message: '加群个数超过上限' })
                    }else if (result.code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_TOUCH_LIMIT) {
                      promptAction.showToast({ message: '群成员已达上限' })
                    } else {
                      promptAction.showToast({ message: '添加失败:' + result.code })
                    }
                  }
                })
              },
              onRemoveClick: async () => {
                let wrapperArray: VEUserWrapper[] = []
                let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                if (result.data) {
                  let normalArray: VEUserWrapper[] = []
                  let adminArray: VEUserWrapper[] = []
                  result.data.forEach((member) => {
                    let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
                    let wrapper = new VEUserWrapper(userInfo, member, true, false)
                    switch (member.getRole()) {
                      case BIMMemberRole.BIM_MEMBER_ROLE_OWNER: // 只有一个
                        // wrapperArray.push(wrapper)
                        break;
                      case BIMMemberRole.BIM_MEMBER_ROLE_ADMIN:
                        adminArray.push(wrapper)
                        break;
                      default:
                        normalArray.push(wrapper)
                    }
                  })
                  wrapperArray = wrapperArray.concat(adminArray, normalArray)
                }

                let arg = new Map<string, string | boolean | object>()
                arg.set("title", '移除群成员')
                arg.set('isEdit', true)
                arg.set('userList', wrapperArray)

                IMRouter.push(
                  IMPage.IM_UI_MEMBER_LIST,
                  arg,
                  async (popInfo) => {
                    let mResult = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                    if (!mResult.data) {
                      return
                    }

                    let selectedIDList = popInfo.result as string[]

                    if (selectedIDList.length) {
                      let result = await BIMUIClient.getInstance().removeGroupMemberList(this.cid, selectedIDList)
                      if (result.code != BIMErrorCode.BIM_OK) {
                        promptAction.showToast({ message: '移除失败' })
                      } else {
                        let systemMsg = ''
                        selectedIDList.forEach((uid) => {
                          let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid)
                          if (selectedIDList[selectedIDList.length - 1] != uid) {
                            systemMsg += (userInfo.nickName + '、')
                          } else {
                            systemMsg += (userInfo.nickName + '退出群聊')
                          }
                        })
                        let message = BIMUIClient.getInstance().createCustomMessageWithElement(new GroupNotifyElement(systemMsg))
                        if (message) {
                          BIMUIClient.getInstance().sendMessage(message, this.cid)
                        }

                        let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                        this.userList.clear()
                        if (result.data) {
                          result.data.forEach((member) => {
                            let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
                            this.userList.addData(userInfo)
                          })
                        }
                      }
                    }
                  })
              }

            })
              .padding({ left: 10, right: 10 })
              .onClick(async () => {
                let wrapperArray: VEUserWrapper[] = []
                let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                if (result.data) {
                  let normalArray: VEUserWrapper[] = []
                  let adminArray: VEUserWrapper[] = []
                  result.data.forEach((member) => {
                    let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
                    let wrapper = new VEUserWrapper(userInfo, member, false, false)
                    switch (member.getRole()) {
                      case BIMMemberRole.BIM_MEMBER_ROLE_OWNER: // 只有一个
                        wrapperArray.push(wrapper)
                        break;
                      case BIMMemberRole.BIM_MEMBER_ROLE_ADMIN:
                        adminArray.push(wrapper)
                        break;
                      default:
                        normalArray.push(wrapper)
                    }
                  })
                  wrapperArray = wrapperArray.concat(adminArray, normalArray)
                }

                let arg = new Map<string, string | boolean | object>()
                arg.set("title", this.conversation?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT ? '群成员列表' : '成员列表')
                arg.set('isEdit', false)
                arg.set('userList', wrapperArray)

                IMRouter.push(IMPage.IM_UI_MEMBER_LIST, arg)
              })
          }

          if (this.conversation?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
            ListItem() {

              MainItem({ title: '群聊名称', detail: this.conversation?.getName()?.length ? this.conversation.getName() as string : "未命名群聊" })
                .onClick(() => {
                  let arg = new Map<string, string | boolean | number>()
                  arg.set('content', this.conversation?.getName() ?? '')
                  arg.set('limit', 10)
                  if (this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
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
                      let map = popInfo.result as Map<string, string>
                      let result = await BIMUIClient.getInstance().setGroupName(this.cid, map.get('content') as string)
                      if (result.code != BIMErrorCode.BIM_OK) {
                        if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
                          promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
                        } else {
                          promptAction.showToast({ message: '更改群聊名称失败:' + result.code })
                        }
                      } else {
                        let r = await BIMUIClient.getInstance().getConversation(this.cid)
                        this.conversation = r.data
                      }
                    })
                })

            }

            ListItem() {
              MainItem({ title: '群公告', detail: this.conversation?.getNotice()?.length ? this.conversation.getNotice() as string : '未设定' })
                .onClick(() => {
                  let arg = new Map<string, string | boolean|number>()
                  arg.set('content', this.conversation?.getNotice() ?? '')
                  if (this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                    arg.set("title", '编辑群公告')
                    arg.set("editable", true)
                  } else {
                    arg.set("title", '群公告')
                    arg.set("editable", false)
                  }
                  arg.set('limit', 100)
                  IMRouter.push(
                    IMPage.IM_UI_TEXT_INPUT,
                    arg,
                    async (popInfo) => {
                      let map = popInfo.result as Map<string, string>
                      let result = await BIMUIClient.getInstance().setGroupNotice(this.cid, map.get('content') as string)
                      if (result.code != BIMErrorCode.BIM_OK) {
                        if (result.code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
                          promptAction.showToast({ message: '文本中可能包含敏感词，请修改后重试' })
                        } else {
                          promptAction.showToast({ message: '更改群公告失败:' + result.code })
                        }
                      } else {
                        let r = await BIMUIClient.getInstance().getConversation(this.cid)
                        this.conversation = r.data
                      }
                    })
                })
            }
          }


          if (this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            ListItem() {
              MainItem({ title: '设置管理员', detail: '' })
                .onClick(async () => {
                  let wrapperArray: VEUserWrapper[] = []
                  let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                  if (result.data) {
                    let normalArray: VEUserWrapper[] = []
                    let adminArray: VEUserWrapper[] = []
                    result.data.forEach((member) => {
                      let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
                      let isSelected = member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN ? true : false
                      let wrapper = new VEUserWrapper(userInfo, member, true, isSelected)
                      switch (member.getRole()) {
                        case BIMMemberRole.BIM_MEMBER_ROLE_OWNER: // 只有一个
                          wrapperArray.push(wrapper)
                          break;
                        case BIMMemberRole.BIM_MEMBER_ROLE_ADMIN:
                          adminArray.push(wrapper)
                          break;
                        default:
                          normalArray.push(wrapper)
                      }
                    })
                    wrapperArray = wrapperArray.concat(adminArray, normalArray)
                  }

                  let arg = new Map<string, string | boolean | object>()
                  arg.set("title", '设置管理员')
                  arg.set('isEdit', true)
                  arg.set('userList', wrapperArray)

                  IMRouter.push(
                    IMPage.IM_UI_MEMBER_LIST,
                    arg,
                    async (popInfo) => {
                      let mResult = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
                      if (!mResult.data) {
                        return
                      }
                      let oldIDList: string[] = []
                      mResult.data.forEach((member) => {
                        switch (member.getRole()) {
                          case BIMMemberRole.BIM_MEMBER_ROLE_ADMIN:
                            oldIDList.push(member.getUserID().toString())
                            break;
                          default:
                            break;
                        }
                      })

                      let selectedIDList: string[] = popInfo.result as string[]
                      let addedList: string[] = selectedIDList.filter(x =>!oldIDList.includes(x))
                      let removedList: string[] = oldIDList.filter(x =>!selectedIDList.includes(x))

                      if (addedList.length) {
                        let addedResult = await BIMUIClient.getInstance().setGroupMemberRole(this.cid, addedList, BIMMemberRole.BIM_MEMBER_ROLE_ADMIN)
                        if (addedResult.code == BIMErrorCode.BIM_OK) {
                          let message = BIMUIClient.getInstance().createCustomMessageWithElement(new GroupNotifyElement(addedList.join(',') + ' 成为管理员'))
                          if (message) {
                            BIMUIClient.getInstance().sendMessage(message, this.cid)
                          }
                        }
                      }

                      if (removedList.length) {
                        let removedResult = await BIMUIClient.getInstance().setGroupMemberRole(this.cid, removedList, BIMMemberRole.BIM_MEMBER_ROLE_NORMAL)
                        if (removedResult.code == BIMErrorCode.BIM_OK) {
                          let message = BIMUIClient.getInstance().createCustomMessageWithElement(new GroupNotifyElement(removedList.join(',') + ' 被取消管理员'))
                          if (message) {
                            BIMUIClient.getInstance().sendMessage(message, this.cid)
                          }
                        }
                      }
                    })
                })
            }
          }

          ListItem() {
            ToggleItem({
              title: '置顶聊天', isSwitchOn: this.stickTop, switchOnClick: async () => {
                this.stickTop = !this.stickTop
                let result = await BIMUIClient.getInstance().stickTopConversation(this.cid, this.stickTop) // 失败后重置状态
                if (result.code != BIMErrorCode.BIM_OK) {
                  promptAction.showToast({ message: '置顶聊天失败:' + result.code })
                  this.stickTop = !this.stickTop
                }
              }
            })
          }

          ListItem() {
            ToggleItem({
              title: '消息免打扰', isSwitchOn: this.mute, switchOnClick: async () => {
                this.mute = !this.mute
                let result = await BIMUIClient.getInstance().muteConversation(this.cid, this.mute)
                if (result.code != BIMErrorCode.BIM_OK) {
                  promptAction.showToast({ message: '消息免打扰失败:' + result.code })
                  this.mute = !this.mute
                }
              }
            })
          }

          ListItem() {
            MainItem({ title: '搜索消息记录', detail: '' })
              .onClick(() => {
                IMRouter.push(IMPage.IM_MEMBER_SEARCH_TEXT, this.arg)
              })
          }

          if (this.conversation?.getCurrentMember()?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            ListItem() {
              MainItem({ title: '解散群聊', detail: '' })
                .onClick(async () => {
                  let result = await promptAction.showDialog({ title: '解散群聊', message: '确定要解散群聊吗？', buttons: [{ text: '取消', color: '#0000FF' }, { text: '确定', color: '#FF0000' }] })
                  if (result.index == 1) {
                    let result = await BIMUIClient.getInstance().dissolveGroup(this.cid, true)
                    if (result.code != BIMErrorCode.BIM_OK) {
                      promptAction.showToast({ message: '解散群聊失败:' + result.code })
                    } else {
                      const data: Record<string, string> = { "operation": "dissolve" }
                      IMRouter.pop(data)
                    }
                  }
                })
            }
          }

          if (this.conversation?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
            ListItem() {
              MainItem({ title: '退出群聊', detail: '' })
                .onClick(async () => {
                  let result = await promptAction.showDialog({ title: '退出群聊', message: '确定要退出群聊吗？', buttons: [{ text: '取消', color: '#0000FF' }, { text: '确定', color: '#FF0000' }] })
                  if (result.index == 1) {
                    let systemMsg = `${BIMUIClient.getInstance().getCurrentUserID()} 退出群聊 `
                    let message = BIMUIClient.getInstance().createCustomMessageWithElement(new GroupNotifyElement(systemMsg))
                    if (message) {

                      await BIMUIClient.getInstance().sendMessage(message, this.cid,{
                        onProgress: (message: BIMMessage, progress: number): void => {
                        },
                        onSaved: (message: BIMMessage): void => {
                        },
                        onSuccess: async (message: BIMMessage): Promise<void> => {
                          let result = await BIMUIClient.getInstance().leaveGroup(this.cid, false)
                          if (result.code != BIMErrorCode.BIM_OK) {
                            promptAction.showToast({ message: '退出失败:' + result.code })
                          } else {
                            let isSuccess = await BIMUIClient.getInstance().deleteConversation(this.cid) //删除会话
                            console.debug(`${this.tag} delete conv isSuccess:${isSuccess}`)
                            const data: Record<string, string> = { "operation": "quit" }
                            IMRouter.pop(data)
                          }
                        },
                        onError: (message: BIMMessage, code: BIMErrorCode): void => {

                        }
                      })
                    }


                  }
                })
            }
          }

          ListItem() {
            MainItem({ title: '内部功能', detail: '' })
              .onClick(() => {
                IMRouter.push(IMPage.IM_MEMBER_INTERNAL_DETAIL_CONVERSATION, this.arg)
              })
          }.visibility(BIMUIClient.isTob() ? Visibility.None : Visibility.Visible)

        }
        .divider(this.egDivider)
      }
    }.hideTitleBar(true)
  }
}

@Builder
function groupDetailPageBuilder(value: object) {
  VEDetailGroupConversationPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_DETAIL_GROUP, wrapBuilder(groupDetailPageBuilder))