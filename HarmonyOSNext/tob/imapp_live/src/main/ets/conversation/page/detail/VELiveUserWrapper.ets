import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser'
import { BIMMember } from '@imcloud/imsdk'

@Observed
export class VELiveUserWrapper{
  user: BIMUIUser
  member: BIMMember | undefined
  isEdit: boolean = true // 是否可编辑
  isSelect: boolean // 编辑态下，是否选中
  onlineString: string | undefined
  isShowSilentMark: boolean = false //

  constructor(user: BIMUIUser, member: BIMMember | undefined, isEdit: boolean, isSelect: boolean, onlineString: string | undefined = undefined, isShowSilentMark: boolean = false) {
    this.user = user
    this.member = member
    this.isEdit = isEdit
    this.isSelect = isSelect
    this.onlineString = onlineString
    this.isShowSilentMark = isShowSilentMark
  }

  getDisplayName(): string {
    if (this.member?.getAlias().length) {
      return this.member.getAlias()
    }
    return this.user.nickName ?? ''
  }

  getDisplayAvatarUrl(): string | Resource {
    if (this.member?.getAvatarUrl().length) {
      return this.member.getAvatarUrl()
    }
    return this.user.portraitUrl
  }

  getUniqueID(): string {
    return `${this.user.uid}_${this.getDisplayName()}_${this.getDisplayAvatarUrl()}_${this.onlineString}_${this.member?.getRole()}`
  }

}