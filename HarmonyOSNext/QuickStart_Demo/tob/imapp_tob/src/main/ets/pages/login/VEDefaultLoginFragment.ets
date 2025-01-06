import { BIMLoginListener } from "@imcloud/im_sdk_ui"
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { VEIMAppConst } from "../../const/VEIMAppConst"
import { VEIMAppSP } from "../../sp/VEIMAppSP"


@Component
struct VEDefaultLoginFragment {
  private listener: BIMLoginListener | undefined
  @State uid: string = VEIMAppConst.uid
  @State token: string = VEIMAppConst.token
  @State appId: number = VEIMAppConst.APP_ID
  @State isAgree: boolean = false

  aboutToAppear(): void {
    this.isAgree = VEIMAppSP.getInstance().getAgree()
    if (this.isAgree) {
      this.listener?.onProtoAgree()
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      Text('欢迎登录 IM Demo').fontSize(22).margin({ top: 60, left: 16 })
      Column() {
        Text(`APPID:${this.appId}`)
        Text(`用户ID:${this.uid}`)
        Text(`token:${this.token}`)
      }.margin({ left: 16 })
      .alignItems(HorizontalAlign.Start)

      Column() {
        Row() {
          Checkbox().select(this.isAgree).onChange((value)=>{
            this.isAgree = value;
            if (this.isAgree) {
              this.listener?.onProtoAgree()
            }
          })
          Text() {
            Span("已阅读并同意 ")
            Span("用户协议").fontColor(Color.Blue).onClick(() => {
              this.startWebView(getContext() as common.UIAbilityContext, 'https://www.volcengine.com/docs/6348/975891')
            })
            Span(" 和 ")
            Span("隐私政策").fontColor(Color.Blue).onClick(() => {
              this.startWebView(getContext() as common.UIAbilityContext, 'https://www.volcengine.com/docs/6348/975890')
            })
          }
        }.onClick(() => {
          VEIMAppSP.getInstance().setAgree(true)
          this.isAgree = true
          this.listener?.onProtoAgree()
        })

        Text("登录")
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .backgroundColor('#5692ff')
          .borderRadius(6)
          .fontSize(30)
          .padding({ top: 8, bottom: 8 })
          .width('80%')
          .margin({ top: 30 })
          .onClick(() => {
            this.listener?.doLogin(this.uid, this.token)
          })
      }.alignItems(HorizontalAlign.Center)
      .width('100%')
      .margin({ bottom: 80 })
    }
  }

  private startWebView(context: common.UIAbilityContext, uri: string) {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: uri
    };
    context.startAbility(want)
      .then(() => {
        console.error('Start browsableAbility successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      });
  }
}

@Builder
export function buildDefaultLoginFragment(l: BIMLoginListener) {
  VEDefaultLoginFragment({ listener: l })
}