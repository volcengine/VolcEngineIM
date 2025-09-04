import { IMAccessor, IMEnvService, WSParameter } from '@imcloud/imsdk_common';

export class BIMEnvService implements IMEnvService {
  /**
   * 线上环境
   */
  static readonly ENV_RELEASE = 0;
  /**
   * ppe环境
   */
  static readonly ENV_PPE = 2;
  /**
   * boe环境
   */
  static readonly ENV_BOE = 3;
  /**
   * boe环境，不带泳道，跟 boe 的域名不同
   */
  static readonly ENV_BOEi18n = 4;
  /**
   * 海外环境
   */
  static readonly ENV_i18n = 5;
  /**
   * 默认环境
   * 国内 ENV_RELEASE
   * 海外 ENV_i18n
   */
  private env = BIMEnvService.ENV_RELEASE
  private lane = ""
  private appId = 0
  private static readonly HTTP_HOST = "https://imapi.volcvideo.com/";
  private static readonly HTTP_HOST_BOE = "https://imapi-boe.sinf.net/";
  private static readonly HTTP_HOST_BOE_i18n = ""; //http://imapi-boei18n.byted.org/
  private static readonly HTTP_HOST_i18n = "https://imapi.bytepluses.com/";

  initEnv(env: number, lane: string, appID: number): void {
    this.env = env
    this.lane = lane
    this.appId = appID
  }

  getEnv(): number {
    return this.env;
  }

  getHost(): string {
    let host: string = "";
    if (this.env == BIMEnvService.ENV_BOE) {
      host = BIMEnvService.HTTP_HOST_BOE;
    } else if (this.env == BIMEnvService.ENV_BOEi18n) {
      host = BIMEnvService.HTTP_HOST_BOE_i18n;
    } else if (this.env == BIMEnvService.ENV_i18n) {
      host = BIMEnvService.HTTP_HOST_i18n
    } else {
      host = BIMEnvService.HTTP_HOST //线上环境
    }
    return host;
  }

  getHeaderMap(): Map<string, string> {
    let map: Map<string, string> = new Map<string, string>();
    if (this.env == BIMEnvService.ENV_BOE) {
      map.set("x-use-boe", "1")
    } else if (this.env == BIMEnvService.ENV_PPE) {
      map.set("x-use-ppe", "1");
    }

    if (this.lane) {
      map.set("X-Tt-Env", this.lane);
    }
    return map;
  }

  getWSParameter(): WSParameter {
    return new WSParameter()
  }

  getWSHost(): string {
    return ""
  }

  onConfigReady(json: string): void {
  }

  init(context: Context, imAccessor: IMAccessor): void {

  }

  unInit(context: Context): void {
  }

  onLogin(context: Context, uid: bigint): void {
  }

  onLogout(): void {
  }
}