import { BIMActionType, BIMErrorCode, BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import BIMUILog from '../../../../../../log/BIMUILog';
import { promptAction } from '@kit.ArkUI';
import { BIMUIClient } from '../../../../../../api/BIMUIClient';
import { systemDateTime } from '@kit.BasicServicesKit';

export class FavOption extends OptionInfo{
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_read_callback');
  title: string = "收藏";

  async onClick(msg: BIMMessage) {
    BIMUILog.debug("MsgOption", `FavOption ${msg.getUuid()}`)
    let r = await BIMUIClient.getInstance().markMessage(msg, BIMActionType.BIM_ACTION_FAVORITE, true, systemDateTime.getTime(), 0)

    if (r?.code == BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: `收藏 成功` })
    } else {
      promptAction.showToast({ message: `收藏 失败` })
    }
  }
}