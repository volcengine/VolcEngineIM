import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VEUserHorizonSource } from '../../components/hor/VEUserHorizonSource'
import { promptAction } from '@kit.ArkUI'

enum VEUserAddShowType {CreateChat = 0, AddParticipants = 1}

export class VECreateGroupViewModel {
  private readonly tag = "veUserAdd"
  cid: string | undefined
  userAddShowType: VEUserAddShowType = VEUserAddShowType.CreateChat
  data: VEUserHorizonSource = new VEUserHorizonSource()
  allIdList: string[] = []
  // addCount: number = 0
  editUid: string = ""
  members: string[] = []

  constructor(cid: string | undefined = undefined, userAddShowType: VEUserAddShowType = VEUserAddShowType.CreateChat) {
    this.cid = cid
    this.userAddShowType = userAddShowType
    this.initMembers()
  }

 async initMembers() {
   if (this.userAddShowType == VEUserAddShowType.AddParticipants) {
     let r = await BIMUIClient.getInstance().getConversationMemberList(this.cid as string)
     r.data.forEach((member) => {
       this.members.push(member.getUserID())
     })
   }
  }

  onAddClick() {
    BIMUILog.debug(this.tag, `onConfirm uid:${this.editUid}`)
    let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(this.editUid)
    this.data.addData(userInfo)
    this.allIdList.push(userInfo.uid)
  }

  tryAddClick() {
    if (!this.editUid.length) {
      return
    }

    let uid = this.editUid
    if (this.allIdList.includes(uid)) {
      promptAction.showToast({message: '群成员已添加'})
      return
    }

    if (uid == BIMUIClient.getInstance().getCurrentUserID()) {
      promptAction.showToast({message: '您已在群聊中'})
      return
    }

    if (this.members.includes(uid)) {
      promptAction.showToast({message: '用户已在群'})
      return
    }

    if (this.allIdList.length >= 20) {
      promptAction.showToast({message:  `已添加${this.allIdList.length}个用户`})
    }

    this.onAddClick()
    this.editUid = ""
  }

  onConfirm(): string[] {
    BIMUILog.debug(this.tag, `onConfirm userList length:${this.allIdList.length}`)
    return this.allIdList
  }

  onRemove(uidList: string[]) {
    this.allIdList = this.allIdList.filter((id) => {
      let findIndex = uidList.indexOf(id)
      console.debug("qinxue",`id:${id} findIndex${findIndex}}`)
      return findIndex<0
    })
    this.data.clear()
    this.allIdList.forEach((uid) => {
      let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid)
      this.data.addData(userInfo)
    })
  }
}