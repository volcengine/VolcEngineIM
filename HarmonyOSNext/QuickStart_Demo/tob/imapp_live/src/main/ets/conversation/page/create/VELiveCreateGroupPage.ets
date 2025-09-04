import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMErrorCode, BIMGroupInfo } from '@imcloud/imsdk'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { BIMLiveActionBar } from '../../../widget/BIMLiveActionBar'
import { VELiveEditPage } from '../edit/VELiveEditPage'
import { LiveImageParamsItem } from './LiveImageParamsItem'
import { LiveTextParamsItem } from './LiveTextParamsItem'
import { promptAction } from '@kit.ArkUI'
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'

@Component
export struct VELiveCreateGroupPage {
  private tag = "LiveCreate"
  arg: Map<string, string> = new Map()
  static RESULT = "result"
  static CID = "cid"
  @State convName: string = "未命名直播群"
  @State convDesc: string = "未设置"
  @State convNotice: string = "未设置"
  @State url: string = ""

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Column() {
          BIMLiveActionBar({ title: "创建直播群" })
          Divider().width('100%').height(2)
          LiveTextParamsItem({ title: "直播群名称", detail: this.convName })
            .onClick(() => {
              let arg = new Map<string, string>()
              arg.set(VELiveEditPage.TITLE, "直播群名称")
              arg.set(VELiveEditPage.DETAIL, this.convName)
              IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
                this.convName = popInfo.result as string
              })
            })
          LiveImageParamsItem({ title: "直播群头像", url: this.url }).onClick(() => {
            let arg = new Map<string, string>()
            arg.set(VELiveEditPage.TITLE, "直播群头像")
            arg.set(VELiveEditPage.DETAIL, this.url)
            IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
              this.url = popInfo.result as string
            })
          })
          LiveTextParamsItem({ title: "直播群描述", detail: this.convDesc }).onClick(() => {
            let arg = new Map<string, string>()
            arg.set(VELiveEditPage.TITLE, "直播群描述")
            arg.set(VELiveEditPage.DETAIL, this.convDesc)
            IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
              this.convDesc = popInfo.result as string
            })
          })
          LiveTextParamsItem({ title: "直播群公告", detail: this.convNotice }).onClick(() => {
            let arg = new Map<string, string>()
            arg.set(VELiveEditPage.TITLE, "直播群公告")
            arg.set(VELiveEditPage.DETAIL, this.convNotice)
            IMRouter.push(IMPage.LIVE_EDIT_TEXT_PAGE, arg, (popInfo) => {
              this.convNotice = popInfo.result as string
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
            this.createLiveGroup()
          })
      }

    }.hideTitleBar(true)
  }

  async createLiveGroup() {
    let info = new BIMGroupInfo()
    info.name = this.convName
    info.avatarUrl = this.url
    info.desc = this.convDesc
    info.notice = this.convNotice
    let ext = new Map<string, string>()
    ext.set("qinConvKey", "qinConvValue")
    info.map = ext
    let r = await BIMUIClient.getInstance().getLiveService()?.createLiveGroup(info)
    let map = new Map<string, string>()
    if (r?.code == BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: "创建直播群成功" })
      let conv = r.data
      if(conv){
        let cid = conv.getConversationId()
        BIMUILog.debug(this.tag,`createLiveGroup success cid: ${r.data?.getConversationId()} name:${conv.getName()} notice:${conv.getNotice()} desc:${conv.getDescription()}`)
        map.set(VELiveCreateGroupPage.RESULT, "true")
        this.startJoinEditPage(cid)
      }
    } else {
      map.set(VELiveCreateGroupPage.RESULT, "false")
      promptAction.showToast({ message: "创建直播群失败" })
      IMRouter.pop(map)
    }
  }

  startJoinEditPage(cid: string) {
    BIMUILog.debug(this.tag, `startJoinEditPage cid: ${cid}`)
    let arg = new Map<string, string>()
    arg.set("cid", cid)
    IMRouter.push(IMPage.LIVE_JOIN_CONV_INFO_PAGE, arg)
    IMRouter.pop()
  }
}


@Builder
function veLiveCreatePageBuilder(arg: object) {
  VELiveCreateGroupPage({ arg: arg as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_CREATE_CONV_PAGE, wrapBuilder(veLiveCreatePageBuilder))