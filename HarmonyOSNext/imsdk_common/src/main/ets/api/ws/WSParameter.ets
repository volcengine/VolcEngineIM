import { List } from '@kit.ArkTS';

export class WSParameter {
  appid: number = 0
  token: string | undefined
  authType: number = 0 //token: 2 session:1 unknow:0
  xttToken: Map<string, string> = new Map()
  deviceId: string | undefined
  iid: string | undefined
  appKey: string = ""
  fpid: number = 0
  urls: List<string> = new List()
  method: number = 0
  serviceId: number = 0
  extra: Map<string, string> = new Map()

  toString(): string {
    let urlStr = ""
    if (this.urls.length > 0) {
      urlStr = this.urls[0]
    }
    return `{appid:${this.appid},token:${this.token},authType:${this.authType},xttToken:${this.xttToken},deviceId:${this.deviceId},iid:${this.iid},appKey:${this.appKey},fpid:${this.fpid},url:${urlStr},method:${this.method},extra:${this.extra}}`;
  }
}