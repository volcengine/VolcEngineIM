import { BIMMessageWrapper } from '../data/model/BIMMessageWrapper';
import { BIMUIClient } from '../../../api/BIMUIClient';
import { BIMErrorCode, BIMGetMessageOption, BIMMessage, BIMMessageListener, BIMMessageNewPropertyModify, BIMMessageNewPropertyModifyType, BIMReferenceMessageStatus, BIMTextElement, IMInfoKeys } from '@imcloud/imsdk';
import BIMUILog from '../../../log/BIMUILog';
import { ImageToolBtn } from '../../widget/input/tools/ImageToolBtn';
import { PhotoToolBtn } from '../../widget/input/tools/PhotoToolBtn';
import { FileToolBtn } from '../../widget/input/tools/FileToolBtn';
import { CustomToolBtn } from '../../widget/input/tools/CustomToolBtn';
import { VideoToolBtn } from '../../widget/input/tools/VideoToolBtn';
import { fileUri } from '@kit.CoreFileKit';
import { ShareElement } from '../custom/ShareElement';
import { BIMUIUtils } from '../../../utils/BIMUIUtils';
import { EmojiInfo } from '../../widget/input/viewModel/EmojiHelper';
import { BIMMsgReadModel } from './BIMMsgReadModel';
import { promptAction } from '@kit.ArkUI';
import { AbstractMsgListViewModel } from './AbstractMsgListViewModel';
import { VEBaseTool } from '../../widget/input/viewModel/VEToolsViewModel';

export class BIMMsgListViewModel extends AbstractMsgListViewModel {
  private _tag = "BIMMsgListViewModel"
  private _anchorMessage: BIMMessage | undefined = undefined
  private _hasMore = true;
  private _limit = 20
  private _isLoading = false;
  private isInit = false;
  private readModel: BIMMsgReadModel

  constructor(cid: string) {
    super(cid)
    this.readModel = new BIMMsgReadModel(cid, (msg, readStatus) => {
      this.data.updateReadStatus(msg, readStatus)
    })
    BIMUILog.info(this._tag, `constructor cid: ${cid}`)
  }

  public override startReadRefresh() {
    this.readModel.startRefresh()
  }

  public override stopReadRefresh() {
    this.readModel.stopRefresh()
  }

  public override initToolBtn(tools: VEBaseTool[]) {
    tools.push(new ImageToolBtn((isSuccess, uris) => {
      if (isSuccess && uris.length > 0) {
        uris.forEach((uri) => {
          this.sendImageMessage(uri)
        })
      }
    }))
    this.tools.push(new VideoToolBtn((isSuccess, uris) => {
      if (isSuccess && uris.length > 0) {
        uris.forEach((uri) => {
          this.sendVideoMessage(uri)
        })
      }
    }))
    this.tools.push(new PhotoToolBtn((isSuccess, uri) => {
      if (isSuccess) {
        this.sendImageMessage(uri)
      }
    }))
    this.tools.push(new FileToolBtn((isSuccess, uri) => {
      if (isSuccess) {
        this.sendFileMessage(uri)
      }
    }))
    this.tools.push(new CustomToolBtn(() => {
      this.sendCustomMessage()
    }))
  }


  override async loadMore() {
    if (!this._hasMore) {
      BIMUILog.info(this._tag, `loadMore not hasMore return`)
      return
    }
    if (this._isLoading) {
      BIMUILog.info(this._tag, `loadMore isLoading return`)
      return
    }

    BIMUILog.info(this._tag, `loadMore start orderIndex: ${this._anchorMessage?.getOrderIndex()}`)
    this._isLoading = true;
    // const option = new BIMGetMessageOption(this._anchorMessage, this._limit, true)
    const option = new BIMGetMessageOption()
    option.anchorMessage = this._anchorMessage
    option.limit = this._limit
    const result = await BIMUIClient.getInstance().getHistoryMessageList(this.cid, option)
    if (result.code == BIMErrorCode.BIM_OK || result.data.messageList.length) {
      const pageData = result.data
      this._hasMore = pageData.hasMore
      this._anchorMessage = pageData.anchorMessage
      BIMUILog.info(this._tag, `loadMore end next orderIndex: ${this._anchorMessage?.getOrderIndex()} anchor:${this._anchorMessage?.getContentData()} size:${pageData.messageList.length}`)
      this.data.addOlderData(pageData.messageList)
      if (!this.isInit) {
        this.listScroller.scrollEdge(Edge.Top)
        this.isInit = true
      }
    } else {
      BIMUILog.info(this._tag, `loadMore failed code: ${result.code}}`)
    }
    this._isLoading = false;
    this.updateReadModel()
  }

  /**
   * 所有展示的消息,未读model计算未读数
   */
  private updateReadModel() {
    let msgList: BIMMessage[] = []
    this.data.getAllDataList().forEach((warp) => {
      if (warp.msg) {
        msgList.push(warp.msg)
      }
    })
    this.readModel.waitUpdateMessageList(msgList)
  }

  private get(index: number): BIMMessageWrapper | undefined {
    return this.data.getByIndex(index)
  }

  /**
   * 重发消息
   * @param msg
   */
  override onReSendMessage(msg: BIMMessage) {
    this.sendMessage(msg)
  }

  /**
   * 发文本
   * @param info
   */
  public override onSendText(text: string, refMsg: BIMMessage | undefined, mentionIds: string[]): void {
    this.sendTextMessage(text, [], refMsg, mentionIds)
  }

  override async onLikeEmojiClick(msg: BIMMessage, emojiInfo: EmojiInfo) {
    let type = BIMMessageNewPropertyModifyType.ADD;
    msg.getProperties().forEach((localPropertyItems, emojiValue) => {
      if (emojiInfo.value == emojiValue && localPropertyItems.length > 0) { //匹配到emoji
        localPropertyItems.forEach((item) => {
          if (item.getSender() == BIMUIClient.getInstance().getCurrentUserID()) { //是自己点的赞
            type = BIMMessageNewPropertyModifyType.REMOVE
          }
        })
      }
    })

    let propertyItems: BIMMessageNewPropertyModify[] = []
    let property = new BIMMessageNewPropertyModify()
    property.key = emojiInfo.value
    property.value = "" + BIMUIClient.getInstance().getCurrentUserID()
    property.idempotentID = "" + BIMUIClient.getInstance().getCurrentUserID()
    property.type = type
    propertyItems.push(property)
    let r = await BIMUIClient.getInstance().modifyMessageProperty(msg, propertyItems)
    if (r.code == BIMErrorCode.BIM_OK) {
      BIMUILog.debug(this._tag, `modifyMessageProperty success!`)
    } else {
      BIMUILog.debug(this._tag, `modifyMessageProperty failed! ${r.code}`)
    }
  }

  private sendTextMessage(text: string, atUidList: bigint[] | undefined, ref: BIMMessage | undefined, mentionIds: string[]) {
    BIMUILog.debug(this._tag, `sendTextMessage() text:${text} atLength:${atUidList?.length} ref:${ref?.getUuid()}`)
    let textMessage: BIMMessage | undefined
    if (!atUidList && !ref) {
      textMessage = BIMUIClient.getInstance().createTextMessage(text) //仅发送文本消息
    } else {
      textMessage = BIMUIClient.getInstance().createTextMessageFullInfo(text, mentionIds, ref, BIMUIUtils.generateHint(ref)) //发送完整的问题消息包含 1、at用户 2、ref引用
    }
    if (textMessage) {
      this.sendMessage(textMessage)
    } else {
      BIMUILog.debug(this._tag, `createTextMessage() failed text:${text}`)
    }
  }

  override async onSendEditText(newText: string, oldMsg: BIMMessage, atUidList: string[]) {
    let ext = oldMsg.getExtra()
    let mentionStr = atUidList.reduce<string>((pre, cur, index, array) => {
      return `${pre},${cur}`
    }, "")
    if (mentionStr) {
      ext.set(IMInfoKeys.SDK_MENTION_USER, mentionStr.substring(1));
    }
    let element = oldMsg.getElement() as BIMTextElement
    element.text = newText
    // oldMsg.content = element
    let r = await BIMUIClient.getInstance().modifyMessage(oldMsg)
    if (r && r.code == BIMErrorCode.BIM_OK) {
      BIMUILog.debug(this._tag, `modifyMessage() success`)
    } else {
      BIMUILog.debug(this._tag, `modifyMessage() failed`)
    }
  }


  private async sendImageMessage(uri: string) {
    BIMUILog.debug(this._tag, `sendImageMessage() uri:${uri}`)
    let msg = await BIMUIClient.getInstance().createImageMessage(uri)
    if (msg) {
      this.sendMessage(msg)
    } else {
      BIMUILog.debug(this._tag, `createImageMessage() failed uri:${uri}`)
    }
  }

  private async sendVideoMessage(uri: string) {
    BIMUILog.debug(this._tag, `sendVideoMessage() uri:${uri}`)
    let msg = await BIMUIClient.getInstance().createVideoMessage(uri)
    if (msg) {
      this.sendMessage(msg)
    } else {
      BIMUILog.debug(this._tag, `createVideoMessage() failed uri:${uri}`)
    }
  }

  private async sendFileMessage(uri: string) {
    BIMUILog.debug(this._tag, `sendFileMessage() uri:${uri}`)
    let msg = await BIMUIClient.getInstance().createFileMessage(uri)
    if (msg) {
      this.sendMessage(msg)
    } else {
      BIMUILog.debug(this._tag, `createFileMessage() failed uri:${uri}`)
    }
  }

  private async sendAudioMessage(path: string) {
    let uri = fileUri.getUriFromPath(path)
    BIMUILog.debug(this._tag, `sendAudioMessage() uri:${path}`)
    let msg = await BIMUIClient.getInstance().createAudioMessage(uri,)
    if (msg) {
      this.sendMessage(msg)
    } else {
      promptAction.showToast({ message: "录音时间太短,录音失败" })
      BIMUILog.debug(this._tag, `createAudioMessage() failed uri:${path}`)
    }
  }
  isShowInputPriority(): boolean {
    return false
  }

  private sendCustomMessage() {
    BIMUILog.debug(this._tag, `sendCustomMessage()`)
    let shareElement = new ShareElement("https://www.volcengine.com/", "欢迎体验火山引擎即时通信IM Demo")
    let msg = BIMUIClient.getInstance().createCustomMessageWithElement(shareElement)
    if (msg) {
      this.sendMessage(msg)
    } else {
      BIMUILog.debug(this._tag, `createCustomMessage() failed`)
    }
  }

  private sendMessage(msg: BIMMessage) {
    BIMUIClient.getInstance().sendMessage(msg, this.cid, {
      onProgress: (message: BIMMessage, progress: number) => {
        BIMUILog.debug(this._tag, `sendMessage() onProgress:${message.getUuid()} progress:${progress}`)
        this.data.updateProgress(message, progress)
      },
      onSaved: (message: BIMMessage) => {
        BIMUILog.debug(this._tag, `sendMessage() onSaved:${message.getUuid()}`)
        this.data.insertOrUpdateMsg(message, true)
        this.data.updateSendStatus(message)
        this.listScroller.scrollEdge(Edge.Top)
      },
      onSuccess: (message: BIMMessage) => {
        BIMUILog.debug(this._tag, `sendMessage() onSuccess:${message.getUuid()} indexInConversation:${message.innerMessage.indexInConversation}`)
        this.data.updateSendStatus(message)
        this.updateReadModel()
      },
      onError: (message: BIMMessage, code: BIMErrorCode) => {
        BIMUILog.debug(this._tag, `sendMessage() onError:${message.getUuid()} content:${msg.innerMessage.content} status:${message.getMsgStatus()}`)
        if (code == BIMErrorCode.BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
          promptAction.showToast({ message: "消息发送失败: 文件大小超过限制" })
          return
        }

        this.data.updateSendStatus(message)
        this.listScroller.scrollEdge(Edge.Top)
      }
    })
  }

  private msgListener: BIMMessageListener = {
    onReceiveMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this._tag, `onReceiveMessage() onSuccess:${message.getUuid()} isAtEnd: ${this.listScroller.isAtEnd()}`)
      if (message.getConversationID() == this.cid) {
        this.data.insertOrUpdateMsg(message, true)
        // if (this.listScroller.isAtEnd()) {
        this.listScroller.scrollEdge(Edge.Top)
        // }
        this.markConversationRead() //标记一下已读
      }
    },
    onSendMessage: (message: BIMMessage): void => {
      if (message.getConversationID() == this.cid) {
        BIMUILog.debug(this._tag, `onSendMessage() uuid:${message.getUuid()}`)
      }
    },
    onDeleteMessage: (message: BIMMessage): void => {
      if (message.getConversationID() == this.cid) {
        BIMUILog.debug(this._tag, `onDeleteMessage() uuid:${message.getUuid()}`)
        this.data.deleteMessage(message)
      }
    },
    onRecallMessage: (message: BIMMessage): void => {
      BIMUILog.debug(this._tag, `onRecallMessage() uuid:${message.getUuid()}`)
      this.data.updateRecall(message)
    },
    onUpdateMessage: (message: BIMMessage): void => {
      if (message.getConversationID() == this.cid) {
        BIMUILog.debug(this._tag, `onUpdateMessage() uuid:${message.getUuid()} indexInConversation:${message.innerMessage.indexInConversation}`)
        let needUpdate = this.needUpdate(message) //版本号升级了
        let refUpdate = false
        let refMsg = message.getReferenceInfo()?.getRefMessage() //引用的消息
        if (refMsg) {
          let isDelete = message.getReferenceInfo()?.getRefStatus() == BIMReferenceMessageStatus.BIM_REFERENCE_MESSAGE_STATUS_DELETED ?? false //引用的消息删除了
          let isRecall = message.getReferenceInfo()?.getRefStatus() == BIMReferenceMessageStatus.BIM_REFERENCE_MESSAGE_STATUS_RECALLED ?? false //引用的消息撤回了
          let isEdit = refMsg?.getEditInfo()?.isEdit() ?? false //引用的消息编辑了
          BIMUILog.debug(this._tag, `onUpdateMessage() refMsg isDelete:${isDelete} isRecall:${isRecall} isEdit:${isEdit} content:${message.getContentData()}`)
          refUpdate = isDelete || isRecall || isEdit
        }
        BIMUILog.debug(this._tag, `onUpdateMessage() needUpdate:${needUpdate} refUpdate:${refUpdate} refMsg: ${refMsg?.getContentData()} content:${message.getContentData()}`)
        let isUIRefresh = needUpdate || refUpdate
        if (isUIRefresh) {
          this.data.insertOrUpdateMsg(message, true)
        } else {
          this.data.insertOrUpdateMsg(message, false)
        }
        this.updateReadModel()
      }
    }
  }

  override addListener() {
    BIMUIClient.getInstance().addMessageListener(this.msgListener)
  }

  override removeListener() {
    BIMUIClient.getInstance().removeMessageListener(this.msgListener)
  }

  override async markConversationRead() {
    let markResult = await BIMUIClient.getInstance().markConversationRead(this.cid)
    BIMUILog.debug(this._tag, `markConversationRead() markResult code:${markResult.code} isSuccess:${markResult.data}`)
  }


  override onRecordAudioComplete(path: string): void {
    BIMUILog.debug(this._tag, `onRecordAudioComplete() path:${path}`)
    this.sendAudioMessage(path)
  }

  override onRecordAudioCancel(): void {
    BIMUILog.debug(this._tag, `onRecordAudioCancel()`)
  }

  public needUpdate(msg: BIMMessage): boolean {
    let oldMsg = this.data.getMsgWrapByUUId(msg.getUuid())
    if (oldMsg) {
      let oldVersion = oldMsg.msg?.getVersion() ?? "0"
      let newVersion = msg.getVersion()
      BIMUILog.debug(this._tag, `newVersion:${newVersion} oldVersion:${oldVersion}`)
      return newVersion > oldVersion
    }
    return false
  }

  public override onReadListClick(msg: BIMMessage | undefined) {
    if (msg) {
      this.readModel.showReadList(msg)
    }
  }
}