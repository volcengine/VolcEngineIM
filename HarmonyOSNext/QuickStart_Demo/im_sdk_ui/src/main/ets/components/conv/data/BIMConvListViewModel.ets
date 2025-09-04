import { BIMConvListDataSource } from './BIMConvListDataSource';
import BIMUILog from '../../../log/BIMUILog';
import { BIMUIClient } from '../../../api/BIMUIClient';
import {
  BIMConversation,
  BIMConversationListListener,
  BIMConversationListResult,
  BIMErrorCode,
  BIMResult
} from '@imcloud/imsdk';
import { systemDateTime } from '@kit.BasicServicesKit';


@Observed
export class BIMConvListViewModel {
  private _tag = "convListView"
  private _cursor = 0
  private _hasMore = true;
  private _limit = 20
  private _isLoading = false;
  private _firstPage = true
  data: BIMConvListDataSource = new BIMConvListDataSource();
  private startTime = 0;
  public async loadMore() {
    this.startTime = systemDateTime.getTime()
    if (!this._hasMore) {
      BIMUILog.info(this._tag, `loadMore not hasMore return`)
      return
    }
    if (this._isLoading === true) {
      BIMUILog.info(this._tag, `loadMore isLoading return`)
      return
    }

    this._isLoading = true;
    BIMUILog.info(this._tag, `loadMore cursor: ${this._cursor}`)
    if (this._cursor == 0) {
      console.debug(`FirstLoad Page1 start!`)
    }
    let start = systemDateTime.getTime();
    let result: BIMResult<BIMConversationListResult> = await BIMUIClient.getInstance().getConversationList(this._cursor, this._limit)
    if (this._firstPage) {
      BIMUILog.info(this._tag, `firstPageCost: ${systemDateTime.getTime() - this.startTime}`)
      this._firstPage = false
    }
    if (this._cursor == 0) {
      let timeCost = systemDateTime.getTime() - start;
      console.debug(`FirstLoad Page1 end CostTime: ${this._cursor} time: ${timeCost}`)
    }
    if (result.code == BIMErrorCode.BIM_OK) {
      let pageData = result.data
      let convList = pageData.conversationList
      this._cursor = pageData.nextCursor
      this._hasMore = pageData.hasMore
      if (convList) {
        convList.forEach((conv) => {
          BIMUILog.info(this._tag, `loadPage conv: ${conv.getConversationId()} unread:${conv.getUnreadCount()} conv:${conv.getUpdatedTime()}`)
          if (!this.data.contains(conv)) { //可能有其他回调接口已经更新过了
            this.data.insertOrUpdate(conv)
          }
        })
      }
    } else {
      BIMUILog.info(this._tag, `loadMore failed code: ${result.code}}`)
    }
    this._isLoading = false;
  }

  conversationListListener: BIMConversationListListener = {
    onNewConversation: (conversationList: BIMConversation[]): void => {
      conversationList.forEach((conv) => {
        BIMUILog.info(this._tag, `onNewConversation: ${conv.getConversationId()} unreadCount:${conv.getUnreadCount()} conv:${conv.getUpdatedTime()}`)
        this.data.insertOrUpdate(conv)
      })
    },
    onConversationChanged: (conversationList: BIMConversation[]): void => {
      conversationList.forEach((conv) => {
        BIMUILog.info(this._tag, `onConversationChanged: ${conv.getConversationId()} unreadCount:${conv.getUnreadCount()} conv:${conv.getUpdatedTime()} isMember:${conv.isMember()}`)
        this.data.insertOrUpdate(conv)
      })
    },
    onConversationDelete: (conversationList: BIMConversation[]): void => {
      conversationList.forEach((conv) => {
        BIMUILog.info(this._tag, `onConversationDelete: ${conv.getConversationId()} unreadCount:${conv.getUnreadCount()} conv:${conv.getUpdatedTime()}`)
        this.data.delete(conv)
      })
    },
    onTotalUnreadMessageCountChanged: (unreadCount: number): void => {
    }
  }
}