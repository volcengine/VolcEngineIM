import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VEMineViewModel } from './VEMineViewModel'
import { BIMConnectStatus, BIMErrorCode } from '@imcloud/imsdk'
import { IMRouter } from '@imcloud/imapp_router'
import { promptAction } from '@kit.ArkUI'
import { VEIMAppSP } from '../../sp/VEIMAppSP'
import { common, Want } from '@kit.AbilityKit'
import { BusinessError, pasteboard } from '@kit.BasicServicesKit'
import { Constants } from '../debug/Constants'
import { VEIMAppConst } from '../../const/VEIMAppConst'

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
        .gesture(LongPressGesture().onAction(() => {
          this.copyText(`${this.viewModel.user.uid}`)
        }))
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
      }).height(60).gesture(LongPressGesture().onAction(() => {
        this.copyText(`${this.viewModel.did}`)
      }))

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("长连接状态")
        Text(`${this.viewModel.connectStatus}`).fontColor('#999999').fontSize(14)
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("隐私政策")
        Image($r('app.media.icon_im_goto')).width(16).height(16).objectFit(ImageFit.Contain)
      }.margin({
        left: 16,
        right: 16
      }).height(60)
      .onClick(() => {
        this.toProtocol("https://www.volcengine.com/docs/6348/975890")
      })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("权限清单")
        Image($r('app.media.icon_im_goto')).width(16).height(16).objectFit(ImageFit.Contain)
      }.margin({
        left: 16,
        right: 16
      }).height(60)
      .onClick(() => {
        this.toProtocol("https://www.volcengine.com/docs/6348/975909")
      })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text("ICP备案号：京ICP备20018813号-193A")
        Image($r('app.media.icon_im_goto')).width(16).height(16).objectFit(ImageFit.Contain)
      }.margin({
        left: 16,
        right: 16
      }).height(60)
      .onClick(() => {
        this.toProtocol("https://beian.miit.gov.cn/#/Integrated/index")
      })

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text("退出登录")
      }.margin({
        left: 16,
        right: 16
      }).height(60).onClick(async () => {
        this.viewModel.logOut()
        await VEIMAppSP.getInstance().setToken(undefined) //清空token缓存
        VEIMAppSP.getInstance().setAgree(false) //不在同意协议
        VEIMAppConst.provider.logout()
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

  toProtocol(protocol: string) {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: protocol
    };
    (getContext() as common.UIAbilityContext).startAbility(want)
      .then(() => {
        console.error('Start browsableAbility successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      });
  }

  copyText(text: string) {
    const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    const systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
    systemPasteboard.getData().then((data) => {
      if (data) {
        promptAction.showToast({ message: `已复制: ${text}` });
      } else {
        promptAction.showToast({ message: '复制失败' });
      }
    })
  }
}