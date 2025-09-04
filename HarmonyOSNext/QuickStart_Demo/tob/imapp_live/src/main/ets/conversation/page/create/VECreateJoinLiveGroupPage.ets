import { IMPage, IMRouter } from '@imcloud/imapp_router'
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'
import { BIMLiveActionBar } from '../../../widget/BIMLiveActionBar'
import { VELiveGroupChatRoomPage } from '../chatroom/VELiveGroupChatRoomPage'
import { VELiveEditPage } from '../edit/VELiveEditPage'
import { LiveImageParamsItem } from './LiveImageParamsItem'
import { LiveTextParamsItem } from './LiveTextParamsItem'

@Component
export struct VECreateJoinLiveGroupPage {
  private tag = "CreateJoin"
  arg: Map<string, string> = new Map()
  @State myNickName: string = ""
  @State myUrl: string = ""

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Column() {
          BIMLiveActionBar({ title: "加入直播群" })
          Divider().width('100%').height(2)
          LiveTextParamsItem({ title: "我的群昵称", detail: this.myNickName })
            .onClick(() => {
              let arg = new Map<string, string>()
              arg.set(VELiveEditPage.TITLE, "我的群昵称")
              arg.set(VELiveEditPage.DETAIL, this.myNickName)
              IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
                this.myNickName = popInfo.result as string
              })
            })
          LiveImageParamsItem({ title: "我的群头像", url: this.myUrl }).onClick(() => {
            let arg = new Map<string, string>()
            arg.set(VELiveEditPage.TITLE, "我的群头像")
            arg.set(VELiveEditPage.DETAIL, this.myUrl)
            IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
              this.myUrl = popInfo.result as string
            })
          })
        }.width('100%')

        Text("确定")
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .backgroundColor('#5692ff')
          .borderRadius(6)
          .fontSize(30)
          .padding({ top: 8, bottom: 8 })
          .width('90%')
          .margin({ bottom: 80 })
          .onClick(() => {
            let map = this.arg as Map<string, string>;
            let cid = map.get("cid")
            if (cid) {
              this.startLiveRoom(cid, this.myNickName, this.myUrl)
            }
          })
      }
    }.hideTitleBar(true)
  }

  startLiveRoom(cid: string, nickName: string, url: string) {
    BIMUILog.debug(this.tag, `startLiveRoom cid: ${cid} nickName:${nickName} url: ${url}`)
    let arg = new Map<string, string>()
    arg.set("cid", cid)
    arg.set("name",nickName)
    arg.set("url",url)
    IMRouter.push(IMPage.LIVE_CHAT_ROOM_CONV_PAGE, arg, (popInfo) => {
    })
    IMRouter.pop()
  }
}

@Builder
function
veCreateJoinPageBuilder(arg: object) {
  VECreateJoinLiveGroupPage({ arg: arg as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_JOIN_CONV_INFO_PAGE, wrapBuilder(veCreateJoinPageBuilder))