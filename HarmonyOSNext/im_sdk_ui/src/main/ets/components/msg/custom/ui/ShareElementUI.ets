import { BIMMessageWrapper } from '../../data/model/BIMMessageWrapper';
import { common, Want } from '@kit.AbilityKit';
import { ShareElement } from '../ShareElement';
import { LengthMetrics } from '@kit.ArkUI';
import { OptionConfig } from '../../../widget/input/msgpop/opt/OptionConfig';
import { BIMConversationType, BIMMessage } from '@imcloud/imsdk';

@Builder
export function buildShareMessageUI(wrapper: BIMMessageWrapper) {
  ShareElementUI({ msgWrapper: wrapper })
}

@Component
export struct ShareElementUI {
  msgWrapper: BIMMessageWrapper = new BIMMessageWrapper()
  shareElement: ShareElement | undefined

  aboutToAppear(): void {
    this.shareElement = this.msgWrapper.baseCustomElement as ShareElement
  }

  build() {
    Text() {
      Span(this.shareElement?.text + '\n').fontSize(14).fontColor(this.msgWrapper.isSelf ? '#ffffff' : '#222222')
      Span("查看详情>>").fontSize(12).fontColor(this.msgWrapper.isSelf ? Color.Black : Color.Gray).onClick(() => {
        this.openWeb()
      })
    }
    .backgroundColor(this.msgWrapper.isSelf ? '#5692ff' : '#f1f1f1')
    .lineSpacing(LengthMetrics.vp(5))
    .padding(8)
    .borderRadius(6)
    .width(200)
    .height(70)
  }

  private async openWeb() {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: this.shareElement?.link
    };
    let context = getContext() as common.UIAbilityContext
    let r = await context.startAbility(want)
  }
}

export class ShareOptionConfig extends OptionConfig {
  constructor() {
    super()
  }

  onInit(bimMessage:BIMMessage): void {
    super.onInit(bimMessage)
    let isNormalConv = bimMessage.getConversationType() != BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT
    this.isEnableLike = isNormalConv
    this.isEnableCopy = false
    this.isEnableEdit = false
    this.isEnableRef = isNormalConv
    this.isEnablePin = isNormalConv
    this.isEnableTop = isNormalConv
  }
}

