import { BasicDataSource } from '@imcloud/im_sdk_ui/src/main/ets/components/source/BasicDataSource';
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog';
import { VELiveConvWrapper } from './wrap/VELiveConvWrapper';

export class VELiveConvListDataSource extends BasicDataSource<VELiveConvWrapper> {
  private tag = "convLDS"


  public appendData(list: VELiveConvWrapper[]) {
    BIMUILog.debug(this.tag, `appendData index:${list.length}`)
    for (let w of list) {
      this.data.push(w)
      this.notifyDataAdd(this.data.length - 1)
    }
  }

  public reload(list: VELiveConvWrapper[]){
    BIMUILog.debug(this.tag, `refreshData index:${list.length}`)
    this.data = list
    this.notifyDataReload()
  }
}