import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';
import { BasicUserDataSource } from '../../source/BasicUserDataSource';

export class VEUserHorizonSource extends BasicUserDataSource<BIMUIUser> {
  readonly maxItem: number = 5;


  addData(info: BIMUIUser) {
    this.data.splice(0, 0, info)
    this.notifyDataAdd(0)
    if (this.totalCount() > this.maxItem) {
      this.removeIndex(this.totalCount() - 1)
    }
  }


  removeIndex(index: number) {
    this.data.splice(index, 1)
    this.notifyDataDelete(index)
  }

  removeData(uid: string) {
    let index = this.data.findIndex((user) => {
      return uid == user.uid
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