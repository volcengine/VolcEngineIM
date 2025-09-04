import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { BIMAudioElement, BIMConversation, BIMConversationListListener, BIMConversationType, BIMImageElement, BIMMessage, BIMMessageType, BIMVideoElement } from '@imcloud/imsdk';
import { BIMAudioPlayer } from '../utils/BIMAudioPlayer';
import { BIMMessageListView, BIMUIClient } from '../../../../Index';
import { promptAction } from '@kit.ArkUI';
import { BIMMsgListViewModel } from '../components/msg/data/BIMMsgListViewModel';
import BIMUILog from '../log/BIMUILog';

@Component
export struct INMessageListPage {
  tag = "INMessageListPage"
  arg: Map<string, string> = new Map<string, string>()
  @State title: string = ""
  @State conv: BIMConversation | undefined = undefined
  private cid: string = ""
  @State msgListViewModel: BIMMsgListViewModel = new BIMMsgListViewModel("")

  aboutToDisappear(): void {
    BIMUILog.debug(this.tag,"aboutToDisappear")
    BIMAudioPlayer.getInstance().stop()
    this.removeConversationListener()
  }

  aboutToAppear(): void {
    this.cid = this.arg.get("cid") ?? ""
    this.msgListViewModel = new BIMMsgListViewModel(this.cid)
    this.addConversationListener()
  }

  private convListener: BIMConversationListListener = {
    onConversationChanged: (conversationList: BIMConversation[]): void => {
      for (let conv of conversationList) {
        if (conv.getConversationId() == this.arg.get('cid')) {
          this.conv = conv
          this.refreshTitle()
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

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Actionbar({ title: this.title, conv: this.conv })
        Divider().width('100%').height(2)
        BIMMessageListView({ cid: this.arg.get('cid'), onItemClickListener: this.msgClick, rootViewModel: this.msgListViewModel })
      }
      .width('100%')
      .height('100%')
    }
    .onShown(() => {
      this.refreshTitle()
    })
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }

  private async refreshTitle() {
    let cid = this.arg.get('cid');
    if (cid) {
      let r = await BIMUIClient.getInstance().getConversation(cid)
      this.conv = r.data
      if (r.data?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
        let optUid = r.data.getOppositeUserID(BIMUIClient.getInstance().uid)
        this.title = BIMUIClient.getInstance().getUserProvider().getUserInfo(optUid).nickName
      } else {
        let title = r.data?.getName()
        if (title?.length) {
          this.title = title
        } else {
          this.title = '未命名群聊'
        }
      }
    }
  }

  private msgClick = (msg: BIMMessage) => {
    if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE) {
      let imageElement = msg.getElement() as BIMImageElement
      if (imageElement.largeImg?.url) {
        let data: Map<string, string> = new Map()
        data.set("url", imageElement.largeImg?.url)
        IMRouter.push(IMPage.IM_PREVIEW_IMAGE_PAGE, data)
      }
    } else if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
      let videoElement = msg.getElement() as BIMVideoElement
      if (videoElement.url) {
        let data: Map<string, string> = new Map()
        data.set("url", videoElement.url)
        IMRouter.push(IMPage.IM_PREVIEW_VIDEO_PAGE, data)
      }
    } else if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_AUDIO) {
      let audioElement = msg.getElement() as BIMAudioElement
      if (audioElement?.url) {
        BIMAudioPlayer.getInstance().play(audioElement?.url)
      } else {
        BIMAudioPlayer.getInstance().play(audioElement?.localURI)
      }
      let data: Map<string, string> = new Map()
      data.set("hasPlay", '1')
      BIMUIClient.getInstance().setMessageLocalExt(msg, data)
    }
  }
}

@Component
struct Actionbar {
  @Prop title: string
  @Prop conv: BIMConversation | undefined
  tag = "INMessageListPage"

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Image($r('app.media.icon_im_back_black'))
          .objectFit(ImageFit.Contain)
          .width(40)
          .height(40)
          .padding(10)
          .onClick(() => {
            IMRouter.pop()
          })
        Text(this.title)
          .fontSize(20)
          .fontColor('#222222')
          .maxLines(1)
          .ellipsisMode(EllipsisMode.END)

        Image($r('app.media.icon_im_more'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .margin({ right: 10 })
          .padding(10)
          .onClick(() => {
            if (this.conv?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
              this.startToDetail()
            } else if (this.conv?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
              if (!this.conv.isMember()) {
                promptAction.showToast({ message: "已不再改群" })
                return
              }
              if (this.conv.isDissolved()) {
                promptAction.showToast({ message: "群聊已解散" })
                return
              }
              this.startToDetail()
            }
          })
          .visibility(this.conv?.isMember() ? Visibility.Visible : Visibility.Hidden)
      }.height(48)
    }
    .height(50)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }

  startToDetail() {
    if (this.conv) {
      let arg = new Map<string, string>()
      arg.set("cid", this.conv?.getConversationId())
      IMRouter.push(IMPage.IM_MEMBER_DETAIL_GROUP, arg, (data) => {
        let r = data.result as Record<string, string>
        let opt = r["operation"] as string
        console.debug(this.tag, `onResult opt:${opt}`)
        if (opt == "dissolve" || opt == "quit") {
          IMRouter.pop() //退群解散则退出当前页面
        }
      })
    }
  }
}

@Builder
function messageListPageBuilder(value: object) {
  INMessageListPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_UI_MESSAGE_LIST, wrapBuilder(messageListPageBuilder))