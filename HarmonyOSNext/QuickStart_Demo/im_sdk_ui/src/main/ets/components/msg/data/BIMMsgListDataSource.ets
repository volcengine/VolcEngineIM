import { BasicDataSource } from '../../source/BasicDataSource';
import { BIMMessageWrapper } from '../../msg/data/model/BIMMessageWrapper';
import { BIMMessage } from '@imcloud/imsdk';
import { BIMMessageReadStatusModel, MessageReadStatusModel } from '@imcloud/imsdk';
import intl from '@ohos.intl';

export class BIMMsgListDataSource extends BasicDataSource<BIMMessageWrapper> {
  readonly tag = "BIMMsgListDataSource"
  private MSG_TIME_INTERVAL = 60 * 1000; //1分钟

  // public addData(index: number, msg: BIMMessage) {
  //   let wrapper = new BIMMessageWrapper(msg)
  //   this.addDataWrap(index, wrapper)
  // }

  public addOlderData(initList: BIMMessage[]) {
    if (initList) {
      for (let i = 0; i < initList.length; i++) {
        let msg = initList[i];
        console.debug(this.tag, `addOlderData start msg uuid:${msg?.getUuid()} content:${msg?.getContentData()} elementType:${msg.getMsgType()}`)

        let cur = new BIMMessageWrapper(msg)
        // let pre: BIMMessageWrapper | undefined = undefined
        // if (i + 1 < initList.length) {
        //   pre = new BIMMessageWrapper(initList[i+1])
        // }
        // this.checkShowTime(cur, pre)
        console.debug(this.tag, `addOlderData end uuid:${msg?.getUuid()} content:${msg?.getContentData()} elementType:${cur.elementType}`)
        this.data.push(cur)
        this.notifyDataAdd(this.data.length - 1)
      }
    }
  }

  public addDataWrap(index: number, wrapper: BIMMessageWrapper) {
    this.data.splice(index, 0, wrapper)
    this.checkShowTime(wrapper, this.getByIndex(index + 1))
    this.notifyDataAdd(index)
  }

  // public pushData(msg: BIMMessage) {
  //   let wrapper = new BIMMessageWrapper(msg)
  //   let oldLength = this.data.length;
  //   this.checkShowTime(wrapper, this.getByIndex(oldLength - 1))
  //   this.data.push(wrapper)
  //   this.notifyDataAdd(this.data.length - 1);
  // }

  public insertOrUpdateMsg(msg: BIMMessage, isUpdateUI: boolean) {
    let findIndex = this.findIndex(msg)
    let insertIndex = 0
    if (findIndex >= 0) {
      console.debug(this.tag, `insertOrUpdateMsg update msg:${msg.getUuid()} order:${msg.getOrderIndex()} findIndex:${findIndex} content:${msg.getContentData()}`)
      if (isUpdateUI) {
        this.data[findIndex] = new BIMMessageWrapper(msg)
        this.notifyDataChange(findIndex)
      } else {
        this.data[findIndex].msg = msg
      }
    } else {
      let curWrap = new BIMMessageWrapper(msg)
      insertIndex = this.findInsertIndex(curWrap) //插入新数据
      console.debug(this.tag, `insertOrUpdateMsg insert msg:${msg.getUuid()} order:${msg.getOrderIndex()} insertIndex:${insertIndex} content:${msg.getContentData()}`)
      this.addDataWrap(insertIndex, curWrap) //刷新
    }
  }

  public updateProgress(msg: BIMMessage, progress: number) {
    let findIndex = this.findIndexByUUID(msg.getUuid())
    if (findIndex >= 0) {
      this.data[findIndex].updateProgress(msg, progress)
    }
  }

  public updateReadStatus(msg: BIMMessage, readStatus: BIMMessageReadStatusModel) {
    let findIndex = this.findIndexByUUID(msg.getUuid())
    if (findIndex >= 0) {
      this.data[findIndex].updateReadStatus(msg, readStatus)
    }
  }

  public updateSendStatus(msg: BIMMessage) {
    let findIndex = this.findIndexByUUID(msg.getUuid())
    if (findIndex >= 0) {
      this.data[findIndex].updateSendStatus(msg)
    }
  }

  public updateRecall(msg: BIMMessage) {
    let findIndex = this.findIndexByUUID(msg.getUuid())
    if (findIndex >= 0) {
      this.data[findIndex].updateRecall(msg)
    }
  }

  public getMsgWrapByUUId(uuid: string): BIMMessageWrapper | undefined {
    let filterList = this.data.filter((item) => {
      return item.msg?.getUuid() == uuid
    })
    if (filterList && filterList.length > 0) {
      return filterList[0]
    }
    return undefined
  }

  public deleteMessage(msg: BIMMessage) {
    let findIndex = this.findIndexByUUID(msg.getUuid())
    if (findIndex >= 0) {
      this.deleteData(findIndex)
    }
  }

  public deleteData(index: number) {
    this.data.splice(index, 1)
    this.notifyDataDelete(index)
  }

  public reloadData(): void {
    this.notifyDataReload();
  }

  public getByIndex(index: number): BIMMessageWrapper | undefined {
    if (index === 0 || index >= this.data.length) {
      return undefined
    }
    return this.data[index]
  }

  public checkShowTime(cur: BIMMessageWrapper, pre: BIMMessageWrapper | undefined) {
    if (cur && pre) {
      let curTime = cur.msg?.getCreatedTime() ?? 0
      let preTime = pre.msg?.getCreatedTime() ?? 0
      let timeInterval = curTime - preTime
      // let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' });
      // console.debug(this.tag, `cutTime:${ dateFormat.format(new Date(curTime))} preTime:${dateFormat.format(new Date(preTime))} timeInterval:${timeInterval}`)
      if (timeInterval > this.MSG_TIME_INTERVAL) { //消息间隔大于1分钟
        cur.isShowTime = true
      } else {
        cur.isShowTime = false
      }
    } else {
      cur.isShowTime = true;
    }
  }

  private findIndexByUUID(uuid: string): number {
    for (let i = 0; i < this.data.length; i++) {
      if (this.data[i].msg?.getUuid() === uuid) {
        return i;
      }
    }
    return -1;
  }

  private findIndex(msg: BIMMessage): number {
    for (let i = 0; i < this.data.length; i++) {
      if (this.data[i].msg?.getUuid() === msg?.getUuid()) {
        return i;
      }
    }
    return -1;
  }

  private findInsertIndex(wrap: BIMMessageWrapper): number {
    let wrapSortOrder = wrap.msg?.getOrderIndex() ?? "0"
    for (let i = this.data.length - 1; i >= 0; i--) {
      let curOrder = this.data[i].msg?.getOrderIndex() ?? "0"
      if (this.isCurBigger(curOrder, wrapSortOrder)) {
        return i + 1;
      }
    }
    return 0;
  }

  private isCurBigger(cur: string, target: string): boolean {
    if (cur && target) {
      if (cur.length > target.length) {
        return true;
      } else if (cur.length == target.length) {
        return cur > target
      }
    }
    return false
  }
}