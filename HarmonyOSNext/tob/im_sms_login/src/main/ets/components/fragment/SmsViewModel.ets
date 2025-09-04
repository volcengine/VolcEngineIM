import { sendCodeResult, VESmsHttpClient } from '../../net/VESmsHttpClient'
import { SmsSpUtil } from '../../utils/SmsSpUtil'
import { promptAction } from '@kit.ArkUI'
import { VEIMTokenHelper } from '../../net/VETokenHttpClient'
import { BIMLoginListener } from '@imcloud/im_sdk_ui'
import { BIMSMSAccountProvider } from '../../BIMSMSAccountProvider'

export class SmsViewModel {
  phoneNumber: string = ""
  code: string = ""
  isAgree: boolean = false
  isAlreadyShowWarn: boolean = false
  uid: number = 0
  listener: BIMLoginListener | undefined

  constructor() {
    SmsSpUtil.getInstance().init(getContext())
    this.isAgree = SmsSpUtil.getInstance().getAgree()
    this.isAlreadyShowWarn = SmsSpUtil.getInstance().getIsShowWarn()
  }

  public init(listener: BIMLoginListener | undefined) {
    this.listener = listener
  }

  public async getSmsCode() {
    let result = await new VESmsHttpClient().sendCode(Number.parseInt(this.phoneNumber))
    if (result) {
      if (result?.message == "success") {
        //成功
        promptAction.showToast({ message: "请求验证码成功" })
      } else {
        //失败
        if (result?.data.description) {
          promptAction.showToast({ message: result.data.description })
        } else {
          promptAction.showToast({ message: "请求验证码失败" })
        }
      }
    } else {
      promptAction.showToast({ message: "请求验证码失败" })
    }
    return
  }

  public async checkCode(callback: (isSuccess: boolean) => void) {
    if (this.code && this.code.length > 0) {
      let result = await new VESmsHttpClient().loginAccount(Number.parseInt(this.phoneNumber), this.code)
      if (result) {
        if (result?.message == "success") {
          //成功
          let uid = result.data.user_id_str;
          promptAction.showToast({ message: "验证成功" })
          let token = await new VEIMTokenHelper(BIMSMSAccountProvider.env).getToken(BIMSMSAccountProvider.appId, uid)
          if (token) {
            await this.listener?.doLogin(uid, token)
            callback(true)
          } else {
            callback(false)
            promptAction.showToast({ message: "获取token失败" })
          }
        } else {
          //失败
          if (result?.data.description) {
            promptAction.showToast({ message: result.data.description })
          } else {
            promptAction.showToast({ message: "登录失败" })
          }
          callback(false)
        }
      } else {
        promptAction.showToast({ message: "登录失败" })
        callback(false)
      }
    } else {
      promptAction.showToast({ message: "登录失败" })
      callback(false)
    }
  }

  public onAgreeClick(isCheck: boolean) {
    SmsSpUtil.getInstance().setAgree(isCheck)
    this.isAgree = isCheck
  }

  public setAlreadyShowWarn(){
    SmsSpUtil.getInstance().setIsShowWarn(true)
  }
}