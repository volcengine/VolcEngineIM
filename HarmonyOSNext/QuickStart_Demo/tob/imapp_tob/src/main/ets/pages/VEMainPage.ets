import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { VEConvListFragment } from './conv/VEConvListFragment';
import { VEMineFragment } from './mine/VEMineFragment';
import { BIMUIClient } from '@imcloud/im_sdk_ui/Index';
import { BIMConversationListListener } from '@imcloud/imsdk';
import { BIMConversation } from '@imcloud/imsdk';
import { VELiveGroupFragment } from '@imcloud/imapp_live';
import { VEContactListFragment } from '@imcloud/imapp_contact';
import { BIMUnReadInfo } from '@imcloud/imsdk';

@Component
export struct VEMainPage {
  @State currentIndex: number = 0
  @State totalUnread: string = "10"
  @State isShowUnReadCount: boolean = false
  @State isShowMuteUnReadCount: boolean = false
  @State mineUnread: string = ""
  @State isShowMineUnread: boolean = false

  aboutToAppear(): void {
    let listener: BIMConversationListListener = {
      onNewConversation: (conversationList: BIMConversation[]): void => {
      },
      onConversationChanged: (conversationList: BIMConversation[]): void => {
      },
      onConversationDelete: (conversationList: BIMConversation[]): void => {
      },
      onTotalUnreadMessageCountChanged: (unreadCount: number): void => {
        this.isShowUnReadCount = false
        this.isShowMuteUnReadCount = false
        if (unreadCount > 0) {
          this.isShowUnReadCount = true
          if (unreadCount > 99) {
            this.totalUnread = "99+";
          } else {
            this.totalUnread = unreadCount.toString();
          }
        }
        // else if (unreadInfo.muteUnreadCount > 0) { //免打扰未读数
        //   this.isShowMuteUnReadCount = true
        //   if (unreadInfo.muteUnreadCount > 99) {
        //     this.totalUnread = "99+";
        //   } else {
        //     this.totalUnread = unreadInfo.muteUnreadCount.toString();
        //   }
        // }

      }
    }
    BIMUIClient.getInstance().addConversationListener(listener)
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Stack() {
          VEConvListFragment().visibility(this.currentIndex == 0 ? Visibility.Visible : Visibility.Hidden)
          VELiveGroupFragment().visibility(this.currentIndex == 1 ? Visibility.Visible : Visibility.Hidden)
          VEContactListFragment().visibility(this.currentIndex == 2 ? Visibility.Visible : Visibility.Hidden)
          VEMineFragment().visibility(this.currentIndex == 3 ? Visibility.Visible : Visibility.Hidden)
        }
        .width('100%')
        .backgroundColor(Color.White)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.End }) {
          Tab({
            currentIndex: this.currentIndex,
            unreadStr: this.totalUnread,
            nameRes: $r("app.string.ve_im_in_main_tab_conv"),
            normalImg: $r('app.media.icon_in_main_menu_conversation_unclicked'),
            targetIndex: 0,
            isShowUnread: this.isShowUnReadCount,
            isShowMuteUnRead: this.isShowMuteUnReadCount
          })

          Tab({
            currentIndex: this.currentIndex,
            unreadStr: this.mineUnread,
            nameRes: $r("app.string.ve_im_in_main_tab_live"),
            normalImg: $r('app.media.tabbar_livegroup_normal'),
            targetIndex: 1,
            isShowUnread: this.isShowMineUnread,
            isShowMuteUnRead: this.isShowMineUnread
          }).visibility(Visibility.None)
          Tab({
            currentIndex: this.currentIndex,
            unreadStr: this.mineUnread,
            nameRes: $r("app.string.ve_im_in_main_tab_contact"),
            normalImg: $r('app.media.tabbar_friendlist_normal'),
            targetIndex: 2,
            isShowUnread: this.isShowMineUnread,
            isShowMuteUnRead: this.isShowMineUnread
          }).visibility(Visibility.None)
          Tab({
            currentIndex: this.currentIndex,
            unreadStr: this.mineUnread,
            nameRes: $r("app.string.ve_im_in_main_tab_mine"),
            normalImg: $r('app.media.icon_in_main_menu_mine_unclicked'),
            targetIndex: 3,
            isShowUnread: this.isShowMineUnread,
            isShowMuteUnRead: this.isShowMineUnread
          })
        }
        .width('100%')
        .height(70 + BIMUIClient.getInstance().getNavHeight())
        .padding({ bottom: BIMUIClient.getInstance().getNavHeight() })
        .backgroundColor('#ff33b5e5')
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      return true
    })
  }

  @Builder
  buildTab() {

  }
}


@Component
struct Tab {
  @Link currentIndex: number
  @Link unreadStr: string
  @Link isShowUnread: boolean
  @Link isShowMuteUnRead : boolean
  nameRes: ResourceStr = ""
  normalImg: ResourceStr = ""
  targetIndex: number = 0

  build() {
    Column() {
      Stack() {
        Image(this.normalImg)
          .size({ width: 25, height: 25 })
        Stack() {
          Shape() {
            Circle().width(20).height(20).fill(this.isShowUnread ? Color.Red : '#999999')
          }

          Text(this.unreadStr).fontSize(10).fontColor(Color.White)
        }.visibility(this.isShowUnread || this.isShowMuteUnRead ? Visibility.Visible : Visibility.Hidden)
        .offset({
          left: 10, top: -10
        })
      }

      Text(this.nameRes)
        .fontColor(this.currentIndex === this.targetIndex ? '#FF9770FF' : '#FF000000')
        .margin({ top: 2 })
    }.justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .onClick(() => {
      this.currentIndex = this.targetIndex
    })
  }
}

@Builder
function mainPageBuilder() {
  VEMainPage()
}

IMRouter.registerBuilder(IMPage.TOB_MAIN, wrapBuilder(mainPageBuilder))