import { http } from '@kit.NetworkKit';
import VEIMAppLog from '../log/VEIMAppLog';

export class VEIMTokenHelper {
  TAG: string = "VEIMTokenHelper"
  private static instance: VEIMTokenHelper = new VEIMTokenHelper();

  private constructor() {
  }

  static getInstance(): VEIMTokenHelper {
    return VEIMTokenHelper.instance
  }

  public async getToken(appID: number, uid: string): Promise<string | undefined> {
    VEIMAppLog.info(this.TAG, `getToken() sart appID:${appID}  uid:${uid}`)
    let httpRequest = http.createHttp();
    let url: string = `https://imcloud-admin.bytedance.net/get_token?userID=${uid}&appID=${appID}`;
    let result: http.HttpResponse = await httpRequest.request(url, { method: http.RequestMethod.GET })
    let code = result.responseCode;
    let data = result.result;
    if (code == http.ResponseCode.OK) {
      let tokenInfo = JSON.parse(data as string) as GetToken
      VEIMAppLog.info(this.TAG, `getToken() success appID:${appID}  uid:${uid} token:${tokenInfo.Token}`)
      return tokenInfo.Token;
    } else {
      VEIMAppLog.info(this.TAG, `getToken() failed appID:${appID}  uid:${uid} code:${code}`)
      return undefined
    }
  }
}

class GetToken {
  Token: string = "";
  BaseResp: BaseResp | null = null;
}

class BaseResp {
  StatusMessage: string = "";
  StatusCode: number = 0;
}