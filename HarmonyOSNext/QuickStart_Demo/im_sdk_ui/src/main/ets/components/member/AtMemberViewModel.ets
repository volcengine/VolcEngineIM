import { MemberDataSource } from './MemberDataSource'
import { BIMUIClient } from '../../api/BIMUIClient'
import { BIMConversation, BIMConversationType, BIMErrorCode, BIMMember } from '@imcloud/imsdk'
import { MemberWrapper } from './MemberWrapper'

export class AtMemberViewModel {
  conversationId: string =""
  data: MemberDataSource = new MemberDataSource()
  conv: BIMConversation | undefined
  isShowAtAll = true

  constructor() {

  }

  public init(cid:string){
    this.conversationId = cid
    this.initData()
  }

  private async initData() {
    let r = await BIMUIClient.getInstance().getConversation(this.conversationId)
    this.conv = r.data
    this.isShowAtAll = this.conv?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT
    let result = await BIMUIClient.getInstance().getConversationMemberList(this.conversationId)
    if (result.code == BIMErrorCode.BIM_OK) {
      let memberList = result.data.map((member) => {
        return new MemberWrapper(member)
      })
      this.data.initData(memberList)
    }
  }

}