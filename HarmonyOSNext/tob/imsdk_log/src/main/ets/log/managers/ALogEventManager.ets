import { IMAccessor, IMDeviceInfo, IMLogService } from '@imcloud/imsdk_common';
import { AppLog, createByDomain, InitConfig, Topic, TopicParam } from '@volcengine/applog';
import { ValueType } from '@kit.ArkData';

export class ALogEventManager {
  private imAccessor: IMAccessor | undefined
  private appLog: AppLog | undefined
  private logger: IMLogService | undefined
  private static deviceInfo: IMDeviceInfo | undefined

  public init(context: Context, imAccessor: IMAccessor, didReadyCallback: (deviceInfo: IMDeviceInfo) => void) {
    this.log("init()")
    this.imAccessor = imAccessor
    this.logger = imAccessor.logger
    this.appLog = new AppLog()
    let config:InitConfig = new InitConfig("20001623", "channel")
      .setLogEnabled(false)
      .setUri(createByDomain("https://gator.volces.com"))
    this.appLog.init(context, config)
    this.log("appLog init()")
    if (!ALogEventManager.deviceInfo) {
      this.appLog.topicReceiver()?.on(Topic.DidReady, (info: TopicParam) => {
        this.log(`callback did DidReady:${JSON.stringify(info)}`)
        let did = (info["bd_did"] ?? "") as string
        let iid = (info["install_id"] ?? "") as string
        ALogEventManager.deviceInfo = new IMDeviceInfo(did, iid)
        didReadyCallback(ALogEventManager.deviceInfo)
      })
    }
    this.appLog.start()
    if (ALogEventManager.deviceInfo) {
      this.log(`callback did by cache:${JSON.stringify(ALogEventManager.deviceInfo)}`)
      didReadyCallback(ALogEventManager.deviceInfo)
    }
    this.log("appLog start()")
  }

  public onEvent(event: string, data: Record<string, ValueType>) {
    this.logger?.log(IMLogService.level_info, "ALogEventManager", `event:${event} data:${JSON.stringify(data)}`)
    this.appLog?.event(event, data)
  }


  public setUid(uid: bigint) {
    this.appLog?.user()?.setUserUniqueID(uid.toString())
  }

  public log(content: string) {
    this.logger?.log(IMLogService.level_info, "ALogEventManager", content)
    console.log(`ALogEventManager ${content}`)
  }
}