import { BIMConvListDataSource } from './BIMConvListDataSource';
import BIMUILog from '../../../log/BIMUILog';
import { BIMUIClient } from '../../../api/BIMUIClient';
import { BIMErrorCode } from '@imcloud/imsdk';
import { BIMResult } from '@imcloud/imsdk';
import { BIMConversationListResult } from '@imcloud/imsdk';
import { BIMConversationListListener } from '@imcloud/imsdk';
import { BIMConversation } from '@imcloud/imsdk';
import { BIMUnReadInfo } from '@imcloud/imsdk';


@Observed
export class BIMConvListViewModel {
  private _tag = "convListView"
  private _cursor = 0
  private _hasMore = true;
  private _limit = 20
  private _isLoading = false;
  data: BIMConvListDataSource = new BIMConvListDataSource();

  public async loadMore() {
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
    let result: BIMResult<BIMConversationListResult> = await BIMUIClient.getInstance().getConversationList(this._cursor, this._limit)
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
    onTotalUnreadMessageCountChanged: (unreadInfo: BIMUnReadInfo): void => {
    }
  }
}