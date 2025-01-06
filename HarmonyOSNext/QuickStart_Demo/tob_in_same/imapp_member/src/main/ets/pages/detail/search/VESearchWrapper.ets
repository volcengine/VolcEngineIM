import { BIMMessage } from "@imcloud/imsdk"
import { BIMUIUser } from "@imcloud/im_sdk_ui"
import { intl } from "@kit.LocalizationKit"

@Observed
export class VESearchWrapper{
  user: BIMUIUser
  message: BIMMessage
  time: string

  constructor(user: BIMUIUser, message: BIMMessage) {
    this.user = user
    this.message = message
    let date = new Date()
    date.setTime(message?.getCreatedTime() ?? 0)
    let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' });
    this.time = dateFormat.format(date)
  }

}