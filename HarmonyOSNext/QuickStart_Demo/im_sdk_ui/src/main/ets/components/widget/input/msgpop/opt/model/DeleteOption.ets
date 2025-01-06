import { BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { OptionConfig } from '../OptionConfig';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';

export class DeleteOption extends  OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_delete');
  title: string = "删除";

  async onClick(msg: BIMMessage) {
    let r = await BIMUIClient.getInstance().deleteMessage(msg)
    BIMUILog.debug("MsgOption", `DeleteOption ${msg.getUuid()} code:${r.code}`)
  }
}