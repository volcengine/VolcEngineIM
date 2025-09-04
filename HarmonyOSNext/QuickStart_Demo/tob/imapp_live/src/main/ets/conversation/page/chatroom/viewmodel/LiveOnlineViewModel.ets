import { BIMErrorCode } from "@imcloud/imsdk"
import { BIMUIClient } from "@imcloud/im_sdk_ui"
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog"

@Observed
export class LiveOnlineViewModel {
  private tag = "LiveOnlineViewModel"
  private interval = 2000
  private convShorId: string = ''
  private isStop = false
  onLineCount: number = 0

  constructor(convShorId: string) {
    this.convShorId = convShorId
  }


  async start() {
    BIMUILog.debug(this.tag, `loopGetOnlineCount() start()`)
    if (!this.isStop) {
      this.loopGetOnlineCount()
      this.isStop = false
    }
  }

  async stop() {
    BIMUILog.debug(this.tag, `loopGetOnlineCount() stop()`)
    this.isStop = true
  }

  async loopGetOnlineCount() {
    if (this.isStop) {
      return
    }
    let r = await BIMUIClient.getInstance().getLiveService()?.getLiveGroupOnLineCount(this.convShorId)
    if (r?.code == BIMErrorCode.BIM_OK) {
      this.onLineCount = r.data
      BIMUILog.debug(this.tag, `loopGetOnlineCount() this.onLineCount:${this.onLineCount}`)
    }
    setTimeout(() => {
      this.loopGetOnlineCount()
    }, this.interval)
  }
}