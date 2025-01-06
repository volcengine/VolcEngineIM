import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { BIMConversationType } from '@imcloud/imsdk';
import { BIMConversation } from '@imcloud/imsdk';
import { BIMMessage } from '@imcloud/imsdk';
import { BIMMessageType } from '@imcloud/imsdk';
import { BIMAudioElement } from '@imcloud/imsdk';
import { BIMAudioPlayer } from '../utils/BIMAudioPlayer';
import { BIMMessageListView, BIMUIClient } from '../../../../Index';
import { BIMConversationListListener, BIMImageElement, BIMUnReadInfo, BIMVideoElement } from '@imcloud/imsdk';

@Component
export struct INMessageListPage {
  arg: Map<string, string> = new Map<string, string>()
  @State title: string = ""
  @State conv: BIMConversation | undefined = undefined

  aboutToDisappear(): void {
    BIMAudioPlayer.getInstance().stop()
    this.removeConversationListener()
  }

  aboutToAppear(): void {
    this.addConversationListener()
  }

  private convListener: BIMConversationListListener = {
    onConversationChanged: (conversationList: BIMConversation[]): void => {
      for (let conv of conversationList) {
        if (conv.getConversationId() == this.arg.get('cid')) {
          // this.conv = conv
          this.refreshTitle()
          return
        }
      }
    },
    onNewConversation: (conversationList: BIMConversation[]): void => {

    },
    onConversationDelete: (conversationList: BIMConversation[]): void => {

    },
    onTotalUnreadMessageCountChanged: (unreadInfo: BIMUnReadInfo): void => {

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
        BIMMessageListView({ cid: this.arg.get('cid'), onItemClickListener: this.msgClick })
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

  private msgClick = ( msg: BIMMessage) => {
    if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE) {
      let imageElement = msg.content as BIMImageElement
      if (imageElement.largeImg?.url) {
        let data: Map<string, string> = new Map()
        data.set("url", imageElement.largeImg?.url)
        IMRouter.push(IMPage.IM_PREVIEW_IMAGE_PAGE, data)
      }
    } else if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
      let videoElement = msg.content as BIMVideoElement
      if (videoElement.videoURL) {
        let data: Map<string, string> = new Map()
        data.set("url", videoElement.videoURL)
        IMRouter.push(IMPage.IM_PREVIEW_VIDEO_PAGE, data)
      }
    } else if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_AUDIO) {
      let audioElement = msg.content as BIMAudioElement
      if (audioElement?.audioURL) {
        BIMAudioPlayer.getInstance().play(audioElement?.audioURL)
      } else {
        BIMAudioPlayer.getInstance().play(audioElement?.localUri)
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

        Image($r('app.media.icon_im_more'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .margin({ right: 10 })
          .padding(10)
          .onClick(() => {
            if (this.conv?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
              let arg = new Map<string, string>()
              arg.set("cid", this.conv.getConversationId())
              IMRouter.push(IMPage.IM_MEMBER_DETAIL_GROUP, arg)
            } else if (this.conv?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
              let arg = new Map<string, string>()
              arg.set("cid", this.conv.getConversationId())
              IMRouter.push(IMPage.IM_MEMBER_DETAIL_GROUP, arg)
            }
          })
          .visibility(this.conv?.isMember() ? Visibility.Visible : Visibility.Hidden)
      }.height(48)
    }
    .height(50)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }
}

@Builder
function messageListPageBuilder(value: object) {
  INMessageListPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_UI_MESSAGE_LIST, wrapBuilder(messageListPageBuilder))