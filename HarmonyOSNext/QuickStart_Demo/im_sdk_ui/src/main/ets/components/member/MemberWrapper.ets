import { BIMMember } from '@imcloud/imsdk'
import { BIMUIClient } from '../../api/BIMUIClient'

@Observed
export class MemberWrapper {
  member: BIMMember
  name: string = ""
  head: ResourceStr = ""

  constructor(member: BIMMember) {
    this.member = member
    let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
    this.name = user.nickName
    this.head = user.portraitUrl
  }
}