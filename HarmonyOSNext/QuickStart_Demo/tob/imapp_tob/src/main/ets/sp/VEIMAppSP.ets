import { preferences } from '@kit.ArkData';
import VEIMAppLog from '../log/VEIMAppLog';
import { VEEnvInfo } from './VEEnvInfo';
import { VETokenInfo } from './VETokenInfo';

export class VEIMAppSP {
  private TAG = "VEIMAppSP"
  private static instance: VEIMAppSP = new VEIMAppSP();
  private preferences: preferences.Preferences | null = null;
  private static KEY_TOKEN = "key_token"
  private static KEY_ENV = "key_env"
  private static KEY_AGREE = "key_agree_default"

  public static getInstance(): VEIMAppSP {
    return VEIMAppSP.instance
  }

  private constructor() {
  }

  public init(context: Context, appID: number) {
    VEIMAppLog.info(this.TAG, `init context:${context} appID:${appID}`)
    let options: preferences.Options = { name: `imapp_tob_${appID}` };
    this.preferences = preferences.getPreferencesSync(context, options);
  }

  public async setToken(tokenInfo: VETokenInfo | undefined): Promise<void> {
    try {
      if (tokenInfo) {
        let json = JSON.stringify(tokenInfo)
        VEIMAppLog.info(this.TAG, `setToken json:${json}`)
        this.preferences?.putSync(VEIMAppSP.KEY_TOKEN, json)
        await this.preferences?.flush() //异步
        VEIMAppLog.info(this.TAG, `setToken json:${json} success!`)
      } else {
        VEIMAppLog.info(this.TAG, `setToken clear!`)
        this.preferences?.putSync(VEIMAppSP.KEY_TOKEN, "")
        await this.preferences?.flush() //异步
      }
    } catch (e) {
      VEIMAppLog.info(this.TAG, `setToken json falied:${e}`)
    }
  }

  public getToken(): VETokenInfo | undefined {
    try {
      VEIMAppLog.info(this.TAG, `getToken start`)
      let json = this.preferences?.getSync(VEIMAppSP.KEY_TOKEN, "") ?? ""
      let tokenInfo: VETokenInfo = JSON.parse(json as string)
      VEIMAppLog.info(this.TAG, `getToken tokenInfo:${tokenInfo.uid} success!`)
      return tokenInfo;
    } catch (e) {
      VEIMAppLog.info(this.TAG, `getToken falied:${e}`)
      return undefined;
    }
  }

  public async setEnv(env: VEEnvInfo) {
    try {
      let json = JSON.stringify(env)
      VEIMAppLog.info(this.TAG, `setEnv json:${json}`)
      this.preferences?.putSync(VEIMAppSP.KEY_ENV, json)
      await this.preferences?.flush() //异步
      VEIMAppLog.info(this.TAG, `setEnv json:${json} success!`)
    } catch (e) {
      VEIMAppLog.info(this.TAG, `setEnv json falied:${e}`)
    }
  }

  public async getEnv(): Promise<VEEnvInfo | undefined> {
    try {
      VEIMAppLog.info(this.TAG, `getEnv start`)
      let json = this.preferences?.getSync(VEIMAppSP.KEY_ENV, "") ?? ""
      let envInfo: VEEnvInfo = JSON.parse(json as string)
      VEIMAppLog.info(this.TAG, `getEnv env:${envInfo.env} swamlean:${envInfo.lane} success!`)
      return envInfo;
    } catch (e) {
      VEIMAppLog.info(this.TAG, `getEnv falied:${e}`)
      return undefined;
    }
  }

  public async setAgree(isAgree: boolean) {
    this.preferences?.putSync(VEIMAppSP.KEY_AGREE, isAgree)
    await this.preferences?.flush()
  }

  public getAgree(): boolean {
    let r = this.preferences?.getSync(VEIMAppSP.KEY_AGREE, false) ?? false
    return r as boolean;
  }
}