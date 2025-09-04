import { TTNetTobInit, ApiRequestMonitorHook } from '@bytedance/ttnet'

export class TTUploaderUtil {

  // sdk init
  private static mSDKInit: boolean = false;
  public static init(context: Context): void {
    if (!TTUploaderUtil.mSDKInit) {
      TTNetTobInit.initTTNet(true, null, false, context);
    }
    TTUploaderUtil.mSDKInit = true;
  }

  // switch native log
  private static mEnableNativeLog: number = 0;
  public static setEnableNativeLog(abc: number): void {
    TTUploaderUtil.mEnableNativeLog = abc;
  }
  public static getEnableNativeLog(): number {
    return TTUploaderUtil.mEnableNativeLog;
  }
}