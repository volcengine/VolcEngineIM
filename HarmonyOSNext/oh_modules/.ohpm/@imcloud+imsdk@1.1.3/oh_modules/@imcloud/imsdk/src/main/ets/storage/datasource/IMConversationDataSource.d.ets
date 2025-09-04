import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { UnreadCountInfo } from '../../helper/UnreadCountHelper';
import { StrangerBox } from '../../observer/IStrangerBoxObserver';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationDataSource
 * conversation相关的基本存储接口
 * 数据库sql操作，比如insert、update等操作，建议使用Promise<number>返回db插入/更新的影响记录数，方便业务自定义使用(比如需要感知实际db插入/更新的记录数)
 */
export interface IMConversationDataSource extends IMDataSource {
    getAllConversations(queryParams?: QueryParams): Promise<Conversation[]>;
    getConversationList(cursor: number, limit: number): Promise<Conversation[]>;
    /**
     * 仅用于会话完整性检验
     * @returns 返回本地的所有会话id->及其对应的是否删除 的map
     */
    getAllConversationIdDeletedFlagMap(): Promise<Map<string, number>>;
    /**
     * 获取所有未打标签的会话
     * @param labelList
     * @param limit
     * @returns
     */
    getAllUnlabeledConversations(labelList: Set<string>[], limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 获取特定标签的会话
     * @param labelList
     * @param isMute
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getTargetLabeledConversations(labelList: string[], isMute: boolean, maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 获取禁言的会话
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getMuteConversations(maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 获取未读的会话列表
     * @param maxSortOrder
     * @param limit
     * @returns
     */
    getUnreadConversations(maxSortOrder?: bigint, limit?: number, useBizUnreadCount?: boolean): Promise<Nullable<Conversation[]>>;
    /**
     * 获取特定标签的会话的所有未读数
     * @param labelList
     * @param isMute
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getTargetLabeledConversationsUnreadCount(labelList: string[], isMute: boolean): Promise<number>;
    /**
     * 获取已打标签的会话数量
     * @param labelList
     * @returns
     */
    getLabeledConversationCount(labelList: Set<string>[]): Promise<number>;
    /**
     *
     * 获得符合标签要求的最新会话
     * 背景：春节活动需要查有没有 30天内有发言的 社交群 ,人数20以下
     * @param labelList
     * @param limit
     * @returns
     */
    getNewestConversationByLabels(labelList: string[], limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 批量更新会话标签
     * @param conversations
     * @returns
     */
    batchUpdateConversationLabel(conversations: Conversation[]): Promise<boolean>;
    /**
     * 本地是否有会话数据
     * @param conversationId
     * @returns true DB存在会话
     */
    hasConversation(conversationId: Nullable<string>): Promise<boolean>;
    /**
     * 查询陌生人会话
     * @param inboxType
     * @param limit
     * @param maxUpdatedTime
     * @param minUpdateTime
     * @param minVersion
     * @param isFilterUnread
     * @returns
     */
    getStrangerConversations(inboxType: number, limit: number, maxUpdatedTime?: number, minUpdateTime?: number, minVersion?: bigint, isFilterUnread?: boolean): Promise<Nullable<Conversation[]>>;
    getStrangerBox(inboxType: number): Promise<Nullable<StrangerBox>>;
    /**
     * 陌生人标记已读
     * @param inboxType
     */
    markStrangerRead(inboxType: number): Promise<Nullable<string[]>>;
    /**
     * 本地是否有会话数据
     * @param conversationId
     * @returns true DB存在会话
     */
    hasConversation(conversationId: Nullable<string>): Promise<boolean>;
    /**
     * 根据会话id查询会话数据结构
     * @param conversationId
     * @param includeDeletedConversation 默认为false，表示已删除的会话查询不出来
     * @returns
     */
    getConversation(conversationId: Nullable<string>, includeDeletedConversation?: boolean): Promise<Nullable<Conversation>>;
    /**
     *
     * @param conversationList 待插入的会话
     * @returns 返回sql成功的会话集合列表
     */
    insertOrUpdateConversations(conversationList: Conversation[]): Promise<Conversation[]>;
    /**
     * @param conversation 待插入的会话
     * @returns true 成功或失败
     */
    insertOrUpdateConversation(conversation: Conversation): Promise<boolean>;
    /**
     * 发送消息后更新会话的lastMsg
     * @param astMessage
     * @returns 大于0则为成功，否则失败；实际为数据库sql执行的结果
     */
    updateLastMsgToConversation(astMessage?: Message): Promise<number>;
    /**
     * 更新会话排序依据的时间戳
     * @param astMessage
     * @returns true 标识成功
     */
    updateConversationOrderTimestamp(conversationId: string, orderTimestamp: number): Promise<boolean>;
    /**
     * 更新会话判断未读数降级的时间戳
     * @param astMessage
     * @returns true 标识成功
     */
    updateConversationUnreadDowngradeTime(conversationId: string, unreadDowngradeTime: number): Promise<boolean>;
    /**
     * 更新会话最后更新时间
     * @param conversationId
     * @param updateTime
     * @returns
     */
    setConversationTime(conversationId: string, updateTime: number): Promise<boolean>;
    /**
     * 在会话列表loadMore/加载更多会话
     * @param fromSortOrder UI列表上最后一条会话的sortOrder
     * @param limit 想要加载的会话数
     * @returns 返回查询得到的会话列表
     */
    loadConversationList(fromSortOrder: number, limit: number): Promise<Conversation[] | undefined>;
    computeUnreadCount(conversation: Conversation): Promise<number>;
    /**
     * 退出群聊
     * @param convId
     * @returns
     */
    leaveConversation(convId: string): Promise<boolean>;
    deleteConversationById(...convId: string[]): Promise<number>;
    /**
     * 删除所有的陌生人会话
     * 陌生人会话未使用标记删除，直接冲数据库中删除
     * @param inboxType
     * @returns
     */
    deleteAllStranger(inboxType: number): Promise<boolean>;
    /**
     * 标记群聊已解散
     * @param convId 会话id
     * @returns true标识成功
     */
    dissolveConversation(convId: string): Promise<Nullable<boolean>>;
    /**
     * 标记会话删除
     * @param convId
     * @param conversation
     * @returns
     */
    markConversationDelete(convId: string, conversation?: Nullable<Conversation>): Promise<number>;
    /**
     * 更新会话localExt信息写入DB
     * @param conversation
     * @returns
     */
    updateConversationLocalExt(conversation: Conversation): Promise<boolean>;
    /**
     * 判断是否需要将会话的sortOrder变更同步到DB
     * @param conversation
     * @returns true 需要同步DB并通知业务update会话 @see updateConversationSortOrder
     */
    regulateSortOrder(conversation: Conversation): boolean;
    /**
     * 轻量的更新会话数据，将一批要更新的字段放到UpdateConversationParams一并更新，优化Android的多次更新逻辑
     * @param updateParams
     * @returns
     */
    updateConversationLightWeight(updateParams: UpdateConversationParams): Promise<Nullable<boolean>>;
    getBizUnreadCountMap(): Promise<Map<string, UnreadCountInfo>>;
    setConversationHasMore(convId: string, hasMore: boolean): Promise<number>;
    setConversationDisplayed(convId: string, displayed: number): Promise<Nullable<boolean>>;
    /**
     * 需要计算sortOrder的会话列表
     * @returns
     */
    getNeedUpdateSortOrderConversation(): Promise<Nullable<Conversation[]>>;
    /**
     * 批量更新会话列表的sortOrder
     * @param conversations
     * @returns
     */
    batchUpdateConversationSortOrder(conversations: Conversation[]): Promise<boolean>;
    getConversationReadIndex(cid: string): Promise<bigint>;
    /**
     * 会话移入移出折叠盒子
     * @param convId
     * @param mode
     * @returns
     */
    addOrRemoveConversationFromFoldBox(convId: string, mode: number): Promise<boolean>;
}
export declare class UpdateConversationParams {
    conversationId: Nullable<string>;
    conversationType?: Nullable<number>;
    updatedTime?: Nullable<number>;
    sortOrder?: Nullable<number>;
    lastShowMsgUuid?: Nullable<string>;
    lastHintMessageUuid?: Nullable<string>;
    isMember?: Nullable<boolean>;
    memberCount?: Nullable<number>;
    minIndexV1?: Nullable<bigint>;
    minIndexV2?: Nullable<bigint>;
    draftTime?: Nullable<number>;
    draftContent?: Nullable<string>;
    status?: Nullable<number>;
    isStranger?: Nullable<boolean>;
    strangerVersion?: Nullable<number>;
}
export interface QueryParams {
    /**
     * 查询多少条限制
     */
    limit?: number;
    /**
     * 调用者是否希望拿到已经被删除的会话，因此设计一个字段 includeDeleted
     *
     * 是否包含已标记删除的会话
     */
    includeDeleted?: boolean;
}
