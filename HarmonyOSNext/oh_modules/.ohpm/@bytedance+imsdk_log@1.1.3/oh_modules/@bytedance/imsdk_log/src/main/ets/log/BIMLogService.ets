import { IMAccessor, IMDeviceInfo, IMLogService } from '@imcloud/imsdk_common';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ALogEventManager } from './managers/ALogEventManager';
import { APMManager } from './managers/APMManager';
import { ValueType } from '@ohos.data.ValuesBucket';
import { LogManager } from '@pie/log4a';
import BuildProfile from '../../../../BuildProfile';

export class BIMLogService extends IMLogService {
  private imAccessor: IMAccessor | undefined;
  private aLogEventManager: ALogEventManager
  private aApmManager: APMManager
  private tag: string = "BIMLogService"
  private deviceInfo: IMDeviceInfo | undefined
  private deviceCallbackList: ((deviceInfo: IMDeviceInfo) => void)[] = []

  constructor() {
    super();
    this.aLogEventManager = new ALogEventManager()
    this.aApmManager = new APMManager()
  }


  init(context: Context, imAccessor: IMAccessor): void {
    this.imAccessor = imAccessor;
    console.debug(this.tag, `init isEnableALog:${imAccessor.isEnableALog} isEnableApm:${imAccessor.isEnableApm}`)
    let uidStr = `${imAccessor.uid}`
    this.aApmManager.init(context, imAccessor, new IMDeviceInfo(uidStr, uidStr))

    if (imAccessor.isEnableALog) {
      this.aLogEventManager.init(context, imAccessor, (deviceInfo) => {
        console.debug(`${this.tag} init block deviceInfo did:${this.deviceInfo}`)
        this.deviceInfo = deviceInfo
        while (this.deviceCallbackList.length > 0) {
          let deviceCallback = this.deviceCallbackList.pop()
          if (deviceCallback) {
            console.debug(`${this.tag} deviceCallbackList callback did:${this.deviceInfo.did}`)
            deviceCallback(this.deviceInfo)
          }
        }
        if (imAccessor.isEnableApm) {
          this.aApmManager.init(context, imAccessor, deviceInfo)
        }
      })
    } else {
      if (imAccessor.isEnableApm) {
        const deviceInfo = new IMDeviceInfo(`${this.imAccessor.uid}`, `${this.imAccessor.uid}`); //使用兜底
        this.aApmManager.init(context, imAccessor, deviceInfo)
      }
    }
  }

  getDeviceInfo(callback: (deviceInfo: IMDeviceInfo) => void) {
    console.debug(`${this.tag} getDeviceInfo()`)
    if (this.deviceInfo) {
      console.debug(`${this.tag} immediately callback did:${this.deviceInfo.did}`)
      callback(this.deviceInfo)
    } else {
      this.deviceCallbackList.push(callback)
    }
  }

  onEvent(event: string, data: Record<string, ValueType>): void {
    this.aLogEventManager.onEvent(event, data)
  }

  log(level: number, tag: string, content: string): void {
    this.aApmManager.log(level, tag, content)
  }

  onLogin(context: Context, uid: bigint): void {
    this.aLogEventManager.setUid(uid)
  }

  onLogout(): void {
    LogManager.terminate()
  }
}
