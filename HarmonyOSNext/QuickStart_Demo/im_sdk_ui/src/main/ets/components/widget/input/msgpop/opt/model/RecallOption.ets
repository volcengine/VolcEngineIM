import { BIMErrorCode, BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';

export class RecallOption extends OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_recall');
  title: string = '撤回';

  async onClick(msg: BIMMessage) {
    BIMUILog.debug("MsgOption", `RecallOption ${msg.getUuid()}`)
    let r = await BIMUIClient.getInstance().recallMessage(msg)
    if (r.code == BIMErrorCode.BIM_OK) {
      BIMUILog.debug("MsgOption", `RecallOption success`)
    } else {
      BIMUILog.debug("MsgOption", `RecallOption failed`)
    }
  }
}