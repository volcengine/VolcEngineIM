import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMAudioElement, BIMImageElement, BIMMessage, BIMMessageType, BIMVideoElement, MemberUpdateInfo } from '@imcloud/imsdk'
import { BIMMessageListView, BIMUIClient } from '@imcloud/im_sdk_ui'
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'
import { BIMAudioPlayer } from '@imcloud/im_sdk_ui/src/main/ets/utils/BIMAudioPlayer'
import { LiveMessageListViewModel } from './viewmodel/LiveMessageListViewModel'
import { LiveOnlineViewModel } from './viewmodel/LiveOnlineViewModel'

@Component
export struct VELiveGroupChatRoomPage {
  private TAG = "LiveMsgPage"
  arg: Map<string, string> = new Map()
  private cid:string = ""
  @State liveMsgListViewModel: LiveMessageListViewModel = new LiveMessageListViewModel("")
  @State onlineCountViewModel: LiveOnlineViewModel = new LiveOnlineViewModel("")
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

  aboutToAppear(): void {
    BIMUILog.debug(this.TAG,"aboutToAppear")
    this.cid = this.arg.get("cid") ?? ""
    let name: string = this.arg.get("name") ?? ""
    let url: string = this.arg.get("url") ?? ""
    this.liveMsgListViewModel = new LiveMessageListViewModel(this.cid)
    this.onlineCountViewModel = new LiveOnlineViewModel(this.cid)
    this.onlineCountViewModel.start()
    let info: MemberUpdateInfo = new MemberUpdateInfo
    let ext = new Map<string, string>()
    ext.set("qinMemberKey", "qinMemberValue")
    info.setAlias(name)
    info.setAvatarUrl(url)
    info.setExt(ext)
    this.liveMsgListViewModel.joinGroup(info)
  }
  aboutToDisappear(): void {
    BIMUILog.debug(this.TAG,"aboutToDisappear")
    BIMAudioPlayer.getInstance().stop()
    this.onlineCountViewModel.stop()
    this.liveMsgListViewModel.leaveGroup()
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Actionbar({ title: `${this.liveMsgListViewModel.uiState.convName}(${this.onlineCountViewModel.onLineCount}人)`, cid: this.cid})
        Divider().width('100%').height(2)
        BIMMessageListView({
          cid: this.arg.get('cid'),
          autoFirstLoadDat: false,
          onItemClickListener: this.msgClick,
          rootViewModel: this.liveMsgListViewModel
        })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }
}

@Component
struct Actionbar {
  @Prop title: string
  cid: string | undefined
  tag = "VELiveGroupChatRoomPage"

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
            this.startToDetail()
          })

      }.height(48)
    }
    .height(50)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }

  startToDetail() {
    if (!this.cid) {
      return
    }
    let arg = new Map<string, string>()
    arg.set("cid", this.cid)
    IMRouter.push(IMPage.LIVE_DETAIL_GROUP_PAGE, arg, (data) => {
      let r = data.result as Record<string, string>
      let opt = r["operation"] as string
      console.debug(this.tag, `onResult opt:${opt}`)
      if (opt == "dissolve" || opt == "quit") {
        IMRouter.pop() //退群解散则退出当前页面
      }
    })
  }
}

@Builder
function veChatRoomPageBuilder(arg: object) {
  VELiveGroupChatRoomPage({ arg: arg as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_CHAT_ROOM_CONV_PAGE, wrapBuilder(veChatRoomPageBuilder))