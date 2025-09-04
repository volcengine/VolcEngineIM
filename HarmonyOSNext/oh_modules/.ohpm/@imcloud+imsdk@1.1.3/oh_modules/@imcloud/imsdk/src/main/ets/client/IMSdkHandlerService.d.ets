import { IMSdkContext } from './IMSdkContext';
import { Message } from '../api/model/Message';
import { Conversation } from '../api/model/Conversation';
import { MessageListLoadResult } from '../observer/IMessageObserver';
import { GetUserMsgParams } from '../handler/params/GetUserMsgParams';
import { LoadHistoryMsgParams } from '../handler/params/LoadHistoryMsgParams';
import { GetRecentStrangerHandlerMultiInstanceExt } from '../handler/stranger/GetRecentStrangerHandlerMultiInstanceExt';
import { SetConversationCoreParams } from '../handler/params/SetConversationCoreParams';
import { ConversationAuditListResult } from '../api/bean/group/ConversationAuditListResult';
import { ConversationAuditSwitchResult } from '../api/bean/group/ConversationAuditSwitchResult';
import { ConversationApplyAckResult } from '../api/bean/group/ConversationApplyAckResult';
import { LoadMsgByIndexV2RangeParams } from '../handler/params/LoadMsgByIndexV2RangeParams';
import { LoadMsgByIndexV2RangeResult } from '../handler/message/LoadMsgByIndexV2RangeHandler';
import { LeakMsgRepairToOldInfo } from '../handler/message/LeakMsgRepairToOldHandler';
import { LoadMsgByIndexV1Params } from '../handler/params/LoadMsgByIndexV1Params';
import { GetGroupSettingInfoParams } from '../handler/params/GetGroupSettingInfoParams';
import { im_proto } from '../api/proto';
import { UpdateGroupParams } from '../handler/params/UpdateGroupParams';
import { Member } from '../api/model/Member';
import { RemoveMemberParams } from '../handler/params/RemoveMemberParams';
import { SilentMemberInfo } from '../api/model/SilentMemberInfo';
import { GetSpecifiedMsgResult } from '../handler/group/GetSpecifiedMsgListHandler';
import { ConversationAuditUnReadResult } from '../api/bean/group/ConversationAuditUnReadResult';
import { IMResult } from '../api/bean/IMHandlerResult';
import { ModifyMsgPropertyMsg } from '../api/model/MessageProperty';
import { MessageReadStatusModel } from '../api/bean/message/MessageReadStatusModel';
import { ConversationInfoUpdateParams } from '../helper/WaitChecker';
import { IMInitHandler } from '../handler/IMInitHandler';
import { SaveConvResult } from '../handler/GetUserMsgHandler';
import { BIMSendCallback } from '../bim/api/interface/BIMSendCallback';
import { IMUploadTokenInfo } from '@imcloud/imsdk_common';
import { Attachment } from '../api/model/Attachment';
import { BIMResult } from '../bim/api/model/BIMResult';
import { ParticipantIndexInfo } from '../api/model/ParticipantIndexInfo';
import { BIMMarkMessageListLoadResult } from '../handler/message/FetchMarkMessageHandler';
import { SendTrace } from '../bim/report/BIMMessageReporter';
import Long from 'long';
/**
 * 提供IMSDK所有对外暴露的Handler的操作
 * 对应android IMHandlerCenter
 */
export declare class IMSdkHandlerService {
    protected readonly context: IMSdkContext;
    private _sendMsgHandler?;
    private _getRecentStrangerHandlerMultiInstanceExt?;
    constructor(context: IMSdkContext);
    initIM(inboxType: number): IMInitHandler;
    getGetRecentStrangerHandlerMultiInstanceExt(): GetRecentStrangerHandlerMultiInstanceExt;
    /**
     * 发送消息
     * @param msg
     * @returns true 发送成功
     */
    sendMessage(msg: Message, sendCallback: BIMSendCallback, sendTrace?: SendTrace): Promise<boolean>;
    /**
     * 编辑消息内容
     * @param convId 会话id
     * @param msgUuid 消息id
     * @param newMsgContent 编辑后的消息内容
     * @param extMap 附带的业务map
     * @returns 返回编辑后的消息数据结构
     */
    modifyMessageContent(convId: string, msgUuid: string, newMsgContent: string, extMap: Nullable<Map<string, string>>): Promise<IMResult<Message>>;
    /**
     * 消息属性编辑
     * @param msgProperty
     * @returns
     */
    modifyMessageProperty(msgProperty: ModifyMsgPropertyMsg): Promise<IMResult<ModifyMsgPropertyMsg>>;
    /**
     * 添加一条消息到数据库，一般为提示消息，不会实际发送
     * @param msg 待写入DB的消息
     * @returns true 写入成功
     */
    addMessage(msg: Message): Promise<boolean>;
    getMessageByUser(inboxType: number, params: GetUserMsgParams): Promise<boolean>;
    getConfig(): Promise<string>;
    checkToken(appId: number, uid: Long): Promise<boolean>;
    /**
     * 删除会话
     * @param convId 会话id
     * @param isLocal 是否是本地会话
     * @returns 删除成功则返回该会话的id；否则返回undefined
     */
    deleteConversation(convId: string, isLocal: boolean): Promise<IMResult<string>>;
    loadHistoryMessage(params: LoadHistoryMsgParams): Promise<IMResult<MessageListLoadResult>>;
    updateConversationCoreInfo(params: SetConversationCoreParams): Promise<IMResult<Conversation>>;
    /**
     * 消息补洞API请求
     * 根据消息缺失区间加载该区间的消息
     * @param params 消息缺失区间信息
     * @returns 返回对应区间内的消息加载结果
     */
    loadLeakMsgByIndexV2Range(params: LoadMsgByIndexV2RangeParams): Promise<Nullable<LoadMsgByIndexV2RangeResult>>;
    /**
     * 根据某一个位置消息的index往特定方向（往新、往旧方向）去加载历史消息。属于历史兼容产物，鸿蒙不再需要
     * @see loadLeakMsgByIndexV2Range
     * @param params
     * @returns
     */
    loadLeakMsgByIndexV1(params: LoadMsgByIndexV1Params): Promise<LeakMsgRepairToOldInfo | undefined>;
    deleteMessage(msg: Message, isLocal?: boolean): Promise<Nullable<Message>>;
    getUploadToken(tokenType: im_proto.MediaTokenType): Promise<IMUploadTokenInfo | undefined>;
    getMediaUrlImageX(attach: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getMediaUrlFileImageX(attach: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getMediaUrlVideo(attach: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getMediaUrlAudio(attach: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getReadIndex(cidList: string[]): Promise<Map<string, Map<bigint, ParticipantIndexInfo>>>;
    /**
     * 批量删除消息
     * @param msgList
     * @param isLocal
     * @returns
     */
    batchDeleteMessage(msgList: Message[], isLocal?: boolean): Promise<Nullable<boolean>>;
    /**
     * 撤回消息
     * @param msg 待撤回的消息
     * @returns 操作成功则返回对应的消息数据结构；否则返回undefined
     */
    recallMessage(msg: Message): Promise<IMResult<Message>>;
    /**
     * 本地有会话、根据会话id获取最新的会话信息
     * @param convId
     * @returns
     */
    getConversationInfoByLocalExist(convId: string, force?: boolean): Promise<Nullable<SaveConvResult>>;
    /**
     * 本地没有会话、根据会话id、shortId、会话type去获取最新的会话信息
     * @param convId
     * @param convShortId
     * @param convType
     * @returns
     */
    getConversationInfoByLocalAbsent(inboxType: number, convId: string, convShortId: bigint, convType: number, force?: boolean): Promise<Nullable<SaveConvResult>>;
    /**
     * 本地没有会话、此时收到新的消息，拉取会话信息
     * @param convId
     * @returns
     */
    getConversationInfoByNewMsgReceived(inboxType: number, message: Message, badgeCount: number, force: boolean, filterLocalMap: Nullable<Map<string, string>>): Promise<Nullable<SaveConvResult>>;
    /**
     * 批量获取会话信息
     * @param params
     * @returns
     */
    getConversationInfoList(inboxType: number, msgMap: Map<string, im_proto.IMessageBody>, params: ConversationInfoUpdateParams): Promise<void>;
    /**
     * 创建单聊
     * @param inboxType
     * @param id
     * @returns
     */
    createSingleConversation(uid: string, inboxType?: Nullable<number>): Promise<IMResult<Conversation>>;
    /**
     * 创建群聊
     * @param inboxType
     * @param uidList
     * @returns
     */
    createGroupConversation(uidList: string[], groupName?: Nullable<string>, extMap?: Nullable<Map<string, string>>, inboxType?: number): Promise<IMResult<Conversation>>;
    /**
     * 解除会话/群聊
     * @param convId
     * @param deleteLocal true 仅标记删除；false 解散群聊
     * @param needPullConv true 如果本地没有会话则会拉取群聊会话信息
     */
    dissolveConversation(convId: string, deleteLocal: boolean, needPullConv: boolean): Promise<IMResult<string>>;
    /**
     * 退出群聊
     * @param convId 会话id
     * @param isReqDelete 是否请求接口执行删除会话请求
     * @returns true代表操作成功
     */
    leaveConversation(convId: string, isReqDelete?: boolean): Promise<IMResult<boolean>>;
    /**
     * 获取群聊设置信息
     * @param params
     * @returns
     */
    getGroupSettingInfo(params: GetGroupSettingInfoParams): Promise<IMResult<im_proto.IGetGroupManagerInfoResponseBody>>;
    /**
     * 更新群聊设置信息
     * @param params
     * @returns
     */
    updateGroup(params: UpdateGroupParams): Promise<IMResult<boolean>>;
    /**
     * 查询群成员的readIndex，查询未读消息的位置
     * @param conversationId
     * @returns
     */
    getConversationReadIndex(conversationId: string): Promise<IMResult<im_proto.ParticipantReadIndex[]>>;
    /**
     * 查询群成员的minIndex，查询最小可读的消息位置
     * @param conversationId
     * @returns
     */
    getConversationMinIndex(conversationId: string): Promise<IMResult<im_proto.ParticipantMinIndex[]>>;
    /**
     * 加载会话/群聊的全部成员
     * @param convId 会话id
     */
    loadMembers(convId: string): Promise<Member[]>;
    /**
     * 将toAddUserIdList拉进会话群聊
     * @param convId 会话id
     * @param convShortId 会话shortId
     * @param toAddMembersUidList 期望加入群聊的用户uid
     * @param bizExtMap 配置信息Map结构
     * @param convType 会话的Type，默认是 @see im_proto.ConversationType.GROUP_CHAT
     * @param inboxType 默认是 @see InBoxType.DEFAULT
     * @returns 加入群聊的member数据结构list
     */
    addMember(convId: string, convShortId: bigint, toAddMembersUidList: string[], bizExtMap: Map<string, string>, convType?: number, inboxType?: number): Promise<IMResult<Member[]>>;
    /***
     * 将成员移除群聊
     * @param inboxType
     * @param params 接口参数
     * @returns 返回实际移除群聊的成员
     */
    removeMember(inboxType: number, params: RemoveMemberParams): Promise<IMResult<Member[]>>;
    /**
     * 批量设置群成员禁言
     * @param convId 会话id
     * @param silentMemberInfo 待禁言群成员
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberSilent(convId: string, silentMemberInfo: SilentMemberInfo[], bizMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 批量解除群成员禁言
     * @param convId 会话id
     * @param silentMemberInfo 待解除禁言的群成员
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberUnSilent(convId: string, silentMemberInfo: SilentMemberInfo[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 解除成员禁言
     * @param convId 会话id
     * @param uidList 待解除禁言的群成员列表
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberUnSilentByUid(convId: string, uidList: string[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 设置会话禁言状态
     * @param convId 会话id
     * @param isSilent true 会话禁言；false 解除禁言
     * @param silentNormalOnly  只禁言普通成员，默认是所有人都被禁言
     * @returns
     */
    setConversationSilent(convId: string, isSilent: boolean, silentNormalOnly: boolean): Promise<IMResult<boolean>>;
    /**
     * @param convId 会话id
     * @returns 返回convId参数指代的会话数据结构
     */
    markConversationRead(convId: string): Promise<Nullable<Conversation>>;
    markAllConversationRead(): Promise<BIMResult<boolean>>;
    /**
     * @param 收藏消息
     * @returns 返回convId参数指代的会话数据结构
     */
    markMessage(cid: string, messageId: bigint, type: im_proto.ActionType, isMark: boolean, sortTime: number, tag: number): Promise<BIMResult<boolean>>;
    /**
     * @param 标记消息列表
     * @returns 返回标记消息列表
     */
    fetchMarkedMessage(cid: string, type: im_proto.ActionType, tag: number, asc: boolean, cursor: bigint, limit: number, clearUnreadCount: boolean): Promise<BIMResult<BIMMarkMessageListLoadResult>>;
    /**
     * 轻量更新会话个人维度的配置附加信息，只更新特定的key-value
     * @param convId
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingKv(convId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 全量更新会话个人维度的全部配置附加信息
     * 轻量的数据更新建议使用 upsertSettingKv
     * @param convId
     * @param ext 新的配置信息，server会直接使用其作为会话的最新配置信息
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingExtMap(convId: string, extMap: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 更新会话全局配置的附加信息，只处理特定的key-value
     * 如果希望全量更新会话全局配置则使用extMap👇
     * @see upsertCoreExtMap
     * @param convId
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtKv(convId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 更新会话全局配置的附加信息，注意会全量覆盖更新
     * 轻量的数据更新建议仅更新对应的 key-value👇
     * @see upsertCoreExtKv
     * @param convId
     * @param ext  附加信息字段，注意会全量覆盖更新。如果需要清除原来的赋值，ext的value传空字符串即可
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtMap(convId: string, ext: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 批量更新会话个人配置信息
     * @param conversationIdList
     * @param key
     * @param value
     * @param needPush
     * @returns 返回批量操作成功的会话集合
     */
    batchUpsertSettingExtForLabel(conversationIdList: string[], key: string, value: string, needPush: boolean): Promise<Nullable<Conversation[]>>;
    /**
     * 批量更新会话个人配置信息 for 盒子，目前Android已经下线了
     * @param convShortIdList 批量更新会话的ConvShortIdList
     * @param type
     * @returns 返回批量操作成功的会话集合
     */
    batchUpsertBoxSettingExt(conversationShortIds: string[], type: string): Promise<Nullable<Conversation[]>>;
    /**
     * 修改群成员的群备注名
     * @param convId
     * @param uid
     * @param alias
     * @param map
     * @returns 修改成功后返回该成员Member数据结构；否则返回undefined
     */
    changeMemberAlias(convId: string, uid: string, alias: string, map?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    /**
     * 设置群成员的权限
     * @param uid 用户id
     * @param role 权限等级
     * @see removeMemberRole
     * @param map
     * @returns 更新成功则返回对应群成员；否则返回undefined
     */
    setMemberRole(convId: string, uid: string, role: im_proto.GroupRole, map?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    /**
     * 批量设置群成员的权限
     * @param convId
     * @param toUpdateUidList
     * @param role
     * @param map
     * @returns 修改成功后返回所有更新成功的成员Member结构；否则返回undefined
     */
    batchChangeMemberRole(convId: string, toUpdateUidList: string[], role: im_proto.GroupRole, map?: Nullable<Map<string, string>>): Promise<Nullable<Member[]>>;
    /**
     * 设置会话置顶
     * @param convId
     * @param stickTop
     * @returns 操作成功则返回true；失败返回false；异常情况则返回undefined
     */
    changeStickTop(convId: string, stickTop: boolean): Promise<IMResult<Conversation>>;
    /**
     * 设置会话静音
     * @param convId
     * @param mute
     * @returns 操作成功则返回true；失败返回false；异常情况则返回undefined
     */
    changeMute(convId: string, mute: boolean): Promise<IMResult<Conversation>>;
    reportUnreadCount(inbox: number, needCheck: boolean, totalUnreadCount: number, showTotalUnread: number): Promise<boolean>;
    getSpecifiedMessageList(convId: string, type: im_proto.ConversationMessageListType, offset: bigint, count: bigint): Promise<IMResult<GetSpecifiedMsgResult>>;
    /**
     * 加载审批列表
     * @returns
     */
    getConversationAuditList(cursor: bigint, limit: number, conversationShortId: bigint): Promise<IMResult<ConversationAuditListResult>>;
    /**
     * 获取审批开关
     */
    getConvAuditSwitchStatus(conversationShortId: bigint, conversationType: number): Promise<IMResult<ConversationAuditSwitchResult>>;
    /**
     * 更新审批开关
     */
    updateConvAuditSwitchStatusExt(conversationShortId: bigint, conversationType: number, openAudit: boolean, ext?: Map<string, string>): Promise<IMResult<boolean>>;
    /**
     * 进群申请
     */
    sendConversationApply(conversationShortId: bigint, conversationType: number, map?: Map<string, string>): Promise<IMResult<boolean>>;
    /**
     * 进群审批
     */
    ackConversationApply(applyId: bigint, status: boolean, map?: Map<string, string>): Promise<IMResult<ConversationApplyAckResult>>;
    /**
     * 获取未读审批
     */
    getConversationAuditUnread(withUserPromptInfo: boolean): Promise<IMResult<ConversationAuditUnReadResult>>;
    /**
     * 批量获取未读审批
     */
    batchGetConversationAuditUnread(withUserPromptInfo: boolean, conversationIdList: bigint[]): Promise<IMResult<ConversationAuditUnReadResult>>;
    /**
     * 对应Android的batchGetMessageReadStatusModel
     * 批量获取消息的已读状态
     */
    batchGetConversationReadIndex(messages: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    /**
     * 标记审批已读
     */
    markReadAllAudit(conversationShortId: bigint): Promise<boolean>;
}
