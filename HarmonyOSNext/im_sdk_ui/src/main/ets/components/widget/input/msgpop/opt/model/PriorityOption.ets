import { BIMMessage, BIMMessagePriority } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import { OptionConfig } from '../OptionConfig';

export class PriorityOption extends OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_read_callback');
  title: string = '优先级';

  constructor(optionConfig: OptionConfig, uiContext: UIContext, msg: BIMMessage | undefined,) {
    super(optionConfig, uiContext, msg);
    let p = msg?.getPriority() ?? BIMMessagePriority.NORMAL
    if (p == BIMMessagePriority.LOW) {
      this.title = "低"
    } else if (p == BIMMessagePriority.HIGH) {
      this.title = "高"
    } else {
      this.title = "普通"
    }
  }


  onClick(msg: BIMMessage): void {
    // promptAction.showToast({ message: `消息优先级:${msg.getPriority()}` })
  }
}