import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser'
import { VELiveUserWrapper } from '../VELiveUserWrapper'
import { VELiveMemberListPageDataSource } from './VELiveMemberListPageDataSource'


export class VELiveMemberListPageViewModel {
  data: VELiveMemberListPageDataSource = new VELiveMemberListPageDataSource()

  pushData(wrapper: VELiveUserWrapper) {
    // let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
    this.data.pushData(wrapper)
  }

  getSelectedList(): BIMUIUser[] {
    return this.data.selectData()
  }

  onConfirmClick():string[] {
    let r = this.data.selectData();
    return r.map((user) => {
      return user.uid
    })
  }
}