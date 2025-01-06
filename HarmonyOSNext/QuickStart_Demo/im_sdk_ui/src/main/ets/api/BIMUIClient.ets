import {
  BIMActionType,
  BIMClient,
  BIMConnectListener,
  BIMCustomElement,
  BIMMember,
  BIMMessageNewPropertyModify,
  BIMSDKConfig,
  MessageReadStatusModel,
  ParticipantIndexInfo,
  BIMMemberRole,
  BIMMarkMessageListLoadResult,
  BIMMessageReadStatusModel,
  BIMConversationListResult,
  BIMResult,
  BIMConversation,
  BIMConversationListListener,
  BIMErrorCode,
  BIMGetMessageOption,
  BIMMessage,
  BIMMessageListener,
  BIMMessageListResult,
  BIMSendCallback,
  BIMUnReadInfo,
  BIMSyncServerListener,
  BIMSilentMemberInfo
} from '@imcloud/imsdk';
import { BIMUserProvider } from './BIMUserProvider';
import { DefaultUserProvider } from '../user/DefaultUserProvier';
import { MsgUIManager } from '../components/msg/manager/MsgUIManager';
import { BIMUIUtils } from '../utils/BIMUIUtils';
import { EmojiHelper } from '../components/widget/input/viewModel/EmojiHelper';
import { elementBuilder, MsgCustomElementManager } from '../components/msg/manager/MsgCustomElementManager';
import { BaseCustomElement } from '../components/msg/custom/BaseCustomElement';
import { MsgOptManager } from '../components/widget/input/msgpop/opt/MsgOptManager';
import { checkPermissionGrant, reqPermissionsFromUser } from '../components/utils/CheckPermissin';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import BIMUILog from '../log/BIMUILog';
import picker from '@ohos.file.picker';
import fileUri from '@ohos.file.fileuri';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';

//uisdk为单例
export class BIMUIClient {
  private static _instance: BIMUIClient = new BIMUIClient()
  private _userProvider: BIMUserProvider = new DefaultUserProvider()
  private _uid: string = ""
  private _msgUIManager: MsgUIManager
  private _msgOptManager: MsgOptManager;

  public get msgOptManager(): MsgOptManager {
    return this._msgOptManager;
  }

  private _msgEleManager: MsgCustomElementManager
  private _context: Context | undefined

  public get msgUIManager(): MsgUIManager {
    return this._msgUIManager;
  }

  public get uid(): string {
    return this._uid;
  }

  private constructor() {
    this._msgUIManager = new MsgUIManager()
    this._msgEleManager = new MsgCustomElementManager()
    this._msgOptManager = new MsgOptManager()
  }

  public static getInstance(): BIMUIClient {
    return BIMUIClient._instance;
  }

  private _imClient: BIMClient | undefined

  public async init(context: Context, appID: number, config: BIMSDKConfig = new BIMSDKConfig(), env: number = 0, lane: string = "") {
    //1. 构造实例
    this._imClient = new BIMClient(context, appID, config, env, lane)
    //2. 初始化，注意: 需使用 await 等待异步初始化完成
    await this._imClient.init()
    this._context = context
    EmojiHelper.getInstance().init(context)
  }

  async login(uid: string, token: string): Promise<boolean> {
    this._uid = uid;
    return this._imClient?.login(uid, token) ?? false
  }

  /**
   * @param listener 长链状态监听方，参看 BIMConnectListener{@link #BIMConnectListener}。
   * @type api
   * @brief 设置长链状态监听。
   */
  public addConnectListener(listener: BIMConnectListener): boolean {
    return this._imClient?.addConnectListener(listener) ?? false
  }

  public addSyncServerListener(listener: BIMSyncServerListener): boolean {
    return this._imClient?.addSyncServerListener(listener) ?? false
  }

  /**
   * @param listener 长链状态监听方，参看 BIMConnectListener{@link #BIMConnectListener}。
   * @type api
   * @brief 设置长链状态监听。
   */
  public removeConnectListener(listener: BIMConnectListener): boolean {
    return this._imClient?.removeConnectListener(listener) ?? false
  }

  /**
   * @param cursor   分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
   * @param count    分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 100 个会话。
   * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversationListResult{@link #BIMConversationListResult}。
   * @type api
   * @brief 获取会话列表。
   * @notes <br>
   * + 历史会话数量可能很多，因此建议采用分页查询的方式进行接口调用。
   * + 该接口拉取的是本地缓存的会话。若服务器会话有更新，SDK 内部会自动同步，并通过 BIMResultCallback{@link #BIMResultCallback} 回调告知用户。
   * + 如果会话全部拉取完毕，结果回调 BIMResultCallback{@link #BIMResultCallback} 中的 hasMore 获取字段值为 false。
   */
  public async getConversationList(cursor: number, count: number): Promise<BIMResult<BIMConversationListResult>> {
    if (this._imClient) {
      return this._imClient?.getConversationList(cursor, count)
    } else {
      return new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, new BIMConversationListResult(0, false, []))
    }
  }

  /**
   * @param conversationId 会话 ID。
   * @param callback       结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
   * @type api
   * @brief 获取指定单个会话。
   */
  public async getConversation(conversationId: string,): Promise<BIMResult<Nullable<BIMConversation>>> {
    return this._imClient?.getConversation(conversationId) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }

  /**
   * @param draft          草稿内容。
   * @param conversationId 会话 ID。
   * @type api
   * @brief 设置会话草稿。
   */
  public async setConversationDraft(draft: string, conversationId: string) {
    await this._imClient?.setConversationDraft(draft, conversationId)
  }

  /**
   * @param conversationId 会话 ID。
   * @param option         获取消息选项，参看 BIMGetMessageOption{@link #BIMGetMessageOption}。
   * @param callback       结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessageListResult{@link #BIMMessageListResult}。
   * @type api
   * @brief 获取历史消息（锚点之前的消息），返回消息顺序从新到旧。
   */
  public async getHistoryMessageList(conversationId: string, option: BIMGetMessageOption): Promise<BIMResult<BIMMessageListResult>> {
    if (this._imClient) {
      return this._imClient.getHistoryMessageList(conversationId, option)
    } else {
      return new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, new BIMMessageListResult(undefined, false, []))
    }
  }

  /**
   * @param listener 消息监听方，参看 BIMMessageListener{@link #BIMMessageListener}。
   * @type api
   * @brief 设置消息监听。
   */
  public addMessageListener(listener: BIMMessageListener): boolean {
    return this._imClient?.addMessageListener(listener) ?? false
  }

  public async markMessage(msg: BIMMessage, actionType: BIMActionType, isMark: boolean, sortTime: number, tag: number): Promise<BIMResult<boolean>> {
    return this._imClient?.getINService()?.markMessage(msg, actionType, isMark, sortTime, tag) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  public async fetchMarkedMessage(cid: string, actionType: BIMActionType, tag: number, asc: boolean, cursor: bigint, limit: number, clearUnreadCount: boolean): Promise<BIMResult<BIMMarkMessageListLoadResult>> {
    return this._imClient?.getINService()?.fetchMarkedMessage(cid, actionType, tag, asc, cursor, limit, clearUnreadCount) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, new BIMMarkMessageListLoadResult())
  }

  public async setConversationSilent(conversationId: string, isSilent: boolean, silentNormalOnly: boolean): Promise<BIMResult<boolean>> {
    return this._imClient?.getINService()?.setConversationSilent(conversationId, isSilent, silentNormalOnly) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  public async setMemberSilent(conversationId: string, silentMemberInfo: BIMSilentMemberInfo[],
    bizMap?: Map<string, string>): Promise<BIMResult<string[]>> {
    return this._imClient?.getINService()?.setMemberSilent(conversationId, silentMemberInfo, bizMap) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, [])
  }

  public async setMemberUnSilent(conversationId: string, silentMemberInfo: BIMSilentMemberInfo[],
    bizMap?: Map<string, string>): Promise<BIMResult<string[]>> {
    return this._imClient?.getINService()?.setMemberUnSilent(conversationId, silentMemberInfo, bizMap) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, [])
  }

  /**
   * @param listener 消息监听方，参看 BIMMessageListener{@link #BIMMessageListener}。
   * @type api
   * @brief 移除消息监听。
   */
  public removeMessageListener(listener: BIMMessageListener): boolean {
    return this._imClient?.removeMessageListener(listener) ?? false
  }

  /**
   * @param listener 会话监听方，参看 BIMConversationListListener{@link #BIMConversationListListener}。
   * @type api
   * @brief 添加会话监听。
   */
  public addConversationListener(listener: BIMConversationListListener): boolean {
    return this._imClient?.addConversationListener(listener) ?? false
  }


  /**
   * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMUnReadInfo{@link #BIMUnReadInfo}。
   * @type api
   * @brief 获取所有会话的未读消息总数。
   * @notes 会话未读消息不包括设置为免打扰会话中的未读消息。
   */
  public async getTotalUnreadMessageCount(): Promise<BIMUnReadInfo> {
    return this._imClient?.getTotalUnreadMessageCount() ?? new BIMUnReadInfo(0, 0)
  }

  /**
   * @param listener 会话监听方，参看 BIMConversationListListener{@link #BIMConversationListListener}。
   * @type api
   * @brief 移除会话监听。
   */
  public removeConversationListener(listener: BIMConversationListListener) {
    return this._imClient?.removeConversationListener(listener) ?? false
  }


  /**
   * @param conversationId 会话 ID。
   * @type api
   * @brief 标记会话已读。
   */
  public async markConversationRead(conversationId: string): Promise<BIMResult<boolean>> {
    return this._imClient?.markConversationRead(conversationId) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param ids 待添加的群成员 ID 列表。
   * @type api
   * @brief 添加群成员。
   */
  public async addGroupMemberList(conversationId: string, ids: string[]): Promise<BIMResult<boolean>> {
    return this._imClient?.addGroupMemberList(conversationId, ids) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param 待移除的群成员 ID 列表。
   * @type api
   * @brief 移除群成员。
   */
  public async removeGroupMemberList(conversationId: string, ids: string[]): Promise<BIMResult<boolean>> {
    return this._imClient?.removeGroupMemberList(conversationId, ids) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param uidList 需要更改身份的群成员列表。
   * @param role 群组角色，参看 BIMMemberRole{@link #BIMMemberRole}。
   * @type api
   * @brief 设置群成员角色。
   */
  public async setGroupMemberRole(conversationId: string, uidList: string[], role: BIMMemberRole): Promise<BIMResult<boolean>> {
    return this._imClient?.setGroupMemberRole(conversationId, uidList, role) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param isDeleteLocal 是否在本地删除。
   * @type api
   * @brief 解散群组。
   */
  public async dissolveGroup(conversationId: string, isDeleteLocal: boolean): Promise<BIMResult<boolean>> {
    return this._imClient?.dissolveGroup(conversationId, isDeleteLocal) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param isDeleteServer 是否在服务器删除。
   * @type api
   * @brief 离开群组。
   */
  public async leaveGroup(conversationId: string, isDeleteServer: boolean): Promise<BIMResult<boolean>> {
    return this._imClient?.leaveGroup(conversationId, isDeleteServer) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param name 群组名称。
   * @type api
   * @brief 设置群组名称。
   */
  public async setGroupName(conversationId: string, name: string): Promise<BIMResult<boolean>> {
    return this._imClient?.setGroupName(conversationId, name) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param notice 群公告内容。
   * @type api
   * @brief 设置群公告。
   */
  public async setGroupNotice(conversationId: string, notice: string): Promise<BIMResult<boolean>> {
    return this._imClient?.setGroupNotice(conversationId, notice) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param ext          会话本地额外信息。
   * @type api
   * @brief 设置会话本地额外信息。
   */
  public async setConversationLocalExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>> {
    return this._imClient?.setConversationLocalExt(conversationId, ext) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param ext          会话本地额外信息。
   * @type api
   * @brief 设置会话私有额外信息。
   */
  public async setConversationMyExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>> {
    return this._imClient?.setConversationMyExt(conversationId, ext) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param ext          会话本地额外信息。
   * @type api
   * @brief 设置会话额外信息。
   */
  public async setConversationCoreExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>> {
    return this._imClient?.setConversationCoreExt(conversationId, ext) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param isStickTop 是否置顶。
   * @type api
   * @brief 置顶会话。
   */
  public async stickTopConversation(conversationId: string, isStickTop: boolean): Promise<BIMResult<boolean>> {
    return this._imClient?.stickTopConversation(conversationId, isStickTop) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param conversationId 会话 ID。
   * @param isMute 是否设置为免打扰。
   * @type api
   * @brief 设置会话免打扰。
   */
  public async muteConversation(conversationId: string, isMute: boolean): Promise<BIMResult<boolean>> {
    return this._imClient?.muteConversation(conversationId, isMute) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param toUid    对方用户 ID。
   * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
   * @type api
   * @brief 创建单聊会话。
   */
  public async createSingleConversation(toUid: string): Promise<BIMResult<BIMConversation | undefined>> {
    return this._imClient?.createSingleConversation(toUid) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }

  /**
   * @param uidList  用户 ID 列表。
   * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
   * @type api
   * @brief 创建群聊。
   */
  public async createGroupConversation(uidList: string[]): Promise<BIMResult<BIMConversation | undefined>> {
    return this._imClient?.createGroupConversation(uidList) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }

  /**
   * @param conversationId 会话 ID。
   * @param callback       群成员列表回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMember{@link #BIMMember}。
   * @type api
   * @brief 获取群成员。
   */
  public async getConversationMemberList(conversationId: string): Promise<BIMResult<BIMMember[]>> {
    return this._imClient?.getConversationMemberList(conversationId) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, [])
  }

  /**
   * @param bimMessage 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @param callback   结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 刷新媒体信息，媒体 URL 过期时调用该方法。
   */
  public async refreshMediaMessage(bimMessage: BIMMessage): Promise<BIMResult<Nullable<BIMMessage>>> {
    return this._imClient?.refreshMediaMessage(bimMessage) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }


  /**
   * @param conversationId 会话 ID。
   * @param callback       结果回调，参看 BIMSimpleCallback{@link #BIMSimpleCallback}。
   * @type api
   * @brief 通过会话 ID 删除会话。
   * @notes 调用本接口后，SDK 会从本地和服务端删除该会话及会话中的历史消息，且不可恢复。
   */
  public async deleteConversation(conversationId: string): Promise<BIMResult<boolean>> {
    return this._imClient?.deleteConversation(conversationId) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param bimMessage 待删除的消息，参看 BIMMessage{@link #BIMMessage}。
   * @param callback   结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 删除本地和服务端消息。
   */
  public async deleteMessage(bimMessage: BIMMessage): Promise<BIMResult<boolean>> {
    return this._imClient?.deleteMessage(bimMessage) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param message  待撤回的消息，参看 BIMMessage{@link #BIMMessage}。
   * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 撤回消息。
   */
  public async recallMessage(message: BIMMessage): Promise<BIMResult<boolean>> {
    return this._imClient?.recallMessage(message) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param message  待更新的消息
   * @param callback 结果回调, 参看 BIMResultCallback{@link #BIMResultCallback},BIMMessage{@link #BIMMessage}
   * @type api
   * @brief 修改消息内容和ext。
   */
  public async modifyMessage(message: BIMMessage): Promise<BIMResult<Nullable<BIMMessage>>> {
    return this._imClient?.modifyMessage(message) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }

  /**
   * @param message       待修改属性的消息，参看 BIMMessage{@link #BIMMessage}。
   * @param propertyItems 更新的消息属性，参看 BIMMessageNewPropertyModify{@link #BIMMessageNewPropertyModify}。
   * @param callback      结果回调，参看 BIMSimpleCallback{@link #BIMSimpleCallback}。
   * @type api
   * @brief 批量修改消息属性。
   */
  public async modifyMessageProperty(message: BIMMessage, propertyItems: BIMMessageNewPropertyModify[]): Promise<BIMResult<boolean>> {
    return this._imClient?.modifyMessageProperty(message, propertyItems) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }

  /**
   * @param message  待更新的消息，参看 BIMMessage{@link #BIMMessage}。
   * @param localExt 本地扩展信息。
   * @param completion 结果回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
   * @type api
   * @brief 修改消息本地扩展信息。
   */
  public async setMessageLocalExt(message: BIMMessage, localExt: Map<string, string>): Promise<BIMResult<Nullable<BIMMessage>>> {
    return this._imClient?.setMessageLocalExt(message, localExt) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, undefined)
  }

  /**
   * @param text 消息文本。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建文本消息。
   */
  public createTextMessage(text: string): BIMMessage | undefined {
    return this._imClient?.createTextMessage(text)
  }

  /**
   * @param text       消息文本。
   * @param atUidList  需要 @ 的用户列表。
   * @param refMessage 引用的消息，参看 BIMMessage{@link #BIMMessage}。
   * @param hint       业务透传引用信息，无法动态编辑。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建带引用消息的文本消息。
   */
  public createTextMessageFullInfo(text: string, atUidList?: string[], refMessage?: BIMMessage, hint?: string): BIMMessage | undefined {
    return this._imClient?.createTextMessageFullInfo(text, atUidList, refMessage, hint)
  }


  /**
   * @param path 图片路径。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建图片消息。
   * @notes 若图片来自系统相册，需要先把图片导入 App 目录下。
   */
  public async createImageMessage(uri: string): Promise<Nullable<BIMMessage>> {
    return this._imClient?.createImageMessage(uri)
  }

  /**
   * @param uri 视频路径。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建视频消息。
   * @notes 若视频来自系统相册，需要先把视频导入 App 目录下。
   */
  public async createVideoMessage(uri: string): Promise<Nullable<BIMMessage>> {
    return this._imClient?.createVideoMessage(uri)
  }

  /**
   * @param uri      文件 URI。
   * @param path     文件路径。
   * @param fileName 文件名称。
   * @param length   文件大小。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建文件消息。
   */
  public async createFileMessage(uri: string): Promise<Nullable<BIMMessage>> {
    return this._imClient?.createFileMessage(uri)
  }


  /**
   * @param uri  音频 URI。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建语音消息。
   */
  public async createAudioMessage(uri: string): Promise<Nullable<BIMMessage>> {
    return this._imClient?.createAudioMessage(uri)
  }

  /**
   * @param data 自定义参数。
   * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
   * @type api
   * @brief 创建自定义消息。
   */
  public createCustomMessageWithElement(element: BaseCustomElement): Nullable<BIMMessage> {
    return this._imClient?.createCustomMessage(JSON.stringify(element))
  }

  public createCustomMessage(data: string): Nullable<BIMMessage> {
    return this._imClient?.createCustomMessage(data)
  }

  /**
   * 标记所有会话是否已读
   *
   * @param markType 标记类型
   */
  public async markAllConversationRead(): Promise<BIMResult<boolean>> {
    return this._imClient?.getINService()?.markAllConversationRead() ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, false)
  }


  /**
   * 从服务端同步成员readIndex,需要业务进入回话后循环调用刷新
   * @param conversationId
   * @returns 返回<cid,<uid,readIndex>>
   */
  public async refreshConversationUidRead(conversationIdList: string[]): Promise<Map<string, Map<bigint, ParticipantIndexInfo>>> {
    return this._imClient?.getINService()?.refreshConversationUidRead(conversationIdList) ?? new Map()
  }


  /**
   * 停止刷新
   * @param conversationId
   */
  public stopRefresh(conversationId: string) {
    this._imClient?.getINService()?.stopRefresh(conversationId)
  }

  /**
   * 从本地获取已读、未读成员
   * @param conversationId
   */
  public async getMessageUidRead(conversationId: string, bimMessage: BIMMessage): Promise<BIMMessageReadStatusModel> {
    return this._imClient?.getINService()?.getMessageUidRead(conversationId, bimMessage) ?? new BIMMessageReadStatusModel([], [], bimMessage.getConversationID(), bimMessage.getServerMsgId(), bimMessage.getSendUid())
  }

  /**
   * @param conversationId 会话 ID，如果为空则全局搜索
   * @param key 关键词
   * @param completion 完成回调，参看 BIMSearchMsgInfo{@link #BIMSearchMsgInfo}。
   * @type api
   * @brief 搜索本地消息。
   */
  public async searchLocalMessage(conversationId: string, key: string): Promise<BIMResult<BIMMessage[]>> {
    return this._imClient?.searchLocalMessage(conversationId, key) ?? new BIMResult(BIMErrorCode.BIM_SDK_NOT_READY, [])
  }

  /**
   * @return 用户 ID。
   * @type api
   * @brief 获取当前用户 ID。
   */
  public getCurrentUserID(): string {
    return this._imClient?.getCurrentUserID() ?? "0"
  }

  /**
   * @return 当前 appID
   * @type api
   * @brief 获取当前 appID。
   */
  public getAppID(): number {
    return this._imClient?.getAppID() ?? 0
  }

  /**
   * @return SDK 版本号名称。
   * @type api
   * @brief 获取 SDK 版本号名称。
   */
  public getVersion(): string {
    return this._imClient?.getVersion() ?? "";
  }

  /**
   * @return
   * @hidden 获取当前环境
   */
  public getEnv(): number {
    return this._imClient?.getEnv() ?? -1;
  }

  /**
   * @return SDK 版本号。
   * @type api
   * @brief 获取 SDK 版本号。
   */
  public getVersionCode(): number {
    return this._imClient?.getVersionCode() ?? 0;
  }


  /**
   * @return 设备 did。
   * @type api
   * @brief 获取设备 did。
   */
  public getSDKDid(callBack: (did: string) => void) {
    this._imClient?.getSDKDid(callBack)
  }


  public async sendMessage(message: BIMMessage, conversationId: string, sendCallback?: BIMSendCallback) {
    await this._imClient?.sendMessage(message, conversationId, sendCallback)
  }

  public setUserProvider(provider: BIMUserProvider) {
    this._userProvider = provider
  }

  public getUserProvider(): BIMUserProvider {
    return this._userProvider
  }


  public fullScreen() {
    if (this._context) {
      BIMUIUtils.fullScreen(this._context)
    }
  }

  public getStatusHeight(): number {
    return BIMUIUtils.STATUS_HEIGHT
  }

  public getNavHeight(): number {
    return BIMUIUtils.NAVIGATION_HEIGHT
  }

  public logout() {
    this._imClient?.logout()
  }

  public parseCustomElement(customElement: BIMCustomElement): BaseCustomElement {
    return this._msgEleManager.getCustomElement(customElement)
  }

  public getContext() {
    return this._context
  }

  public static isTob(): boolean {
    return BIMClient.isTob()
  }

  public onAppForegroundChang(isForeground: boolean) {
    this._imClient?.onAppForegroundChang(isForeground)
  }

  /**
   * 导出日志
   * 起止时间
   */
  public async downloadLog(context: common.UIAbilityContext): Promise<string> {
    let logPath = `${context.filesDir}/imlog`
    console.error(`BIMUIClient downLoad log start logPath: ${logPath}`);
    let downLoadUri = ""
    try {
      let documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;
      let documentPicker = new picker.DocumentViewPicker(context);
      let documentSaveResult = await documentPicker.save(documentSaveOptions)
      downLoadUri = documentSaveResult[0];
      let uriString = new fileUri.FileUri(documentSaveResult[0]);
      BIMUILog.debug("BIMUIClient", `downLoad log pick path :${downLoadUri} uri:${uriString}`);
      await fileIo.copyDir(logPath, uriString.path, 1);
    } catch (err) {
      BIMUILog.debug("BIMUIClient", `downLoad log failed with err:${JSON.stringify(err)}`);
      return downLoadUri
    }
    BIMUILog.debug("BIMUIClient", `downloadLog success downLoadPath:${downLoadUri}`)
    return downLoadUri
  }
}