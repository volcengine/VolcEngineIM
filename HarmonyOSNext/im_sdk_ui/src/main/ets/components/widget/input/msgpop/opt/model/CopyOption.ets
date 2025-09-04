import { BIMMessage } from '@imcloud/imsdk';
import { OptionInfo } from './OptionInfo';
import { pasteboard } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import BIMUILog from '../../../../../../log/BIMUILog';
import { OptionConfig } from '../OptionConfig';

export class CopyOption extends OptionInfo {
  msg:BIMMessage|undefined
  icon: ResourceStr = $r('app.media.icon_msg_option_menu_copy');
  title: string = '复制';

  onClick(msg: BIMMessage): void {
    let text = this.optionConfig.getCopyText(msg)
    BIMUILog.debug("MsgOption", `CopyOption ${msg.getUuid()} text:${text}`)
    if (text) {
      this.copyText(text)
    }
  }

  copyText(text: string) {
    const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    const systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
    systemPasteboard.getData().then((data) => {
      if (data) {
        promptAction.showToast({ message: '复制成功' });
      } else {
        promptAction.showToast({ message: '复制失败' });
      }
    })
  }
}