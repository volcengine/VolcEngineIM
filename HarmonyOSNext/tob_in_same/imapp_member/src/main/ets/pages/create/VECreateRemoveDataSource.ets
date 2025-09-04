import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';
import { BasicUserDataSource } from '../../source/BasicUserDataSource';
import { VEUserWrapper } from './VEUserWrapper';

export class VECreateRemoveDataSource extends BasicUserDataSource<VEUserWrapper> {
  public pushData(info: BIMUIUser) {
    this.data.push(new VEUserWrapper(info, undefined, true, false))
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