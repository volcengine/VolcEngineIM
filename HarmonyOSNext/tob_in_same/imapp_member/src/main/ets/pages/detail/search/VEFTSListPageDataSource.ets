import { BIMMessage } from '@imcloud/imsdk';
import { BasicUserDataSource } from '../../../source/BasicUserDataSource';
import { VESearchWrapper } from './VESearchWrapper';

export class VEFTSListPageDataSource extends BasicUserDataSource<VESearchWrapper> {

  public setData(list: VESearchWrapper[]) {
    if (!list) {
      this.clear()
      return
    }
    // this.clear() // 切换数据时需先调用notifyDataReload，具体原因未知
    this.data = list
    this.notifyDataReload()
  }


  public clear() {
    this.data = []
    this.notifyDataReload()
  }

}