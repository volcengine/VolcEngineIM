import { Message } from '../../api/model/Message';
import { Conversation } from '../../api/model/Conversation';
import { Range } from '../../manager/RecentLinkRangeManager';
import { IMDataSource } from './IMDataSource';
/**
 * IMMsgDataSource
 * 消息相关的基本存储接口
 * 函数命名对齐Android
 */
export interface IMMsgDataSource extends IMDataSource {
    /**
     * 根据uuid查询消息是否存在
     * @param conversationId
     * @param msgUuid
     * @returns
     */
    hasMsg(conversationId: string, msgUuid: string): Promise<Nullable<boolean>>;
    /**
     * 根据消息结构中唯一的 Message.msgId 获取消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgServerId 待查询消息的server id @see Message#msgId
     * @returns 返回消息 @see Message
     */
    getMsgByServerId(conversationId: string, msgServerId: bigint): Promise<Nullable<Message>>;
    /**
     * @see getMsgByServerId
     * 根据消息结构中唯一的 Message.msgId 获取消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param queryParams 查询参数
     * @param msgServerId 待查询消息的server id @see Message#msgId
     * @returns 返回消息列表 @see Message
     */
    batchGetMsgByParams(conversationId: Nullable<string>, queryParams: MsgQueryParams): Promise<Nullable<Message[]>>;
    /**
     * 查询会话内消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgUuid 待查询消息的uuid
     * @returns 返回消息 @see Message
     */
    getMsgByUuid(conversationId: string, msgUuid: string): Promise<Nullable<Message>>;
    /**
     * 查询会话内所有消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @returns 返回消息列表 @see Message
     */
    getMsgArray(conversationId: string): Promise<Nullable<Message[]>>;
    /**
     * 从旧到新加载消息
     * @param conversationId 待查询的会话id @see Conversation
     * @param fromMsgOrderIndex 对应消息的order_index
     * @param maxOrderIndex 最大可以加载的order_index，用于考虑连续区间的场景，只会返回连续区间的消息
     * @param limit 限制查询的条数
     * @param msgFilter 消息类型过滤
     * @param includeFromOrderIndex 返回的数据是否包括锚点
     * @returns 查询orderIndex>fromOrderIndex的limit条消息数据 @see Message
     */
    loadNewerMessageList(conversationId: string, fromMsgOrderIndex: string, limit: number, msgFilter?: number[], includeFromOrderIndex?: boolean): Promise<Nullable<Message[]>>;
    /**
     * 加载会话内消息列表之初始化
     * @param conversationId 会话ID
     * @param limit 限制数量
     * @param minOrderIndex 限制最小的orderIndex
     * @param msgFilter 消息类型过滤
     * @returns
     */
    initMessageList(conversationId: string, limit: number, msgFilter?: number[]): Promise<Nullable<Message[]>>;
    /**
     * @see loadNewerMessageList
     * 从新到旧加载消息
     * @param conversationId 待查询的会话id @see Conversation
     * @param fromMsgOrderIndex 对应消息的order_index
     * @param limit 限制查询的条数
     * @param msgFilter 消息类型过滤
     * @param includeFromOrderIndex 返回的数据是否包括锚点
     * @returns 查询orderIndex<fromOrderIndex的limit条消息数据
     */
    loadOlderMessageList(conversationId: string, fromMsgOrderIndex: string, limit: number, msgFilter?: number[], includeFromOrderIndex?: boolean): Promise<Nullable<Message[]>>;
    /**
     * 插入消息
     * @param message
     * @returns true 代表插入成功；false 则失败
     */
    insertMessage(message: Message): Promise<boolean>;
    /**
     * 过滤本地存在的indexV2
     * @param conversationId
     * @param leakIndexList
     * @returns
     */
    checkMissedMsgIndexV2List(conversationId: string, leakIndexList: bigint[]): Promise<bigint[] | undefined>;
    /**
     * 更新消息
     * @param message 待更新消息
     * @param updateProperty 是否更新字段属性
     * @param updateAttachment 是否更新消息附件
     * @returns 返回更新结果
     */
    updateMessage(message: Message, updateProperty?: boolean, updateAttachment?: boolean): Promise<boolean>;
    /**
     * 更新消息version
     * @param conv
     * @param msgUuid
     * @param msgVersion
     */
    updateMsgVersion(conv: string, msgUuid: string, msgVersion: bigint): Promise<boolean>;
    /**
     * 更新消息localExt内容写入到DB
     * @param conversationId 待更新消息所属会话
     * @param msgUuid 待更新消息的uuid
     * @param localExtStr 待更新消息的localExtStr
     * @returns true 更新成功；false 更新失败
     */
    updateMsgLocalExt(conversationId: string, msgUuid: string, localExtStr: string): Promise<boolean>;
    /**
     * 获取最近显示的一条消息
     * @param conversationId
     * @returns
     */
    getLastShowMsg(conversationId: Nullable<string>, useTheadPool?: boolean): Promise<Nullable<Message>>;
    /**
     * 获取自己发送的最后一条消息
     * @param conversationId
     * @param convShortId
     * @returns
     */
    getLastSendMsg(conversationId: string, convShortId: bigint): Promise<Nullable<Message>>;
    /**
     * 获取会话内第一条可显示的消息的indexV1
     * @param conversationId
     * @returns
     */
    getFirstShowMsgIndex(conversationId: Nullable<string>): Promise<bigint>;
    /**
     * 获取最近显示的一条消息
     * @param conversationId
     * @returns
     */
    getLastHintMessage(conversationId: Nullable<string>): Promise<Nullable<Message>>;
    /**
     * 通过Conversation id 获取未读消息的总数
     * @param conversationId
     * @param readIndexV1
     * @returns
     */
    computeUnreadMsgCount(conversationId: string, readIndexV1: bigint): Promise<number>;
    /**
     * 计算两个indexV1之间的消息数
     * @param conversationId
     * @param readIndexV1
     * @returns
     */
    computeMsgCount(conversationId: string, smallIndexV1: bigint, largeIndexV1: bigint): Promise<number>;
    /**
     * 获取会话中最大的index v1
     * @param convId
     * @returns
     */
    getMaxIndexV1(convId: string): Promise<bigint>;
    /**
     * 删除会话等场景，需要获取<=minIndexV1的最大orderIndex，用于标定删除会话时刻，会话内最后一条消息的orderIndex
     * 主要是多端同步或再次进入会话的场景
     * @param convId
     * @returns
     */
    getMaxOrderIndex(convId: string, minIndexV1: bigint): Promise<bigint>;
    /**
     * 根据conversation id删除msg表中的所有message
     * @param conversationId
     * @returns
     */
    forceDeleteAllMsg(conversationId: string): Promise<boolean>;
    /**
     * 获取会话内最后一条消息的created_time，包括已删除的消息
     * @param conversationId 会话
     * @return 最大的created_time
     */
    getMaxMsgCreatedTime(conversationId: string): Promise<number>;
    getLastMsgIndex(conversation: string): Promise<bigint>;
    getMaxIndexV2(conversation: string): Promise<bigint>;
    /**
     * 通过会话id和msg的uuid删除指定消息
     * @param convId
     * @param msgUuid
     * @returns
     */
    deleteMsgByUuid(convId: string, msgUuid: string): Promise<boolean>;
    /**
     * 批量删除会话的消息
     * @param convId
     * @param msgUuidList
     * @returns
     */
    batchDeleteMsg(convId: string, msgUuidList: string[]): Promise<boolean | undefined>;
    /**
     * 查询未读的群主发言
     * @param conversation
     * @returns
     */
    makeUnreadGroupOwnerMsg(conversation: Conversation | undefined): Promise<void>;
    /**
     * 查询会话b2c留咨消息
     * @param conversation
     * @returns
     */
    makeB2cInfoMsg(conversation: Conversation | undefined): Promise<void>;
    /**
     * 批量标记消息已读
     * @param preReadIndex
     * @param afterReadIndex
     * @param convId
     * @returns 返回<cid，标记已读DBsql的结果>
     */
    markLocalMsgRead(preReadIndex: Nullable<bigint>, afterReadIndex: Nullable<bigint>, ...convId: string[]): Promise<Map<string, boolean>>;
    getMsgByIndexV1(convId: string, indexV1: bigint): Promise<Nullable<Message>>;
    getMinOrderIndex(convId: string): Promise<bigint | undefined>;
    /**
     * 查询在给定range内的indexV2消息
     * @param convId
     * @param range
     * @returns
     */
    getIndexV2ListByRange(convId: string, range: Range): Promise<bigint[] | undefined>;
    /**
     * 给定indexV2 range查询消息的orderIndex
     * @param convId
     * @param range
     * @returns
     */
    getOrderIndexByIndexV2(convId: string, range: Range, needRangeMaxOrderIndex: boolean): Promise<bigint>;
    /**
     * 给定orderIndex查询indexInConversation
     * @param convId
     * @param range
     * @returns
     */
    getOrderIndexByIndexInConversation(convId: string, indexInConversation: string): Promise<Nullable<string>>;
    /**
     * 给定indexInConversation查询orderIndex
     * @param convId
     * @param range
     * @returns
     */
    getIndexInConversationByOrderIndex(convId: string, orderIndex: string): Promise<Nullable<string>>;
    /**
     * @param convId
     * @returns 获取会话内最小的orderIndex
     */
    getLegalOldestOrderIndex(convId: string): Promise<bigint>;
    /**
     * 给定indexV2查询消息的indexV1
     * @param convId
     * @param range
     * @returns
     */
    getIndexByIndexV2(convId: string, indexV2: bigint): Promise<bigint | undefined>;
    forceDeleteMsgByMinIndex(convId: string, minIndexV1: bigint): Promise<boolean>;
    getMsgListNeedFtsIndex(limit: number): Promise<Message[]>;
    updateMsgListNeedFtsIndex(msgUuidMap: Map<string, string>): Promise<void>;
    /**
     * 更新消息
     * @returns
     */
    updateMsgByParams(params: MsgUpdateParams): Promise<boolean>;
    markUnSendFail(): Promise<boolean>;
}
/**
 * 查询消息Message时的过滤条件
 */
export interface MsgQueryParams {
    batchMsgServerIdList?: Nullable<string[]>;
    batchMsgUuidList?: Nullable<string[]>;
    readIndexV1?: Nullable<bigint>;
    sortByCreateTimeDes?: boolean;
}
/**
 * 修改更新消息Message相关字段
 */
export interface MsgUpdateParams {
    conversationId: string;
    targetMsgUuid: string;
    msgStatus: Nullable<number>;
}
