import { BasicDataSource } from '@imcloud/im_sdk_ui'

export class VELiveEditOnlineMemberDataSource extends BasicDataSource<string> {
  public appendData(uid: string) {
    this.data.unshift(uid)
    this.notifyDataAdd(0)
  }

  public deleteData(uid: string) {
    let index = this.data.indexOf(uid);
    if (index >= 0) {
      this.data.splice(index, 1)
      this.notifyDataDelete(index)
    }
  }

  public findIndex(uid: string): number {
    let index = this.data.indexOf(uid);
    return index;
  }
}