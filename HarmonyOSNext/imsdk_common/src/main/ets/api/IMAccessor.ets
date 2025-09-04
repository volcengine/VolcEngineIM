import { IMDefaultLog } from './log/IMDefaultLog'
import { IMLogService } from './log/IMLogService'

//属性只读不要写
export class IMAccessor {
  public context:Context
  public appid: number = 0
  public did: string = ""
  public uid: bigint = 0n
  public isEnableApm: boolean = true
  public isEnableALog: boolean = true
  public versionCode: number = 0
  public versionName: string = ""
  public isBackground: boolean = true
  public isNetAvailable:boolean = true
  public env: number = 0
  public lane: string = ""
  public logger: IMLogService = new IMDefaultLog()
  public config: Record<string, string> = {}
  constructor(context:Context) {
    this.context = context
  }
}