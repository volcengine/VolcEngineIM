import { BIMAccountProvider, BIMLoginListener } from '@imcloud/im_sdk_ui';
import { buildVESmsLoginFragment } from './components/fragment/VESmsLoginFragment';
import { SmsSpUtil } from './utils/SmsSpUtil';

export class BIMSMSAccountProvider implements BIMAccountProvider {
  logout(): void {
    SmsSpUtil.getInstance().setAgree(false)
  }

  public static appId: number = 0
  public static env: number = 0

  init(context: Context, appId: number, env: number): void {
    BIMSMSAccountProvider.appId = 666675;//验证码登录，appid固定为666675
    BIMSMSAccountProvider.env = env
  }

  createLoginFragment(): WrappedBuilder<[BIMLoginListener]> {
    return wrapBuilder(buildVESmsLoginFragment)
  }
}