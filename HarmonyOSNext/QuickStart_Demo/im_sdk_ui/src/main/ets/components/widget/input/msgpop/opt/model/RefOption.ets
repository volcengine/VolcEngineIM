import { BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { OptionConfig } from '../OptionConfig';

export class RefOption extends  OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_read_callback');
  title: string = '引用'
  listener: (msg: BIMMessage) => void = ()=>{}

  constructor(optionConfig: OptionConfig, uiContext:UIContext,l?: (msg: BIMMessage) => void) {
    super(optionConfig,uiContext)
    if (l) {
      this.listener = l
    }
  }

  onClick(msg: BIMMessage): void {
    BIMUILog.debug("MsgOption", `RefOption ${msg.getUuid()}`)
    this.listener(msg)
  }
}