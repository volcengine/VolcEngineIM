import { IMPage, IMRouter } from "@imcloud/imapp_router";
import { BIMErrorCode, BIMMemberRole, BIMResult } from "@imcloud/imsdk";
import { BIMLiveMemberListResult } from "@imcloud/imsdk/src/main/ets/live/api/model/BIMLiveMemberListResult";
import { BIMUIClient } from "@imcloud/im_sdk_ui";
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog";
import { VELiveUserWrapper } from "../VELiveUserWrapper";
import { VELiveMemberDataSource } from "./VELiveMemberDataSource";
import { promptAction } from "@kit.ArkUI";

@Observed
export class VELiveSilentWhiteViewModel {
  private _tag = "liveSilentWhite"
  data: VELiveMemberDataSource = new VELiveMemberDataSource();
  isEdit: boolean = false
  private cid: string = ''
  private _cursor = 0
  public  hasMore = true;
  private _limit = 20
  private _isLoading = false;

  async setCid(cid: string) {
    this.cid = cid
    if (cid.length) {
       this.updateEditState()
    }
  }

  async updateEditState() {
    let liveService = BIMUIClient.getInstance().getLiveService()
    if (!liveService) {
      return
    }
    let r = await liveService.getLiveGroup(this.cid)
    if (r.data) {
      let role = r.data.getCurrentMember()?.getRole()
      this.isEdit = (role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN)
    }
  }

  public async loadMore() {
    BIMUILog.info(this._tag, `loadMore start`)

    if (!this.hasMore) {
      BIMUILog.info(this._tag, `loadMore not hasMore return`)
      return
    }
    if (this._isLoading === true) {
      BIMUILog.info(this._tag, `loadMore isLoading return`)
      return
    }

    this._isLoading = true;

    let liveService = BIMUIClient.getInstance().getLiveService()
    if (!liveService) {
      return
    }

    let result = await liveService.getLiveGroupMemberSilentWhiteList(this.cid, this._cursor, this._limit)
    if (result.code == BIMErrorCode.BIM_OK) {
      BIMUILog.info(this._tag, `loadMore success length: ${result?.data?.getMemberList().length}`)
      let memberList = result.data.getMemberList()
      let lastCursor = this._cursor
      this._cursor = result.data.getNextCursor()
      this.hasMore = result.data.isHasMore()

      let list = memberList.map((member) => new VELiveUserWrapper(BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID()), member, false, false))
      if (lastCursor == 0) { // 第一页数据
        this.data.reload(list)
      } else {
        this.data.appendData(list)
      }
    } else {
      BIMUILog.info(this._tag, `loadMore failed code: ${result?.code}`)
    }

    this._isLoading = false;
  }

  public async refresh() {
    BIMUILog.info(this._tag, `refresh()`)
    this._cursor = 0
    this.hasMore = true;
    this._isLoading = false;
    await this.loadMore()
  }

  onConfirmClick():string[] {
    let r = this.data.selectData();
    return r.map((user) => {
      return user.uid
    })
  }

  // 增加禁言白名单
  jumpToAddSilentWhiteList() {
    let arg = new Map<string, string | boolean | number>()
    arg.set('limit', 1000)
    arg.set("title", '禁言白名单')
    arg.set("editable", true)

    IMRouter.push(
      IMPage.IM_UI_TEXT_INPUT,
      arg,
      async (popInfo) => {
        let liveService = BIMUIClient.getInstance().getLiveService();
        if (!liveService) {
          return
        }

        let map = popInfo.result as Map<string, string>
        let cid = this.cid
        // let result = await liveService.setLiveGroupMemberAvatar(cid, map.get('content') as string)
        let uidList: string[] = (map.get('content') as string).split(" ");
        let result = await liveService.addLiveGroupMemberSilentWhiteList(this.cid, uidList)
        if (result.code != BIMErrorCode.BIM_OK) {
          promptAction.showToast({ message: '添加白名单失败:' + result.code })
        } else {
          this.refresh()
        }
      }
    )
  }

  // 移除白名单列表
   removeSilentWhiteList(uid: string) {
    promptAction.showActionMenu({
      buttons: [
        {
          text: '移除成员',
          color: '#666666'
        }
      ]
    }).then(async data => {
      console.info('showActionMenu success, click button: ' + data.index);
      let liveService = BIMUIClient.getInstance().getLiveService();
      if (!liveService) {
        return
      }
      let result = await liveService.removeLiveGroupMemberSilentWhiteList(this.cid, [uid])
      if (result.code != BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: '移除失败:' + result.code })
      } else {
        this.refresh()
      }
    })
  }
}




