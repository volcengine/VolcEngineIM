import { BIMMessage } from '@imcloud/imsdk'

export interface InputOutListener {
  onOutTouch: (event: TouchEvent) => void
  onRefMsg: (msg: BIMMessage) => void
  onEditMsg: (msg: BIMMessage) => void
}

/**
 * 外部事件输入
 */
export class VEInputOutConfig {
  outListener: InputOutListener | undefined

  onTouchOut(event: TouchEvent) {
    this.outListener?.onOutTouch(event)
  }

  onRef(msg: BIMMessage) {
    this.outListener?.onRefMsg(msg)
  }

  onEditMsg(msg: BIMMessage) {
    this.outListener?.onEditMsg(msg)
  }
}