import { ApiRequestMonitorHook, HttpRequestInfo } from "@bytedance/ttnet";

export class TTApiRequestMonitorImpl extends ApiRequestMonitorHook{
  monitorApiOk(info: HttpRequestInfo) {

  }

  monitorApiError(error: HttpRequestInfo) {
  }
}