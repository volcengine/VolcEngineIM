import { BIMActionType, BIMErrorCode, BIMMessage, Message } from '@imcloud/imsdk';
import { VEMarkedMessageListDataSource } from './VEMarkedMessageListDataSource';
import { BIMUIClient } from '@imcloud/im_sdk_ui';
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'
import { promptAction } from '@kit.ArkUI';

export class VEMarkedMessageListPageViewModel {
  private tag = "VEMarkedMessageListPageViewModel"
  private cid: string = ""
  private actionType: BIMActionType
  private hasMore = true;
  private limit = 20
  nextCursor = 0n
  private isLoading = false;
  data: VEMarkedMessageListDataSource = new VEMarkedMessageListDataSource();
  segmentList: number[] = [0,1,2,3]
  selectedTag: number = 0

  constructor(cid: string, actionType: BIMActionType) {
    this.cid = cid
    this.actionType = actionType
  }

  changeSeletedTag(tag: number) {
    this.selectedTag = tag
    this.nextCursor = 0n
    this.hasMore = true
    this.isLoading = false
    this.data.clear()
    this.loadMore()
  }

  async loadMore() {
    if (!this.hasMore) {
      BIMUILog.info(this.tag, `loadMore not hasMore return`)
      return
    }
    if (this.isLoading) {
      BIMUILog.info(this.tag, `loadMore isLoading return`)
      return
    }

    this.isLoading = true
    let result  = await BIMUIClient.getInstance().fetchMarkedMessage(this.cid, this.actionType, this.selectedTag, false, this.nextCursor, this.limit, false)
    if (result.code == BIMErrorCode.BIM_OK) {
      if (result.data.msgList) {
        this.data.addData(result.data.msgList)
      }
      this.hasMore = result.data.hasMore ?? false
      this.nextCursor = result.data.nextCursor ?? 0n
    }
    this.isLoading = false
  }

 async cancleMark(msg: BIMMessage) {
    let result = await BIMUIClient.getInstance().markMessage(msg, this.actionType, false, 0, this.selectedTag)

    if (result.code != BIMErrorCode.BIM_OK) {
     promptAction.showToast({message:'取消标记失败:' + result.code})
    } else {
      this.data.removeData(msg)
    }
  }
}