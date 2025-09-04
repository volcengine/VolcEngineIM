import { BIMErrorCode } from '@imcloud/imsdk'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VEOnlineResultDataSource } from './VEOnlineResultDataSource'

@Observed
export class VEOnlineMemberViewModel {
  data: VEOnlineResultDataSource = new VEOnlineResultDataSource()

  public async loadData(conversationShortId: string, uidList: string[]) {
    let r = await BIMUIClient.getInstance().getLiveService()?.getLiveGroupMemberOnlineInfo(conversationShortId, uidList)
    if (r?.code == BIMErrorCode.BIM_OK) {
      this.data.appendData(r.data)
    } else {

    }
  }
}