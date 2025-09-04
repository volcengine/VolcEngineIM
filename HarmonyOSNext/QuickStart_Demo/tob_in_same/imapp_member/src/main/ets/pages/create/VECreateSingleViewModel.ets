import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'

export class VECreateSingleViewModel {
  private readonly tag = "createSingle"
  uid: string = ""

  onConfirm(): string {
    BIMUILog.debug(this.tag, `onConfirm uid:${this.uid}`)
    if (this.uid.length > 0) {
      return this.uid
    }
    return "";
  }
}