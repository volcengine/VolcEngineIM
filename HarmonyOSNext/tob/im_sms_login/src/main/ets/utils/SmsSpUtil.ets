import { preferences } from '@kit.ArkData'

export class SmsSpUtil {
  private static readonly instance: SmsSpUtil = new SmsSpUtil()
  private sp: preferences.Preferences | undefined
  private static readonly KEY_AGREE = "key_agree"
  private static readonly KEY_WARN = "key_show_warn"

  private constructor() {

  }


  public static getInstance(): SmsSpUtil {
    return SmsSpUtil.instance
  }

  public init(context: Context) {
    let options: preferences.Options = { name: `imapp_tob_sms}` }
    this.sp = preferences.getPreferencesSync(getContext(), options)
  }

  public async setAgree(isAgree: boolean) {
    this.sp?.putSync(SmsSpUtil.KEY_AGREE, isAgree)
    await this.sp?.flush()
  }

  public getAgree(): boolean {
    let r = this.sp?.getSync(SmsSpUtil.KEY_AGREE, false) ?? false
    return r as boolean;
  }


  public async setIsShowWarn(isShow: boolean) {
    this.sp?.putSync(SmsSpUtil.KEY_WARN, isShow)
    await this.sp?.flush()
  }

  public getIsShowWarn(): boolean {
    let r = this.sp?.getSync(SmsSpUtil.KEY_WARN, false) ?? false
    return r as boolean;
  }
}