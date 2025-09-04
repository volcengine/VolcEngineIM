import { BIMConversation, BIMMemberRole, Conversation } from "@imcloud/imsdk";

@Observed
export class VELiveConvWrapper {
  public conv: BIMConversation
  public portraitUrl: string | Resource = $r('app.media.default_icon_group')
  public conversationName: string = "未命名直播群"
  public conversationId: string = ""
  public detail: string = ""

  constructor(conv: BIMConversation) {
    this.conv = conv
    let pUrl = conv.getPortraitURL()
    if (pUrl) {
      this.portraitUrl = pUrl
    }
    let convName = conv.getName()
    if (convName) {
      this.conversationName = convName
    } else {
      this.conversationId = conv.getConversationId()
    }
    let member = conv.getCurrentMember()
    if (member) {
      let role = member.getRole()
      if (role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
        this.detail = "群主"
      } else if (role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
        this.detail = "管理员"
      }
    }
  }
}