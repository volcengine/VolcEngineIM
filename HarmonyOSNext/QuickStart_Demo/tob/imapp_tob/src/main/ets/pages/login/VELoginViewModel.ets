import { BIMUIClient } from '@imcloud/im_sdk_ui';
import { VEIMAppConst } from '../../const/VEIMAppConst';
import VEIMAppLog from '../../log/VEIMAppLog';
import { VEIMAppSP } from '../../sp/VEIMAppSP';
import { BIMSDKConfig } from '@imcloud/imsdk';
import { BIMUSerProvider } from '../../user/IMINUSerProvider';
import { VETokenInfo } from '../../sp/VETokenInfo';

export class VELoginViewModel {
  private TAG = "VELoginViewModel"

  //使用缓存登录
  async loginWithCache(): Promise<boolean> {
    let cacheToken = VEIMAppSP.getInstance().getToken();
    VEIMAppLog.info(this.TAG, `loginWithCache uid:${cacheToken?.uid} token:${cacheToken?.token}`)
    let loginSuccess = false;
    if (cacheToken) {
      loginSuccess = await this.loginIM(VEIMAppConst.APP_ID, cacheToken.uid, cacheToken.token)
    }
    return loginSuccess;
  }

  public async loginIM(appid: number, uid: string, token: string): Promise<boolean> {
    let envInfo = await VEIMAppSP.getInstance().getEnv()
    console.debug(this.TAG, `loginIM appid:${appid} uid:${uid} token:${token} env:${envInfo?.env} swamLena:${envInfo?.lane}`)
    // 初始化imsdk
    let env = envInfo?.env ?? 0
    let swamLean = envInfo?.lane ?? ""
    VEIMAppLog.info(this.TAG, `initIMSDK env:${env} swamLean:${swamLean}`)
    await BIMUIClient.getInstance().init(getContext(), VEIMAppConst.APP_ID, new BIMSDKConfig(), env, swamLean) //初始化
    BIMUIClient.getInstance().setUserProvider(new BIMUSerProvider()) //设置用户信息
    BIMUIClient.getInstance().fullScreen()
    //登录
    VEIMAppLog.info(this.TAG, `loginIMSDK appid:${appid} uid:${uid} token:${token} env:${env} swamLean:${swamLean}`)
    let isSuccess = await BIMUIClient.getInstance().login(uid, token)
    if (isSuccess) {
      VEIMAppSP.getInstance().setToken(new VETokenInfo(uid.toString(), token))
    }
    return isSuccess
  }
}