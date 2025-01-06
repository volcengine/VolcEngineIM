import { BIMMessageWrapper } from '../../data/model/BIMMessageWrapper';
import { common, Want } from '@kit.AbilityKit';
import { ShareElement } from '../ShareElement';
import { LengthMetrics } from '@kit.ArkUI';
import { OptionConfig } from '../../../widget/input/msgpop/opt/OptionConfig';
import { GroupNotifyElement } from '../GroupNotifyElement';
import { BIMMessage, BIMMessageType, BIMSystemElement } from '@imcloud/imsdk';

@Builder
export function buildGroupNotifyMessageUI(wrapper: BIMMessageWrapper) {
  GroupNotifyElementUI({ msgWrapper: wrapper })
}

@Component
export struct GroupNotifyElementUI {
  msgWrapper: BIMMessageWrapper = new BIMMessageWrapper()
  groupNotifyElement: GroupNotifyElement | BIMSystemElement | undefined
  @Consume itemMsgWidth: number

  aboutToAppear(): void {
    if (this.msgWrapper.msg?.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
      this.groupNotifyElement = this.msgWrapper.baseCustomElement as GroupNotifyElement
    } else {
      this.groupNotifyElement = this.msgWrapper.msg?.content as BIMSystemElement
    }

  }

  build() {
    Column() {
      Text(this.groupNotifyElement?.text)
        .fontColor(Color.Gray)
        // .backgroundColor(Color.Gray)
        .fontSize(12)
    }
    .alignItems(HorizontalAlign.Center)
    .width(this.itemMsgWidth)

  }
}

export class GroupNotifyOptionConfig extends OptionConfig {
  constructor() {
    super()
  }

  onInit(bimMessage:BIMMessage): void {
    super.onInit(bimMessage)
    this.isEnableOption = false
    this.isEnableLike = false
    this.isEnableCopy = false
    this.isEnableDelete = false
    this.isEnableRef = false
    this.isEnablePin = false
    this.isEnableTop = false
    this.isEnableRecall = false
    this.isForceHeadHidden = true
    this.isForceHiddenReadStatus = true
  }
}

