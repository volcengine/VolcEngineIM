import { BIMCustomElement, BIMMessage, BIMMessageType } from '@imcloud/imsdk'
import { OptionConfig } from './OptionConfig'
import { DefaultOptionConfig } from './DefaultOptionConfig'
import { TextOptionConfig } from '../../../../msg/inner/TextMessageUI'
import { ImageOptionConfig } from '../../../../msg/inner/ImageMessageUI'
import { VideoOptionConfig } from '../../../../msg/inner/VideoMessageUI'
import { FileOptionConfig } from '../../../../msg/inner/FileMessageUI'
import { AudioOptionConfig } from '../../../../msg/inner/AudioMessageUI'
import { ShareOptionConfig } from '../../../../msg/custom/ui/ShareElementUI'
import { BIMUIClient } from '../../../../../api/BIMUIClient'
import { GroupNotifyOptionConfig } from '../../../../msg/custom/ui/GroupNotifyElementUI'

export class MsgOptManager {
  optConfigMap: Map<string, OptionConfig> = new Map()

  constructor() {
    this.registerOptionConfig(BIMMessageType.BIM_MESSAGE_TYPE_TEXT.toString(), new TextOptionConfig())
    this.registerOptionConfig(BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.toString(), new ImageOptionConfig())
    this.registerOptionConfig(BIMMessageType.BIM_MESSAGE_TYPE_VIDEO.toString(), new VideoOptionConfig())
    this.registerOptionConfig(BIMMessageType.BIM_MESSAGE_TYPE_FILE.toString(), new FileOptionConfig())
    this.registerOptionConfig(BIMMessageType.BIM_MESSAGE_TYPE_AUDIO.toString(), new AudioOptionConfig())
    this.registerOptionConfig("10008", new GroupNotifyOptionConfig())

    this.registerOptionConfig("1", new ShareOptionConfig())
    this.registerOptionConfig("2", new GroupNotifyOptionConfig())
  }

  registerOptionConfig(type: string, config: OptionConfig) {
    this.optConfigMap.set(type, config)
  }

  getOptionConfigByMsg(msg: BIMMessage|undefined) {
    let optionConfig: OptionConfig = new DefaultOptionConfig()
    if(msg){
      if (msg.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
        let baseCustom = BIMUIClient.getInstance().parseCustomElement(msg.getElement() as BIMCustomElement)
        optionConfig = this.getOptionConfig(baseCustom.type)
      } else {
        optionConfig = this.getOptionConfig(msg.getMsgType().toString())
      }
      optionConfig.onInit(msg)
    }
    return optionConfig
  }

  private getOptionConfig(type: string): OptionConfig {
    return this.optConfigMap.get(type) ?? new DefaultOptionConfig()
  }
}