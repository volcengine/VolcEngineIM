import { http } from '@kit.NetworkKit';
import buffer from '@ohos.buffer';

export class VESmsHttpClient {
  private TAG = "VESmsHttpClient"
  private baseUrl = "https://imapi-passport.volcvideo.com/"
  // 固定请求参数
  private autoRead = 0; // 是否发送google自动获取短信
  private loginType = 24; // 快速登录，如果没有注册，则注册新用户后登录.
  private unbindExist = 0; // 是否解绑现在的账号
  private mixMode = "1"; // 固定值
  private accountSDKSource = "app"; // 固定值
  private queryStr = "os=harmony_next&aid=6521&os_api=31&app_name=com.bytedance.im.veapp.VEIMApplication&language=zh&device_platform=android&device_brand=HUAWEI&channel=com.bytedance.im.veapp&os_version=12&device_type=ELS-AN00&device_id=&version_name=1.17.0&version_code=11700"

  public async sendCode(phoneNumber: number): Promise<sendCodeResult | undefined> {
    console.debug(this.TAG, `sendCode phoneNumber:${phoneNumber}`)
    let httpRequest = http.createHttp();
    let encryptPhoneNumber = this.encryptWithXor(phoneNumber.toString())
    let encryptLoginType = this.encryptWithXor(this.loginType.toString())
    let encryptUnbindExist = this.encryptWithXor(this.unbindExist.toString())
    //参数都写死了
    let url: string = `${this.baseUrl}passport/mobile/send_code/v1/?${this.queryStr}`;
    try {
      let result: http.HttpResponse = await httpRequest.request(url,
        {
          method: http.RequestMethod.POST,
          header: { 'content-Type': 'multipart/form-data' },
          multiFormDataList: [{
            name: "mobile",
            contentType: 'text/plain',
            data: encryptPhoneNumber,
          }, {
            name: "auto_read",
            contentType: 'text/plain',
            data: `${this.autoRead}`, // 可选，传入文件路径，自API 11开始支持该属性
          }, {
            name: "account_sdk_source",
            contentType: 'text/plain',
            data: `${this.accountSDKSource}`
          }, {
            name: "type",
            contentType: 'text/plain',
            data: encryptLoginType
          }, {
            name: "unbind_exist",
            contentType: 'text/plain',
            data: encryptUnbindExist
          }, {
            name: "mix_mode",
            contentType: 'text/plain',
            data: this.mixMode
          }]
        })
      let code = result.responseCode;
      let json = result.result
      console.debug(this.TAG, `sendCode response code:${code} data:${json}`)
      if (code == 200 && json) {
        let result: sendCodeResult = JSON.parse(json.toString()) as sendCodeResult;
        console.debug(this.TAG, `sendCode response  result:${JSON.stringify(result)}`)
        return result
      } else {
        console.debug(this.TAG, `sendCode response failed code :${code}`)
        return undefined
      }
    } catch (e) {
      console.debug(this.TAG, `sendCode response  :${e}`)
      return undefined
    }
  }

  public async loginAccount(phoneNumber: number, code: string): Promise<LoginAccountResult | undefined> {
    console.debug(this.TAG, `loginAccount phoneNumber:${phoneNumber} code:${code}`)

    let httpRequest = http.createHttp();
    let encryptPhoneNumber = this.encryptWithXor(phoneNumber.toString())
    let encryptCode = this.encryptWithXor(code)
    //参数都写死了
    let url: string = `${this.baseUrl}passport/mobile/sms_login/?${this.queryStr}`;

    try {
      let result: http.HttpResponse = await httpRequest.request(url,
        {
          method: http.RequestMethod.POST,
          header: { 'content-Type': 'multipart/form-data' },
          multiFormDataList: [{
            name: "mobile",
            contentType: 'text/plain',
            data: encryptPhoneNumber,
          }, {
            name: "code",
            contentType: 'text/plain',
            data: encryptCode,
          }, {
            name: "account_sdk_source",
            contentType: 'text/plain',
            data: `${this.accountSDKSource}`
          }, {
            name: "mix_mode",
            contentType: 'text/plain',
            data: this.mixMode
          }]
        })
      let code = result.responseCode;
      let json = result.result
      console.debug(this.TAG, `loginAccount response code:${code} data:${json}`)
      if (code == 200 && json) {
        let result: LoginAccountResult = JSON.parse(json.toString()) as LoginAccountResult;
        console.debug(this.TAG, `loginAccount response  result:${JSON.stringify(result)}`)
        return result
      } else {
        console.debug(this.TAG, `loginAccount response failed code :${code}`)
        return undefined
      }
    } catch (e) {
      console.debug(this.TAG, `sendCode response  :${e}`)
      return undefined
    }
  }


  private encryptWithXor(normalCode: string): string {
    if (!normalCode) {
      return ""
    }
    let XOR_MASK = 0x5;
    let array: Uint8Array = new Uint8Array(buffer.from(normalCode, 'utf-8').buffer)
    for (let i = 0; i < array.length; i++) {
      array[i] ^= XOR_MASK
    }
    return this.toHexString(array, 0, array.length)
  }

  private toHexString(array: Uint8Array, off: number, len: number): string {
    let STRING_MASK_FF = 0xff
    let STRING_MASK_F = 0x0f
    let MAX_STRING = 4
    let HEX_CHARS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
    let chars: string[] = []
    for (let i = 0; i < len; i++) {
      let v = array[i+off] & STRING_MASK_FF
      chars.push(HEX_CHARS[v>>MAX_STRING])
      chars.push(HEX_CHARS[v&STRING_MASK_F])
    }
    return chars.reduce((pre, cur, index, array) => {
      return `${pre}${cur}`
    }, "")
  }
}

export class sendCodeResult {
  data: CodeData = new CodeData()
  message: string = ""
}

export class CodeData {
  log_id: string = ""
  mobile: string = ""
  mobile_ticket: string = ""
  retry_time: number = 0
  captcha: string = ""
  desc_url: string = ""
  description: string = ""
  error_code: number = 0
}

export class LoginAccountResult {
  data: AccountData = new AccountData()
  message: string = ""
}

export class AccountData {
  app_id: number = 0
  user_id_str: string = ""
  avatar_url: string = ""
  name: string = ""
  phone_collected: boolean = false
  captcha: string = ""
  desc_url: string = ""
  description: string = ""
  error_code: number = 0
}