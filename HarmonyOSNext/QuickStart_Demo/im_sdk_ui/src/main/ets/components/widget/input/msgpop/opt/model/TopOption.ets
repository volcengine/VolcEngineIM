import { BIMActionType, BIMErrorCode, BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';
import { systemDateTime } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

export class TopOption extends OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_read_callback');
  title: string = "置顶";

  async onClick(msg: BIMMessage) {
    BIMUILog.debug("MsgOption", `TopOption ${msg.getUuid()}`)
    let r = await BIMUIClient.getInstance().markMessage(msg, BIMActionType.BIM_ACTION_CONV_TOP_MSG, true, systemDateTime.getTime(), 0)

    if (r?.code == BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: `置顶 成功` })
    } else {
      promptAction.showToast({ message: `置顶 失败` })
    }
  }
}