import { BIMErrorCode, BIMMemberRole } from "@imcloud/imsdk"
import { BIMSilentMemberInfo } from "@imcloud/imsdk"
import { BIMUIClient } from "@imcloud/im_sdk_ui"
import { VEUserWrapper } from "../../create/VEUserWrapper"
import { promptAction } from "@kit.ArkUI"
import { IMPage, IMRouter } from "@imcloud/imapp_router"


export class VEInternalDetailConversationViewModel {
  private tag = "VEInternalDetailConversationViewModel"
  private cid: string = ""

  constructor(cid: string) {
    this.cid = cid
  }

  async jumpToMemberSilentPage() {
    let wrapperArray = await this.getUserWrapperList()
    let arg = new Map<string, string|boolean|object>()
    arg.set("title", '设置成员禁言')
    arg.set('isEdit', true)
    arg.set('userList', wrapperArray)

    IMRouter.push(
      IMPage.IM_UI_MEMBER_LIST,
      arg,
      (popInfo) => {
        this.silentUidList(popInfo.result as string[])
      })
  }

  async getUserWrapperList(): Promise<VEUserWrapper[]> {
    let wrapperArray: VEUserWrapper[] = []
    let result = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
    if (result.data) {
      let normalArray: VEUserWrapper[] = []
      let adminArray: VEUserWrapper[] = []
      result.data.forEach((member) => {
        let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(member.getUserID())
        let wrapper = new VEUserWrapper(userInfo, member, true, false)
        wrapper.isSelect = member.getSilent() > 0 ? true : false
        switch (member.getRole()) {
          case BIMMemberRole.BIM_MEMBER_ROLE_OWNER: // 只有一个
            wrapperArray.push(wrapper)
            break;
          case BIMMemberRole.BIM_MEMBER_ROLE_ADMIN:
            adminArray.push(wrapper)
            break;
          default:
            normalArray.push(wrapper)
        }
      })
      wrapperArray = wrapperArray.concat(adminArray, normalArray)
    }

    return wrapperArray
  }

  async silentUidList(uidList: string[]) {
    let mResult = await BIMUIClient.getInstance().getConversationMemberList(this.cid)
    if (!mResult.data) {
      return
    }
    let oldIDList: string[] = []
    mResult.data.forEach((member) => {
      if (member.getSilent() > 0) {
        oldIDList.push(member.getUserID().toString())
      }
    })

    let selectedIDList: string[] = uidList
    let addedList: string[] = selectedIDList.filter(x=>!oldIDList.includes(x))
    let removedList: string[] = oldIDList.filter(x=>!selectedIDList.includes(x))

    let addSilentInfos: BIMSilentMemberInfo[] = []
    addedList.forEach((item) => {
      let silentInfo = new BIMSilentMemberInfo(item, 0)
      addSilentInfos.push(silentInfo)
    })

    let removeSilentInfos: BIMSilentMemberInfo[] = []
    removedList.forEach((item) => {
      let silentInfo = new BIMSilentMemberInfo(item, 0)
      removeSilentInfos.push(silentInfo)
    })

    if (addSilentInfos.length) {
      let addResult = await BIMUIClient.getInstance().setMemberSilent(this.cid, addSilentInfos, undefined)
      if (addResult.code != BIMErrorCode.BIM_OK) {
        promptAction.showToast({message: '设置成员禁言失败:' + addResult.code })
      } else {
        // promptAction.showToast({message: '设置成员禁言成功' + addResult.data })
      }
    }

    if (removeSilentInfos.length) {
      let removeResult = await BIMUIClient.getInstance().setMemberUnSilent(this.cid, removeSilentInfos, undefined)
      if (removeResult.code != BIMErrorCode.BIM_OK) {
        promptAction.showToast({message: '移除成员禁言失败:' + removeResult.code })
      } else {
        // promptAction.showToast({message: '移除成员禁言成功' + removeResult.data })
      }
    }
  }
}
