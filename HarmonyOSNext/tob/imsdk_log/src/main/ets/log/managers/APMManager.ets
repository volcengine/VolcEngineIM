import { IMAccessor, IMDeviceInfo } from '@imcloud/imsdk_common';
import { Config, MonitorCrash } from '@volcengine/apmplus_crash_lite';
import BuildProfile from '../../../../../BuildProfile';
import { BIMLogService } from '../BIMLogService';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppenderTypeEnum, FileAppender, Level, Logger, LogManager } from '@pie/log4a';

export class APMManager {
  // aid和tonken在ApmPlus平台获取
  private readonly AID_ONLINE = '520458';
  private readonly TOKEN_ONLINE = '9b115f5ab9a044e985557db5f42191de';
  private readonly CHANNEL = 'channel';
  private deviceInfo: IMDeviceInfo | undefined
  private imAccessor: IMAccessor | undefined
  private log4a: Logger | undefined

  public init(context: Context, imAccessor: IMAccessor, deviceInfo: IMDeviceInfo) {
    console.debug(`APMManager init`)

    this.deviceInfo = deviceInfo
    this.imAccessor = imAccessor
    this.initLogPrintFile(context, imAccessor) //日志写到文件
    let config: Config.Config = Config.sdk(this.AID_ONLINE, this.TOKEN_ONLINE)
      .channel(this.CHANNEL)
      .versionName(BuildProfile.HAR_VERSION)
      .versionCode(123)
      .dynamicParams({
        // 可选
        getDeviceId: () => {
          return this.deviceInfo?.did ?? ""; // 可选
        },
        getUserId: () => {
          return `${this.imAccessor?.uid}`; // 可选
        }
      })
      .keyWords(['.'])// 堆栈过滤关键字，缺省不上报崩溃数据
      .soList(['so'])// so过滤关，缺省不上报崩溃数据
        // .url(URL_BOE)   // 私部地址
        // .debug(true)  // 打印日志
      .autoStart(true)// 是否在初始化同时自动开启监控
      .build();
    MonitorCrash.init(context, config);
  }


  private initLogPrintFile(context: Context, imAccessor: IMAccessor) {
    LogManager.setLogFilePath(`${context.filesDir}/imlog`)
    this.log4a = LogManager.getLogger(context);
    const curDate = new Date();
    const year = curDate.getFullYear()
    const month = curDate.getMonth() + 1
    const day = curDate.getDate()
    const dateStr = `${year}_${month}_${day}`
    console.debug(`qinxue date:${dateStr}`)
    const logFileName = `${dateStr}_${imAccessor.appid}_${imAccessor.versionCode}_imsdk.log`
    this.log4a.bindAppender(new FileAppender(
      logFileName, "imlog", Level.ALL, {
      useWorker: true, //多线程打印
      maxCacheCount: 7, //每天一个日志，最多7天
    }
    )).removeAppenderByType(AppenderTypeEnum.CONSOLE)
  }

  public log(level: number, tag: string, content: string) {
    const logContent = `[imsdk] ${tag} -> ${content}`
    // if (BuildProfile.DEBUG) {
      hilog.info(0xFF00, "[imsdk]", `${tag} -> ${content}`)
    // }
    if (level == BIMLogService.level_debug) {
      this.log4a?.debug(logContent)
    } else if (level == BIMLogService.level_info) {
      this.log4a?.info(logContent)
    } else if (level == BIMLogService.level_warn) {
      this.log4a?.info(logContent)
    } else if (level == BIMLogService.level_error) {
      this.log4a?.error(logContent)
    }
  }
}