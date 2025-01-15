import { BIMErrorCode, BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';
import { promptAction } from '@kit.ArkUI';

export class RecallOption extends OptionInfo {
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_recall');
  title: string = '撤回';

  async onClick(msg: BIMMessage) {
    BIMUILog.debug("MsgOption", `RecallOption ${msg.getUuid()}`)
    let r = await BIMUIClient.getInstance().recallMessage(msg)
    BIMUILog.debug("MsgOption", `RecallOption result code:${r.code}`)
    if (r.code == BIMErrorCode.BIM_OK) {
      BIMUILog.debug("MsgOption", `RecallOption success`)
    } else if (r.code == BIMErrorCode.BIM_SERVER_RECALL_TIMEOUT) {
      promptAction.showToast({ message: "超过两分钟的消息无法撤回", duration: 2000 })
      BIMUILog.debug("MsgOption", `RecallOption failed`)
    } else {
      promptAction.showToast({ message: `撤回失败 code:  ${r.code}`, duration: 2000 })
    }
  }
}