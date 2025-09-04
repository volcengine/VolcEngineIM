import { VEUtils } from '../../utils/VEUtils'
import { common } from '@kit.AbilityKit'
import { VEWarnDialog, WarnDialogListener } from '../dialog/VEWarnDialog'
import { SmsViewModel } from './SmsViewModel'
import { BIMLoginListener } from '@imcloud/im_sdk_ui'
import { VESecondWarnDialog } from '../dialog/VESecondWarnDialog'
import { promptAction } from '@kit.ArkUI'
import { SmsSpUtil } from '../../utils/SmsSpUtil'

@Component
export struct VESmsLoginFragment {
  private warnDialog: VEWarnDialog | undefined
  private secondDialog: VESecondWarnDialog | undefined
  @State smsViewModel: SmsViewModel = new SmsViewModel()
  @State codeBtnColor: Color = Color.Gray
  private listener: BIMLoginListener | undefined
  private toDebugCount = 0
  @State reqCodeStr: string = "获取验证码"
  private static MAX_WAIT_TIMES = 60
  private intWaitTime = VESmsLoginFragment.MAX_WAIT_TIMES
  private isStop = false

  aboutToAppear(): void {
    this.smsViewModel.init(this.listener)
    if (!this.smsViewModel.isAgree && !this.smsViewModel.isAlreadyShowWarn) {
      this.showWarnDialog()
    }
    this.listener?.onProtoAgree(this.smsViewModel.isAgree)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_in_huoshan_im')).width(24).height(24).objectFit(ImageFit.Contain)
        Text("火山引擎即时通讯").fontSize(26).fontColor(Color.Black)
      }.alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ top: '30%' })
      .onClick(() => {
        this.toDebugCount++;
        if (this.toDebugCount == 3) {
          this.listener?.onDebugClick()
          this.toDebugCount = 0
        }
      })

      Row() {
        Text("+86").fontSize(20)
        TextInput({ text: this.smsViewModel.phoneNumber, placeholder: "请输入手机号" })
          .type(InputType.PhoneNumber)

          .maxLines(1)
          .fontSize(20)
          .placeholderFont({ size: 20 })
          .margin({ left: 8 })
          .layoutWeight(1)
          .onChange((value) => {
            this.codeBtnColor = value.length == 11 ? Color.Blue : Color.Gray
            this.smsViewModel.phoneNumber = value
          })
          .backgroundColor(Color.Transparent)
      }.margin({ left: 16, right: 16, top: 30 })

      Divider().color(Color.Gray).margin({ left: 16, right: 16 })
      Row() {
        TextInput({ text: this.smsViewModel.code, placeholder: "请输入验证码" })
          .type(InputType.Number)
          .layoutWeight(1)
          .maxLength(4)
          .fontSize(20)
          .placeholderFont({ size: 20 })
          .backgroundColor(Color.Transparent)
          .onChange((value) => {
            this.smsViewModel.code = value
          })
        Text(this.reqCodeStr)
          .fontSize(20)
          .margin({ left: 8 })
          .onClick(() => {
            this.smsViewModel.getSmsCode()
            this.isStop = false
            this.looperCount()
          })
          .fontColor(this.codeBtnColor)
          .enabled(this.codeBtnColor == Color.Blue)
      }.margin({ left: 16, right: 16, top: 30 })

      Divider().color(Color.Gray).margin({ left: 16, right: 16 })

      Row() {
        Checkbox().select(this.smsViewModel.isAgree).onChange((check) => {
          this.smsViewModel.onAgreeClick(check)
          this.listener?.onProtoAgree(check)
        })
        Text() {
          Span("已阅读并同意 ")
          Span("用户协议").fontColor(Color.Blue).onClick(() => {
            VEUtils.startBrowsableAbility(getContext() as common.UIAbilityContext, 'https://www.volcengine.com/docs/6348/975891')
          })
          Span(" 和 ")
          Span("隐私政策").fontColor(Color.Blue).onClick(() => {
            VEUtils.startBrowsableAbility(getContext() as common.UIAbilityContext, 'https://www.volcengine.com/docs/6348/975890')
          })
        }
      }.margin({ top: 30 })


      Text("登录")
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor('#5692ff')
        .borderRadius(6)
        .fontSize(30)
        .padding({ top: 8, bottom: 8 })
        .width('90%')
        .margin({ top: 30 })
        .onClick(() => {
          if (!this.smsViewModel.isAgree) {
            promptAction.showToast({ message: "请先同意协议" })
            return
          }
          if (this.smsViewModel.phoneNumber.toString().length == 0) {
            promptAction.showToast({ message: "手机号为空,请填写手机号" })
            return
          }
          if (this.smsViewModel.phoneNumber.toString().length != 11) {
            promptAction.showToast({ message: "手机号错误,请重新填写" })
            return
          }

          this.smsViewModel.checkCode((isSuccess) => {
            if (isSuccess) {
              this.smsViewModel.phoneNumber = ""
              this.smsViewModel.code = ""
              this.isStop = true
              this.smsViewModel.isAgree = false
              this.resetCountUI()
            }
          })
        })
    }.width('100%')
    .height('100%')
  }

  private looperCount() {
    this.reqCodeStr = `正在获取(${this.intWaitTime})`
    this.codeBtnColor = Color.Gray
    setTimeout(() => {
      if (!this.isStop) {
        this.looperCount()
        this.intWaitTime--
        if (this.intWaitTime == 0) {
          this.isStop = true
          this.resetCountUI()
        }
      } else {
        this.resetCountUI()
      }
    }, 1000)
  }

  private resetCountUI() {
    this.reqCodeStr = "获取验证码"
    this.intWaitTime = VESmsLoginFragment.MAX_WAIT_TIMES
    this.codeBtnColor = Color.Blue
  }

  private showWarnDialog() {
    let p: WarnDialogListener = {
      onUrlCallback: (url: string): void => {
        VEUtils.startBrowsableAbility(getContext(this) as common.UIAbilityContext, url)
      },
      onAgreeCallback: (isAgree: boolean): void => {
        this.warnDialog?.close()
        if (!isAgree) {
          this.secondDialog = new VESecondWarnDialog(this.getUIContext(), (isOk: boolean) => {
            this.secondDialog?.close()
            if (!isOk) {
              getContext(this).getApplicationContext().killAllProcesses() //不同意，则杀掉应用
            } else {
              this.smsViewModel.setAlreadyShowWarn()
            }
          })
          this.secondDialog.show()
        } else {
          this.smsViewModel.setAlreadyShowWarn()
        }
      }
    }
    this.warnDialog = new VEWarnDialog(this.getUIContext(), p)
    this.warnDialog.show()
  }
}

@Builder
export function buildVESmsLoginFragment(l: BIMLoginListener) {
  VESmsLoginFragment({ listener: l })
}
