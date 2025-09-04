import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';
import { BasicDataSource } from '@imcloud/im_sdk_ui/src/main/ets/components/source/BasicDataSource';
import { VELiveUserWrapper } from '../../VELiveUserWrapper';

export class VELiveUserHorizonSource extends BasicDataSource<VELiveUserWrapper> {
  readonly maxItem: number = 5;

  addData(info: VELiveUserWrapper) {
    this.data.splice(0, 0, info)
    this.notifyDataAdd(0)
    if (this.totalCount() > this.maxItem) {
      this.removeIndex(this.totalCount() - 1)
    }
  }

  reload(list: VELiveUserWrapper[]) {
    if (list.length > this.maxItem) {
      this.data = list.slice(0, this.maxItem)
    } else {
      this.data = list
    }
    this.notifyDataReload()
  }

  removeIndex(index: number) {
    this.data.splice(index, 1)
    this.notifyDataDelete(index)
  }

  removeData(uid: string) {
    let index = this.data.findIndex((wrapper) => {
      return uid == wrapper.user.uid
    })
    if (index >= 0) {
      this.removeIndex(index)
    }
  }

  clear(){
    this.data =[]
    this.notifyDataReload()
  }
}