import { ComponentContent, PromptAction, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

export class VEWarnDialog {
  private tag = "VEWarnDialog"
  private uiContext: UIContext
  private promptAction: PromptAction
  private contentNode: ComponentContent<WarnDialogListener>
  private isShowing = false

  constructor(uiContext: UIContext, p: WarnDialogListener) {
    this.uiContext = uiContext;
    this.promptAction = this.uiContext.getPromptAction()
    this.contentNode = new ComponentContent(this.uiContext, wrapBuilder(buildWarnText), p)
  }

  public show() {
    if (this.isShowing) {
      return
    }
    try {
      this.promptAction.openCustomDialog(this.contentNode, { autoCancel: false });
      this.isShowing = true
    } catch (error) {
      console.error(this.tag, `OpenCustomDialog args error code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }

  public close() {
    try {
      this.promptAction.closeCustomDialog(this.contentNode);
      this.isShowing = false
    } catch (error) {
      console.error(this.tag, `OpenCustomDialog args error code is ${(error as BusinessError).code}, message is ${(error as BusinessError).message}`);
    }
  }
}

export interface WarnDialogListener {
  onUrlCallback: (url: string) => void
  onAgreeCallback: (isAgree: boolean) => void
}

@Builder
function buildWarnText(param: WarnDialogListener) {
  Column() {
    Text('个人信息保护指引').fontSize(24).fontColor(Color.Black)
    Text("veIM是面向企业客户提供的一款体验火山引擎即时通讯服务的应用软件。\n" +
      "1. 我们遵循隐私政策收集、处理个人信息，但不会仅因您同意隐私政策而采取强制捆绑的方式收集信息。\n" +
      "2. 相机、相册、麦克风、存储等权限均不会默认开启，只有经过明示授权才会在实现特定功能或服务时使用，我们不会在功能或服务不需要时通过您授权的权限收集信息。\n" +
      "3. 为实现信息共享等目的所必需，我们可能会调用剪切板并使用与功能相关的最小必要信息。\n" +
      "4. 您所在组织可能会基于协作与管理需要，处理您的必要个人信息。")
      .fontSize(16)
      .fontColor(Color.Black)
      .textAlign(TextAlign.Start)
    Text() {
      Span("您可以查看完整版 ").fontSize(16)
      Span("用户协议").fontColor(Color.Blue).fontSize(16).onClick(() => {
        param.onUrlCallback('https://www.volcengine.com/docs/6348/975891')
      })
      Span(" 和 ").fontSize(16)
      Span("隐私政策").fontColor(Color.Blue).fontSize(16).onClick(() => {
        param.onUrlCallback('https://www.volcengine.com/docs/6348/975890')
      })
    }.margin({ top: 16 })

    Row() {
      Text("同意")
        .fontColor("#282828")
        .fontSize(20)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          param.onAgreeCallback(true)
        })
      Text("不同意")
        .fontColor("#282828")
        .fontSize(20)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          param.onAgreeCallback(false)
        })
    }.margin({ top: 16 })
  }.width('90%')
  .backgroundColor(Color.White)
  .padding(16)
  .borderRadius(6)

}
