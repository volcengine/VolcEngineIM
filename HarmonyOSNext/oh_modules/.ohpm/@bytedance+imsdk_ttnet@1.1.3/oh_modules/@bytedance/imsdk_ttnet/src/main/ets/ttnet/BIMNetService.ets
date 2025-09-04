import { IMNetService } from '@imcloud/imsdk_common';
import { IMAccessor } from '@imcloud/imsdk_common';
import { Header, HttpMethod, Request, RequestBuilder, ResponseBodyType, TTNetTobInit, TTNetworkUtils } from '@bytedance/ttnet';
import List from '@ohos.util.List';
import { IMResponse } from '@imcloud/imsdk_common';
import { IMRequest } from '@imcloud/imsdk_common';
import { IMNetError } from '@imcloud/imsdk_common';
import { TTApiRequestMonitorImpl } from './TTApiRequestMonitorImpl';

export class BIMNetService implements IMNetService {

  constructor() {

  }

  async postHttp(imRequest: IMRequest): Promise<IMResponse> {
    let headList = new List<Header>();
    let headMap = imRequest.map;
    headMap.forEach((value, key) => {
      headList.add(new Header(key, value))
    })
    let url = `${imRequest.host}${imRequest.path}`
    console.info('start http post');
    let request:Request = new RequestBuilder(url)
      .requestMethod(HttpMethod.POST)
      .responseBodyType(ResponseBodyType.ARRAYBUFFER)
      .postRequestBody(imRequest.body)
      .requestHeaders(headList)
      .build();
    // 构造请求call
    // 传入响应类型为string，返回的body为string类型
    // 内部网络异常等场景会走到catch错误处理
    try {
      let call = TTNetworkUtils.createDefaultClient()?.newHttpCall(request)
      if (call) {
        let response = await call.execute();
        url = response.getUrl();
        let data = (response.getBody()) as ArrayBuffer;
        let code = response.getHttpStatusCode()
        let netError = new IMNetError("", code, response.getLogId(), "")
        return new IMResponse(url, data, netError, code)
      } else {
        throw new Error("call is null")
      }
    } catch (e) {
      throw new Error(e)
    }
  }

  onConfigReady(json: string): void {
  }
  init(context: Context, imAccessor: IMAccessor): void {
    /**
     * 1、防抓包
     * 2、日志回调
     * 3、cookie
     */
    TTNetTobInit.initTTNet(false, new TTApiRequestMonitorImpl(), false, context);
  }

  unInit(context: Context): void {
  }

  onLogin(context: Context, uid: bigint): void {
  }

  onLogout(): void {
  }
}