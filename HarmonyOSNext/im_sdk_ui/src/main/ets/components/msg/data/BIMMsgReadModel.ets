import { BIMClient, BIMMessage, BIMMessageReadStatusModel, MessageReadStatusModel } from '@imcloud/imsdk';
import { BIMUIClient } from '../../../api/BIMUIClient';
import { promptAction } from '@kit.ArkUI';
import BuildProfile from '../../../../../../BuildProfile';

export class BIMMsgReadModel {
  readonly tag = "BIMMsgReadModel"
  private conversationId: string
  private readonly refreshTime = 3000;
  private isStop = false
  private isEnableLooper = !BIMUIClient.isTob()
  private updateMsgList: BIMMessage[] = [] //显示出来的部分
  private onMsgReadChange: (bimMessage: BIMMessage, readStatus: BIMMessageReadStatusModel) => void = () => {
  }

  constructor(cid: string, onMsgReadChange: (uuid: BIMMessage, readStatus: BIMMessageReadStatusModel) => void) {
    this.conversationId = cid
    this.onMsgReadChange = onMsgReadChange
  }

  public waitUpdateMessageList(msgList: BIMMessage[]) {
    console.debug(`${this.tag} waitUpdateMessageList ${msgList.length}`)
    this.updateMsgList = msgList
    this.calculate("waitUpdateMessageList") //立即计算
  }

  public async startRefresh() {
    console.debug(`${this.tag} startRefresh() ${this.conversationId}`)
    if (!this.isEnableLooper) {
      return
    }
    this.looperRun()
  }

  public looperRun() { //循环计算
    console.debug(`${this.tag} looperRun() msgListSize:${this.updateMsgList.length}`)
    if (this.isStop) {
      return
    }
    setTimeout(async () => {
      this.calculate("Loop")
      this.looperRun()
    }, this.refreshTime)
  }

  /**
   * 计算消息未读
   */
  private async calculate(reason: string) {
    console.debug(`${this.tag} calculateRead reason: ${reason}`)
    await BIMUIClient.getInstance().refreshConversationUidRead([this.conversationId])
    this.updateMsgList.forEach(async (msg) => {
      let readInfo = await BIMUIClient.getInstance().getMessageUidRead(this.conversationId, msg)
      let readIdStr = "["
      readInfo.readUidList.forEach((id) => {
        readIdStr += `${id},`;
      })
      readIdStr += ']'
      console.debug(`${this.tag} calculate() readIdStr:${readIdStr}`)
      this.onMsgReadChange(msg, readInfo)
    })
  }

  public stopRefresh() {
    console.debug(`${this.tag} stopRefresh() ${this.conversationId}`)
    this.isStop = true
    BIMUIClient.getInstance().stopRefresh(this.conversationId)
  }

  public async showReadList(msg: BIMMessage) {
    let readInfo = await BIMUIClient.getInstance().getMessageUidRead(this.conversationId, msg)
    let uidListStr = readInfo.readUidList.reduce((pre, cur) => `${pre},${cur}`, "")
    if (uidListStr.length > 0) {
      uidListStr = uidListStr.substring(1)
    }
    promptAction.showToast({ message: `已读:${uidListStr}` })
  }
}