import { BIMConversation } from '@imcloud/imsdk';
import { BasicDataSource } from '../../../components/source/BasicDataSource';
import { BIMConvWrapper } from './model/BIMConvWrapper';
import BIMUILog from '../../../log/BIMUILog';
import { data } from '@kit.TelephonyKit';

export class BIMConvListDataSource extends BasicDataSource<BIMConvWrapper> {
  private tag = "convLDS"

  public insertData(index: number, wrap: BIMConvWrapper) {
    this.data.splice(index, 0, wrap)
    this.notifyDataAdd(index)
    BIMUILog.debug(this.tag, `insertData index:${index}`)
  }


  public pushData(conv: BIMConversation) {
    this.data.push(new BIMConvWrapper(conv, BIMConvWrapper.TYPE_CONV))
    this.notifyDataAdd(this.data.length - 1);
  }

  public delete(conv: BIMConversation) {
    let wrap = new BIMConvWrapper(conv, BIMConvWrapper.TYPE_CONV)
    let findIndex = this.findIndex(wrap)
    if (findIndex >= 0) {
      this.deleteData(findIndex)
    }
  }

  public deleteData(index: number) {
    this.data.splice(index, 1)
    this.notifyDataDelete(index)
    BIMUILog.debug(this.tag, `deleteData index:${index}`)
  }

  public reloadData(): void {
    this.notifyDataReload();
  }

  public insertOrUpdate(conv: BIMConversation) {
    let cid = conv.getConversationId()
    let wrap = new BIMConvWrapper(conv, BIMConvWrapper.TYPE_CONV)
    let findIndex = this.findIndex(wrap)
    if (findIndex >= 0) { //先删除旧数据再加新数据
      this.deleteData(findIndex)
    }
    let insertIndex = this.findInsertIndex(wrap) //插入新数据
    this.insertData(insertIndex, wrap)
  }

  private findIndex(wrap: BIMConvWrapper): number {
    for (let i = 0; i < this.data.length; i++) {
      if (this.data[i].conv?.getConversationId() === wrap.conv.getConversationId()) {
        return i;
      }
    }
    return -1;
  }

  public contains(conv: BIMConversation): boolean {
    for (let i = 0; i < this.data.length; i++) {
      if (this.data[i].conv?.getConversationId() === conv.getConversationId()) {
        return true;
      }
    }
    return false;
  }

  private findInsertIndex(wrap: BIMConvWrapper): number {
    let wrapSortOrder = wrap.conv.getSortOrder()
    if (this.data.length > 0 && this.data[0].conv.getSortOrder() < wrap.conv.getSortOrder()) {
      return 0;
    }
    for (let i = 0; i < this.data.length; i++) {
      let order = this.data[i].conv.getSortOrder()
      if (order < wrapSortOrder) {
        return i;
      }
    }
    return this.data.length;
  }
}