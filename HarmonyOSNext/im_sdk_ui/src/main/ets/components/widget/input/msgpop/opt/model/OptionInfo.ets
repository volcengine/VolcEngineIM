import { BIMMessage } from '@imcloud/imsdk'
import { OptionConfig } from '../OptionConfig'

export abstract class OptionInfo {
  icon: ResourceStr = ""
  title: string = ""
  optionConfig: OptionConfig
  uiContext: UIContext
  msg: BIMMessage | undefined

  constructor(optionConfig: OptionConfig, uiContext: UIContext, msg: BIMMessage | undefined) {
    this.optionConfig = optionConfig
    this.uiContext = uiContext
    this.msg = msg;
  }

  abstract onClick(msg: BIMMessage): void
}