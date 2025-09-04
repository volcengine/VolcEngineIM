import { HashMap } from '@kit.ArkTS'
import { BIMCustomElement } from '@imcloud/imsdk'
import { BIMMessageType } from '@imcloud/imsdk'
import { BIMMessageWrapper } from '../data/model/BIMMessageWrapper'
import { buildTextMessageUI } from '../inner/TextMessageUI'
import { buildCustomDefaultUI } from '../inner/CustomDefaultMessageUI'
import { buildImageMessageUI } from '../inner/ImageMessageUI'
import { buildVideoMessageUI } from '../inner/VideoMessageUI'
import { buildFileMessageUI } from '../inner/FileMessageUI'
import { buildAudioMessageUI } from '../inner/AudioMessageUI'
import { buildShareMessageUI } from '../custom/ui/ShareElementUI'
import { buildGroupNotifyMessageUI } from '../custom/ui/GroupNotifyElementUI'

export class MsgUIManager {
  builderMap = new HashMap<string, WrappedBuilder<[BIMMessageWrapper]>>()
  elementMap = new HashMap<string, elementGenerator>()

  constructor() {
    this.registerMsgUI("default_UI", wrapBuilder(buildCustomDefaultUI))
    this.registerMsgUI(BIMMessageType.BIM_MESSAGE_TYPE_TEXT.toString(), wrapBuilder(buildTextMessageUI))
    this.registerMsgUI(BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.toString(), wrapBuilder(buildImageMessageUI))
    this.registerMsgUI(BIMMessageType.BIM_MESSAGE_TYPE_VIDEO.toString(), wrapBuilder(buildVideoMessageUI))
    this.registerMsgUI(BIMMessageType.BIM_MESSAGE_TYPE_FILE.toString(), wrapBuilder(buildFileMessageUI))
    this.registerMsgUI(BIMMessageType.BIM_MESSAGE_TYPE_AUDIO.toString(), wrapBuilder(buildAudioMessageUI))
    this.registerMsgUI("10008", wrapBuilder(buildGroupNotifyMessageUI))
    this.registerMsgUI("1", wrapBuilder(buildShareMessageUI))
    this.registerMsgUI("2", wrapBuilder(buildGroupNotifyMessageUI))
  }

  public registerMsgUI(type: string, builder: WrappedBuilder<[BIMMessageWrapper]>) {
    this.builderMap.set(type, builder)
  }

  public registerMsgGenerator(type: string, generator: elementGenerator) {
    this.elementMap.set(type, generator)
  }

  public getMsgUIBuilder(type: string): WrappedBuilder<[BIMMessageWrapper]> {
    return this.builderMap.get(type) ?? this.builderMap.get("default_UI")
  }

  public getMsgGenerator(type: string): elementGenerator {
    return this.elementMap.get(type)
  }
}

export declare type elementGenerator = (type: string, json: string) => BIMCustomElement