import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { BIMUIClient } from '@imcloud/im_sdk_ui';
import { Constants } from './Constants';
import { VEIMAppSP } from '../../sp/VEIMAppSP';
import { VEEnvInfo } from '../../sp/VEEnvInfo';
import { common } from '@kit.AbilityKit';
import { filePreview } from '@kit.PreviewKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct VEDebugPage {
  private TAG: string = "INDebugPage";
  @State uid: string = "";
  @State selectEnv: number = Constants.ENV_RELEASE;
  @State swamLean: string = ""
  @State downloadUri: string = '';

  aboutToAppear(): void {
    this.init()
  }

  async init() {
    let env = await VEIMAppSP.getInstance().getEnv()
    if (env) {
      this.swamLean = env.lane
      this.selectEnv = env.env
    }
  }

  build() {
    NavDestination() {
      Column() {
        ActionBar({
          confirmClick: async () => {
            let env = new VEEnvInfo()
            env.env = this.selectEnv
            env.lane = this.swamLean
            await VEIMAppSP.getInstance().setEnv(env)
            IMRouter.pop()
          }
        })
        Row() {
          Radio({ value: 'release', group: 'radioGroup' })
            .checked(this.selectEnv == Constants.ENV_RELEASE)
            .height(24)
            .width(24)
          Text('线上环境')
        }.onClick(() => {
          this.selectEnv = Constants.ENV_RELEASE
          this.swamLean = ""
        })

        Row() {
          Radio({ value: 'ppe', group: 'radioGroup' })
            .height(24)
            .width(24)
            .checked(this.selectEnv == Constants.ENV_PPE)
          Text('ppe环境')
        }.onClick(() => {
          this.selectEnv = Constants.ENV_PPE

        })

        Row() {
          Radio({ value: 'boe', group: 'radioGroup' })
            .height(24)
            .width(24)
            .checked(this.selectEnv == Constants.ENV_BOE)
          Text('boe 环境')
        }.onClick(() => {
          this.selectEnv = Constants.ENV_BOE
        })

        Row() {
          Radio({ value: 'boei18n', group: 'radioGroup' })
            .height(24)
            .width(24)
            .checked(this.selectEnv == Constants.ENV_BOEi18n)
          Text('boe i18n 环境')
        }.onClick(() => {
          this.selectEnv = Constants.ENV_BOEi18n
        })


        Row() {
          Radio({ value: 'boei18n', group: 'radioGroup' })
            .height(24)
            .width(24)
            .checked(this.selectEnv == Constants.ENV_i18n)
          Text('i18n 环境')
        }.onClick(() => {
          this.selectEnv = Constants.ENV_i18n
        })
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

      TextInput({ text: $$this.swamLean, placeholder: "编辑泳道" }).fontSize(30).maxLines(1)
        .visibility(this.selectEnv != Constants.ENV_RELEASE ? Visibility.Visible : Visibility.None)
      Row() {
        Column() {
          Text('日志导出').fontSize(30).width('100%').backgroundColor(Color.Gray)
          Text(`debug日志导出: 终端执行命令直接从沙盒导出:hdc file recv /data/app/el2/100/base/com.bytedance.im/haps/entry/files/imlog`)
          Text('release日志导出,点击此按钮')
            .fontSize(20)
            .backgroundColor('#5692ff')
            .padding(8)
            .borderRadius(4)
            .onClick(async () => {
              this.downloadUri = await BIMUIClient.getInstance().downloadLog(getContext(this) as common.UIAbilityContext)
            })
          Text(`打开手机应用[文件管理], 点击[下载与接收->下载管理器], 查看xxx_imsdk.log`).visibility(this.downloadUri.length > 0 ? Visibility.Visible : Visibility.Hidden)
            .fontColor(Color.Green)
            .fontSize(15)

        }.width('100%').alignItems(HorizontalAlign.Start)
      }.height(60)
      .width('100%')
      .margin({
        top: 20
      })
    }.hideTitleBar(true)
  }
}

@Component
export struct ActionBar {
  confirmClick: () => void = () => {
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Image($r('app.media.icon_im_back_black'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ right: 16 })
        .onClick(() => {
          IMRouter.pop()
        })
        .margin({ left: 16 })
      Text("配置IM")
        .margin({
          left: 16
        }).fontSize(25)
        .fontColor('#222222')
      Text("确定")
        .margin({
          left: 16
        })
        .fontSize(25)
        .margin({ right: 16 })
        .fontColor('#ff33b5e5')
        .onClick(() => {
          this.confirmClick()
        })
    }.height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }
}

@Builder
function tobDebugBuilder() {
  VEDebugPage()
}

IMRouter.registerBuilder(IMPage.TOB_DEBUG, wrapBuilder(tobDebugBuilder))


