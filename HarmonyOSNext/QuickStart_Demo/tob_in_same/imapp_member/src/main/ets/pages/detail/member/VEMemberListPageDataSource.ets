import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';
import { BasicUserDataSource } from '../../../source/BasicUserDataSource';
import { VEUserWrapper } from '../../create/VEUserWrapper';

export class VEMemberListPageDataSource extends BasicUserDataSource<VEUserWrapper> {
  public pushData(wrapper: VEUserWrapper) {
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