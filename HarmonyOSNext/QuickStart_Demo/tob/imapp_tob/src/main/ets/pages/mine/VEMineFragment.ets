import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VEMineViewModel } from './VEMineViewModel'
import { BIMConnectStatus, BIMErrorCode } from '@imcloud/imsdk'
import { IMRouter } from '@imcloud/imapp_router'
import { promptAction } from '@kit.ArkUI'
import { VEIMAppSP } from '../../sp/VEIMAppSP'
import { VETokenInfo } from '../../sp/VETokenInfo'

@Component
export struct VEMineFragment {
  @State viewModel: VEMineViewModel = new VEMineViewModel()

  aboutToAppear(): void {
    BIMUIClient.getInstance().addConnectListener({
      onConnectStatusChanged: (status: BIMConnectStatus): void => {
        this.viewModel.onConnectStatusChange(status)
      },
      onTokenInvalid: (code: BIMErrorCode): void => {
        promptAction.showToast({ message: "token 已过期" })
        this.viewModel.logOut()
        let map = new Map<string, string>()
        map.set("reason", "tokenInvalid")
        IMRouter.pop(map)
      }
    })
  }

  build() {
    Column() {
      //head
      Row() {
        Image(this.viewModel.user.portraitUrl)
          .width(64)
          .height(64)
          .objectFit(ImageFit.Contain)
        Column() {
          Text(this.viewModel.user.nickName).fontSize(20).fontColor('#222222')
          Text(`${this.viewModel.user.uid}`).fontSize(16).fontColor('#999999')
        }.margin({ left: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(140)
      .padding({
        left: 16,
        right: 16,
      })
      .margin({ top: BIMUIClient.getInstance().getStatusHeight() })

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("AppId").fontColor('#222222').fontSize(16)
        Text(`${this.viewModel.appID}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("App VersionName").fontColor('#222222').fontSize(16)
        Text(`${this.viewModel.appVersion}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("IMSDK VersionCode Name")
        Text(`${this.viewModel.version}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("Did")
        Text(`${this.viewModel.did}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("长连接状态")
        Text(`${this.viewModel.connectStatus}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text("退出登录")
      }.margin({
        left: 16,
        right: 16
      }).height(60).onClick(async () => {
        this.viewModel.logOut()
        await VEIMAppSP.getInstance().setToken(undefined) //清空token缓存
        let map = new Map<string, string>()
        map.set("reason", "logout")
        IMRouter.pop(map)
      })

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Column() {
        Text(`env:${this.viewModel.env}`).fontColor(Color.Gray)
        Text(`uid:${this.viewModel.cacheToken?.uid}`).fontColor(Color.Gray)
      }.justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }.height('100%')
    .width('100%')
  }
}