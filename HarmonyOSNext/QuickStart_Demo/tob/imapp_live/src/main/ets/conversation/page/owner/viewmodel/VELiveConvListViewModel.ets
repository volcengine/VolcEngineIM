import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog';
import { BIMErrorCode, BIMLiveGroupListResult, BIMResult } from '@imcloud/imsdk';
import { BIMUIClient } from '@imcloud/im_sdk_ui';
import { VELiveConvWrapper } from './wrap/VELiveConvWrapper';
import { VELiveConvListDataSource } from './VELiveConvListDataSource';

@Observed
export class VELiveConvListViewModel {
  public static TYPE_OWNER = 0
  public static TYPE_ALL = 1
  private _tag = "liveList"
  private _cursor = 0
  private _hasMore = true;
  private _limit = 20
  private _isLoading = false;
  data: VELiveConvListDataSource = new VELiveConvListDataSource();
  private _type: number = 0;
  private backUp: VELiveConvWrapper[] = []
  private isSearching = false;

  constructor(type: number) {
    this._type = type;
  }

  public async loadMore() {
    BIMUILog.info(this._tag, `loadMore start type: ${this._type}`)
    if (this.isSearching) {
      BIMUILog.info(this._tag, `loadMore isSearching return`)
      return
    }

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
    let result: BIMResult<BIMLiveGroupListResult> | undefined
    if (this._type == VELiveConvListViewModel.TYPE_OWNER) {
      result = await BIMUIClient.getInstance().getLiveService()?.getOwnerLiveGroupList(this._cursor, this._limit)
    } else if (this._type == VELiveConvListViewModel.TYPE_ALL) {
      result = await BIMUIClient.getInstance().getLiveService()?.getAllLiveGroupList(this._cursor, this._limit)
    }
    if (result?.code == BIMErrorCode.BIM_OK) {
      console.debug(this._tag, `loadMore success length: ${result?.data?.getConversationList().length}`)
      let pageData = result.data
      let convList = pageData.getConversationList()
      let lastCursor = this._cursor
      this._cursor = pageData.getNextCursor()
      this._hasMore = pageData.isHasMore()
      let list = convList.map((value) => new VELiveConvWrapper(value))
      if (lastCursor == 0) {//第一页数据
        // this.data.reload([]) // 清空，强制刷新
        this.data.reload(list)
      } else {
        this.data.appendData(list)
      }
    } else {
      BIMUILog.info(this._tag, `loadMore failed code: ${result?.code}`)
    }
    this._isLoading = false;
  }

  public async search(key: string) {
    BIMUILog.info(this._tag, `search key: ${key} backup size: ${this.backUp.length}`)
    if (key) {
      if (this.backUp.length == 0) {
        this.backUp = this.data.getAllDataList();
      }
      this.isSearching = true
      let filterList = this.backUp.filter((value) => {
        return value.conversationName.indexOf(key) >= 0 || value.conversationId.indexOf(key) >= 0
      })
      this.data.reload(filterList)
    } else {
      this.isSearching = false
      this.data.reload(this.backUp)
      this.backUp = []
    }
  }

  public async refresh() {
    BIMUILog.info(this._tag, `refresh()`)
    this._cursor = 0
    this._hasMore = true;
    this._limit = 20
    this._isLoading = false;
    this.backUp = []
    this.isSearching = false;
    await this.loadMore()
  }
}