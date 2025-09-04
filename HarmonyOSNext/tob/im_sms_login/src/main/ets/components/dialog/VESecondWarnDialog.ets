import { ComponentContent, PromptAction, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

export class VESecondWarnDialog {
  private tag = "VESecondDialog"
  private uiContext: UIContext
  private promptAction: PromptAction
  private contentNode: ComponentContent<(isOk: boolean) => void>
  private isShowing = false

  constructor(uiContext: UIContext, p: (isOk: boolean) => void) {
    this.uiContext = uiContext;
    this.promptAction = this.uiContext.getPromptAction()
    this.contentNode = new ComponentContent(this.uiContext, wrapBuilder(buildSecondText), p)
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

@Builder
function buildSecondText(param: (isOk: boolean) => void) {
  Column() {
    Text('同意用户协议和隐私政策后，veIM 才能为您提供服务。').fontSize(20).fontColor(Color.Black)
    Row() {
      Text("同意并继续")
        .fontColor("#282828")
        .fontSize(20)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          param(true)
        })
      Text("不同意并退出")
        .fontColor("#282828")
        .fontSize(20)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          param(false)
        })
    }.margin({ top: 16 })
  }.width('90%')
  .backgroundColor(Color.White)
  .padding(16)
  .borderRadius(6)

}
