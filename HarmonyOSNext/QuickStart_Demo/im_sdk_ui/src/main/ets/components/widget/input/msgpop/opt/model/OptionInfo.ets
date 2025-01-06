import { BIMMessage } from '@imcloud/imsdk'
import { OptionConfig } from '../OptionConfig'

export abstract class OptionInfo {
  icon: ResourceStr = ""
  title: string = ""
  optionConfig: OptionConfig
  uiContext:UIContext

  constructor(optionConfig: OptionConfig, uiContext: UIContext) {
    this.optionConfig = optionConfig
    this.uiContext = uiContext
  }

  abstract onClick(msg: BIMMessage): void
}