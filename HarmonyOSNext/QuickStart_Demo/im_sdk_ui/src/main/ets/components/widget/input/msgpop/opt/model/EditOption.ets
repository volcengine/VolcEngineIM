import { BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import { OptionConfig } from '../OptionConfig';
import BIMUILog from '../../../../../../log/BIMUILog';

export class EditOption extends OptionInfo {
  icon = $r('app.media.icon_msg_option_menu_read_callback');
  title = "编辑"
  listener: (msg: BIMMessage) => void = () => {
  }

  constructor(optionConfig: OptionConfig, uiContext: UIContext, l?: (msg: BIMMessage) => void) {
    super(optionConfig, uiContext)
    if (l) {
      this.listener = l
    }
  }

  onClick(msg: BIMMessage): void {
    BIMUILog.debug("MsgOption", `EditOption ${msg.getUuid()}`)
    this.listener(msg)
  }
}