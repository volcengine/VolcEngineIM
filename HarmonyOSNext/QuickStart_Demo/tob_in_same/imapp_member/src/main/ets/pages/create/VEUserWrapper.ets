import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser'
import { BIMMember } from '@imcloud/imsdk'

@Observed
export class VEUserWrapper{
  user: BIMUIUser
  member: BIMMember | undefined
  isEdit: boolean = true // 是否可编辑
  isSelect: boolean // 编辑态下，是否选中

  constructor(user: BIMUIUser, member: BIMMember | undefined, isEdit: boolean, isSelect: boolean) {
    this.user = user
    this.member = member
    this.isEdit = isEdit
    this.isSelect = isSelect
  }

}