import { IMPage, IMRouter } from "@imcloud/imapp_router"
import { VELiveUserHorizonListView } from "./components/hor/VELiveUserHorizonListView"
import { VELiveIMDividerTmp } from "./components/VELiveIMDividerTmp"
import { VELiveIMMainItem } from "./components/VELiveIMMainItem"
import { VELiveIMToggleItem } from "./components/VELiveIMToggleItem"
import { VELiveGroupDetailConversationViewModel } from "./VELiveGroupDetailConversationViewModel"
import { VELiveMemberActionBar } from "./VELiveMemberActionBar"

@Component
export struct VELiveGroupDetailConversationPage {
  private tag = `VELiveGroupDetail`
  arg: Map<string, string> = new Map<string, string>()
  @State viewModel: VELiveGroupDetailConversationViewModel = new VELiveGroupDetailConversationViewModel('')
  egDivider: VELiveIMDividerTmp = new VELiveIMDividerTmp(1, 10, 10, '#ffe9f0f0')

   setupData(): void {
    let cid = this.arg.get('cid')
    if (cid) {
      this.viewModel = new VELiveGroupDetailConversationViewModel(cid)
    }
  }

  aboutToAppear(): void {
    this.setupData()
    this.viewModel.aboutToAppear()
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear()
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        VELiveMemberActionBar({
          title: '聊天详情',
        })
        List({ space: 30 }) {
          ListItem() {
            VELiveUserHorizonListView({
              data: this.viewModel.uiState.userList,
              rightText: (this.viewModel.uiState.onlineMemberCount).toString() + '人',
              canAdd: false,
              canRemove: this.viewModel.uiState.isAdminOrOwner,
              onAddClick: async () => {},
              onRemoveClick: async () => {
                this.viewModel.onUserHorizonListViewRemoveClick()
              }
            })
              .padding({ left: 10, right: 10 })
              .onClick(async () => {
                this.viewModel.onUserHorizonListViewClick()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '查询用户状态', detail: '' })
              .onClick(() => {
                this.viewModel.jumpToOnlineQuery();
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '群聊名称', detail: this.viewModel.uiState.convName })
              .onClick(() => {
                this.viewModel.jumpToEditGroupName()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '群头像', detail: '' })
              .onClick(() => {
                this.viewModel.jumpToEditGroupIcon()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '群简介', detail: this.viewModel.uiState.convIntroduction })
              .onClick(() => {
                this.viewModel.jumpToEditGroupDesc()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '群公告', detail: this.viewModel.uiState.convNotice })
              .onClick(() => {
                this.viewModel.jumpToEditGroupNotice()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '我的群昵称', detail: this.viewModel.uiState.myAlias })
              .onClick(() => {
                this.viewModel.jumpToEditGroupMyAlias()
              })
          }

          ListItem() {
            VELiveIMMainItem({ title: '我的群头像', detail: '' })
              .onClick(() => {
                this.viewModel.jumpToEditGroupMyIcon()
              })
          }

          ListItem() {
            VELiveIMToggleItem({
              title: '全员禁言',
              isSwitchOn: this.viewModel.uiState.isConversationSilent,
              isEnabled: this.viewModel.uiState.isAdminOrOwner,
              switchOnClick: async () => {
                this.viewModel.uiState.isConversationSilent = !this.viewModel.uiState.isConversationSilent
                this.viewModel.setLiveGroupSilent(this.viewModel.uiState.isConversationSilent)
              }
            })

          }

          if (this.viewModel.uiState.isConversationSilent) {
            ListItem() {
              VELiveIMMainItem({ title: '-禁言白名单', detail: '' })
                .onClick(() => {
                  this.viewModel.jumpToSilentWhiteListPage()
                })
            }
          }

          if (this.viewModel.uiState.isAdminOrOwner) {
            ListItem() {
              VELiveIMMainItem({ title: '禁言名单', detail: '' })
                .onClick(() => {
                  this.viewModel.jumpToSilentListPage()
                })
            }

            ListItem() {
              VELiveIMMainItem({ title: '进群黑名单', detail: '' })
                .onClick(() => {
                  this.viewModel.jumpToBlockListPage()
                })
            }
          }

          if (this.viewModel.uiState.isOwner) {
            ListItem() {
              VELiveIMMainItem({ title: '转让群主', detail: '' })
                .onClick(() => {
                  this.viewModel.jumpToTransLiveGroupPage()
                })
            }

            ListItem() {
              VELiveIMMainItem({ title: '设置管理员', detail: '' })
                .onClick(async () => {
                  this.viewModel.jumpToSettingAdminPage()
                })
            }

            ListItem() {
              VELiveIMMainItem({ title: '解散直播群', detail: '' })
                .onClick(async () => {
                  this.viewModel.dissolveLiveGroup()
                })
            }
          }

          ListItem() {
            VELiveIMMainItem({ title: '退出直播群', detail: '' })
              .onClick(async () => {
                this.viewModel.leaveLiveGroup()
              })
          }
        }
        .divider(this.egDivider)
        .layoutWeight(1)
      }
    }.hideTitleBar(true)
  }
}

@Builder
function liveGroupDetailPageBuilder(value: object) {
  VELiveGroupDetailConversationPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_DETAIL_GROUP_PAGE, wrapBuilder(liveGroupDetailPageBuilder))

