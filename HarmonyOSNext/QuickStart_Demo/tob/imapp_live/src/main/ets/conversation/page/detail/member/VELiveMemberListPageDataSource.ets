import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';
import { BasicDataSource } from '@imcloud/im_sdk_ui/src/main/ets/components/source/BasicDataSource';
import { VELiveUserWrapper } from '../VELiveUserWrapper';


export class VELiveMemberListPageDataSource extends BasicDataSource<VELiveUserWrapper> {
  public pushData(wrapper: VELiveUserWrapper) {
    // let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
    this.data.push(wrapper)
    this.notifyDataAdd(this.data.length - 1);
  }

  public selectData(): BIMUIUser[] {
    return this.data.filter((wrapper) => {
      return wrapper.isSelect
    }).map<BIMUIUser>((wrapper) => {
      return wrapper.user
    })
  }
}