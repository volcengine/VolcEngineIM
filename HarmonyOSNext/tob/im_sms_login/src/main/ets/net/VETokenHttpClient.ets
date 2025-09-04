import { http } from '@kit.NetworkKit';

export class VEIMTokenHelper {
  private readonly TAG: string = "IMTokenHelper"
  public static readonly TOKEN_API = "https://imapi.volcvideo.com/imcloud/";
  public static readonly TOKEN_API_BOE = "https://imapi-boe.sinf.net/imcloud/";
  public static readonly TOKEN_API_I18N = "https://imapi.bytepluses.com/imcloud/";
  private baseUrl = VEIMTokenHelper.TOKEN_API
  /**
   * 线上环境
   */
  public static readonly ENV_RELEASE = 0;
  /**
   * ppe环境
   */
  public static readonly ENV_PPE = 2;
  /**
   * boe环境
   */
  public static readonly ENV_BOE = 3;
  /**
   * boe环境，不带泳道，跟 boe 的域名不同
   */
  public static readonly ENV_BOEi18n = 4;
  /**
   * 海外环境
   */
  public static readonly ENV_i18n = 5;

  constructor(env: number) {
    if (env == VEIMTokenHelper.ENV_BOE) {
      this.baseUrl = VEIMTokenHelper.TOKEN_API_BOE;
    } else if (env == VEIMTokenHelper.ENV_i18n) {
      this.baseUrl = VEIMTokenHelper.TOKEN_API_I18N;
    } else if (env == VEIMTokenHelper.ENV_PPE) {
      this.baseUrl = VEIMTokenHelper.TOKEN_API;
    } else {
      this.baseUrl = VEIMTokenHelper.TOKEN_API;
    }
  }

  public async getToken(appID: number, uid: string): Promise<string | undefined> {
    console.info(this.TAG, `getToken() sart appID:${appID}  uid:${uid}`)
    let httpRequest = http.createHttp();
    let url: string = `${this.baseUrl}get_token?userID=${uid}&appID=${appID}`;
    let result: http.HttpResponse = await httpRequest.request(url, { method: http.RequestMethod.GET })
    let code = result.responseCode;
    let data = result.result;
    console.info(this.TAG, `getToken() code:${code}  data:${JSON.stringify(data)}`)
    if (code == http.ResponseCode.OK) {
      let tokenInfo = JSON.parse(data as string) as GetToken
      console.info(this.TAG, `getToken() success appID:${appID}  uid:${uid} token:${tokenInfo.Token}`)
      return tokenInfo.Token;
    } else {
      console.info(this.TAG, `getToken() failed appID:${appID}  uid:${uid} code:${code}`)
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