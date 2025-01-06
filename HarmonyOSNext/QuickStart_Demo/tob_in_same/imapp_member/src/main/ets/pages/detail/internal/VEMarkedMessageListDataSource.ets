import { BIMMessage, Message } from '@imcloud/imsdk';
import { BasicUserDataSource } from '../../../source/BasicUserDataSource';


export class VEMarkedMessageListDataSource extends BasicUserDataSource<BIMMessage> {

  public addData(list: BIMMessage[]) {
    if (!list) {
      return
    }
    this.data = this.data.concat(list)

    this.notifyDataReload()
  }

  public removeData(message: BIMMessage) {
    if (!message) {
      return
    }

    for (let index = 0; index < this.data.length; index++) {
      const element = this.data[index];
      if (element.getUuid() == message.getUuid()) {
        this.data.splice(index,1)
        this.notifyDataDelete(index);
        break
      }
    }
  }

  public clear() {
    this.data = []
    this.notifyDataReload()
  }
}