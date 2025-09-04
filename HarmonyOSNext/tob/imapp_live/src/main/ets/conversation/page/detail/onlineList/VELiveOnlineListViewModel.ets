import { IMPage, IMRouter } from "@imcloud/imapp_router";
import { BIMErrorCode, BIMMember, BIMMemberRole, BIMResult } from "@imcloud/imsdk";
import { BIMLiveMemberListResult } from "@imcloud/imsdk/src/main/ets/live/api/model/BIMLiveMemberListResult";
import { BIMUIClient } from "@imcloud/im_sdk_ui";
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog";
import { VELiveUserWrapper } from "../VELiveUserWrapper";
import { promptAction } from "@kit.ArkUI";
import { VELiveMemberDataSource } from "../silentWhiteList/VELiveMemberDataSource";

@Observed
export class VELiveOnlineListViewModel {
  private _tag = "liveOnlineList"
  data: VELiveMemberDataSource = new VELiveMemberDataSource();
  public  isEdit: boolean = false
  private cid: string = ''
  private _adminCursor = 0
  private _adminMemberHasMore = true;
  private _limit = 20
  private _isLoading = false;

  private _onlineCursor = 0
  public hasMore = true;

  // 存储管理员用户ID集合，用于去重
  private _adminUserIds: Set<string> = new Set<string>();

  setCid(cid: string, isEdit: boolean) {
    this.cid = cid
    this.isEdit = isEdit
  }

  /**
   * 获取管理员列表
   */
  private async getLiveGroupMemberList(): Promise<VELiveUserWrapper[]> {
    let liveService = BIMUIClient.getInstance().getLiveService()
    if (!liveService) {
      return []
    }
    
    let result = await liveService.getLiveGroupMemberList(this.cid, this._adminCursor, this._limit)
    if (result.code != BIMErrorCode.BIM_OK) {
      BIMUILog.info(this._tag, `getLiveGroupMemberList failed code: ${result?.code}`)
      return []
    }


    let memberList = result.data.getMemberList()
    
    // 更新游标和分页状态
    if (result.data.getNextCursor() > 0) {
      this._adminCursor = result.data.getNextCursor()
    }
    BIMUILog.info(this._tag, `getLiveGroupMemberList success length: ${memberList.length} adminCursor:${this._adminCursor}`)

    this._adminMemberHasMore = result.data.isHasMore()

    // 将管理员用户ID添加到集合中，用于后续去重
    let adminWrappers: VELiveUserWrapper[] = []
    for (let member of memberList) {
      let userId = member.getUserID()
      this._adminUserIds.add(userId)
      let wrapper = new VELiveUserWrapper(
        BIMUIClient.getInstance().getUserProvider().getUserInfo(userId), 
        member, 
        this.isEdit,
        false,
        member.isOnline() ? '在线' : '离线'
      )

      adminWrappers.push(wrapper)
    }

    return adminWrappers
  }

  /**
   * 获取在线群成员列表（去重管理员）
   */
  private async loadOnlineData(): Promise<VELiveUserWrapper[]> {
    let liveService = BIMUIClient.getInstance().getLiveService()
    if (!liveService) {
      return []
    }
    
    let result = await liveService.getLiveGroupMemberOnlineList(this.cid, this._onlineCursor, this._limit)
    if (result.code != BIMErrorCode.BIM_OK) {
      BIMUILog.info(this._tag, `loadOnlineData failed code: ${result?.code}`)
      return []
    }

    this._onlineCursor = result.data.getNextCursor()
    this.hasMore = result.data.isHasMore()
    let onlineMembers = result.data.getMemberList()

    BIMUILog.info(this._tag, `loadOnlineData: cursor=${this._onlineCursor}, hasMore=${this.hasMore}, memberCount=${onlineMembers.length}`)

    // 去重在线成员中的管理员
    let filteredOnlineMembers = this.deDuplicatesWithUsers(onlineMembers)
    
    BIMUILog.info(this._tag, `loadOnlineData: after deduplication, memberCount=${filteredOnlineMembers.length}`)
    
    // 转换为VELiveUserWrapper
    let onlineWrappers = filteredOnlineMembers.map((member) => new VELiveUserWrapper(BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID()), member, this.isEdit, false))


    return onlineWrappers
  }

  /**
   * 去重在线成员中的管理员
   */
  private deDuplicatesWithUsers(onlineMembers: BIMMember[]): BIMMember[] {
    return onlineMembers.filter(member => {
      let userId = member.getUserID()
      // 如果该用户ID不在管理员集合中，则保留
      return !this._adminUserIds.has(userId)
    })
  }

  public async loadDataWithFirstPage(firstPage: boolean) {
    BIMUILog.info(this._tag, `loadMore start firstPage:${firstPage}`)

    if (!this.hasMore) {
      BIMUILog.info(this._tag, `loadMore not hasMore return`)
      return
    }
    if (this._isLoading === true) {
      BIMUILog.info(this._tag, `loadMore isLoading return`)
      return
    }

    this._isLoading = true;

    try {
      // 优先获取管理员列表
      let adminWrappers: VELiveUserWrapper[] = []
      if (firstPage || this._adminMemberHasMore) {
        adminWrappers = await this.getLiveGroupMemberList()
      }

      // 如果管理员列表为空或已获取完毕，则获取在线成员列表
      let onlineWrappers: VELiveUserWrapper[] = []
      if (adminWrappers.length === 0 || !this._adminMemberHasMore) {
        onlineWrappers = await this.loadOnlineData()
      }

      // 组合数据：管理员在前，在线成员在后
      let combinedList: VELiveUserWrapper[] = []
      if (adminWrappers.length > 0) {
        combinedList.push(...adminWrappers)
      }
      if (onlineWrappers.length > 0) {
        combinedList.push(...onlineWrappers)
      }

      // 更新UI数据
      if (combinedList.length > 0) {
        if (firstPage) { // 第一页数据
          this.data.reload(combinedList)
        } else {
          this.data.appendData(combinedList)
        }
      }

      // 如果管理员还有更多数据，继续加载
      if (this._adminMemberHasMore) {
        this.hasMore = true
      } else {
        // 管理员数据加载完毕，检查在线成员是否还有更多
        this.hasMore = this.hasMore && (onlineWrappers.length > 0)
      }

    } catch (error) {
      BIMUILog.error(this._tag, `loadMore error: ${error}`)
    } finally {
      this._isLoading = false
      BIMUILog.info(this._tag, `loadMore end, hasMore: ${this.hasMore}, adminHasMore: ${this._adminMemberHasMore} count:${this.data.totalCount()}`)
    }
  }
  public async loadMore() {
    this.loadDataWithFirstPage(false)
  }

  public async refresh() {
    BIMUILog.info(this._tag, `refresh()`)
    this._adminCursor = 0
    this._onlineCursor = 0
    this._adminMemberHasMore = true
    this.hasMore = true
    this._isLoading = false
    this._adminUserIds.clear() // 清空管理员用户ID集合
    await this.loadDataWithFirstPage(true)
  }

 async removeMemberList(uidList: string[]) {
    // 实现移除成员列表的逻辑
    let liveService = BIMUIClient.getInstance().getLiveService();
    if (!liveService) {
      return
    }

    let result = await liveService.kickLiveGroupMemberList(this.cid, uidList)
    if (result.code != BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: '移除失败:' + result.code })
    } else {
      IMRouter.pop(uidList)
    }
  }


  onConfirmClick() {
    let r = this.data.selectData();
    let uidList = r.map((user) => {
      return user.uid
    })
    this.removeMemberList(uidList)
  }

}




