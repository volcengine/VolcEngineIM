import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationDataSource, QueryParams, UpdateConversationParams } from '../datasource/IMConversationDataSource';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { UnreadCountInfo } from '../../helper/UnreadCountHelper';
import { StrangerBox } from '../../observer/IStrangerBoxObserver';
/**
 * IMConversationDao
 * 会话表
 */
export declare class IMConversationDao extends IMSdkBaseObject implements IMConversationDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    /**
     * 更新conversation会话的localExt信息到DB
     * @param conversation
     * @returns
     */
    updateConversationLocalExt(conversation: Conversation): Promise<boolean>;
    /**
     * 从数据库中loadMore加载会话
     * @param fromSortOrder 当前消息Tab最后一条会话的sortOrder
     * @param limit
     * @returns
     */
    loadConversationList(fromSortOrder: number, limit: number): Promise<Conversation[] | undefined>;
    getBizUnreadCountMap(): Promise<Map<string, UnreadCountInfo>>;
    getAllConversations(queryParams?: QueryParams): Promise<Conversation[]>;
    getConversationList(cursor: number, limit: number): Promise<Conversation[]>;
    getAllConversationIdDeletedFlagMap(): Promise<Map<string, number>>;
    /**
     * 获取所有未打标签的会话
     * @param labelList
     * @param limit
     * @returns
     */
    getAllUnlabeledConversations(labelList: Set<string>[], limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 获取特定标签会话列表
     * @param labelList
     * @param isMute
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getTargetLabeledConversations(labelList: string[], isMute: boolean, maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    getTargetLabeledConversationsUnreadCount(labelList: string[], isMute: boolean): Promise<number>;
    /**
     *  获取已打标签的会话数量
     * @param labelList
     * @returns
     */
    getLabeledConversationCount(labelList: Set<string>[]): Promise<number>;
    /**
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
     * 批量更新会话SortOrder
     * @param conversations
     * @returns
     */
    batchUpdateConversationSortOrder(conversations: Conversation[]): Promise<boolean>;
    getMuteConversations(maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 分页获取有未读数的会话列表（排除标记删除、陌生人、消息盒子和不显示的会话）
     * @param maxSortOrder
     * @param limit
     * @returns
     */
    getUnreadConversations(maxSortOrder?: bigint, limit?: number, useBizUnreadCount?: boolean): Promise<Nullable<Conversation[]>>;
    getTotalUnreadCount(limit?: number): Promise<number>;
    /**
     * 条件
     * 1. 非陌生人会话
     * 2. 非陌生人盒子内熟人会话
     * 3. 非已经被标记删除的会话
     * 4. 非处于消息盒子内会话
     * 5. 非被标记不显示的会话
     */
    addWhereConditionForFriendConversationSql(sqlS: string): Promise<string>;
    /**
     * 限制单聊和群聊
     */
    private addNormalTypeLimit;
    /**
     * 限制非陌生人或陌生人盒子
     */
    addNotStrangerLimit(sql: string, schema?: string): string;
    /**
     * 限制非标记删除
     */
    addNotDeleteLimit(sql: string, schema?: string): string;
    /**
     * 限制可显示
     */
    addDisplayedLimit(sql: string, schema?: string): string;
    getConversationDisplayedCondition(schema?: string): string;
    getConversationStatusCondition(masks: number[], schema: string, expected: number): string;
    /**
     * 限制未折叠
     */
    addNotFoldLimit(sql: string, schema?: string): string;
    /**
     * 查询陌生人会话列表，排除了标记删除的会话
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
     * 获取会话id
     * @param isStranger
     * @param onlyUnread
     * @param markDelConvParam
     * @returns
     */
    getConversationIds(isStranger: boolean, onlyUnread: boolean, markDelConvParam?: number): Promise<Nullable<string[]>>;
    /**
     * 标记陌生人已读
     * @param inboxType
     * @returns
     */
    markStrangerRead(inboxType: number): Promise<Nullable<string[]>>;
    private getLatestStrangerConversation;
    private getLatestStrangerConversationWithOutGarbage;
    private getStrangerTotalUnreadCount;
    /**
     * 获取垃圾陌生人会话未读数
     */
    private getStrangerGarbageTotalUnreadCount;
    /**
     * 获取本地陌生人会话盒子内的总未读数
     * 未读数需要排除已经被标记删除的会话，陌生人盒子内可能存在熟人会话（私信体验优化实验）
     */
    private getStrangerTotalUnreadCountInner;
    getConversation(conversationId: Nullable<string>, includeDeletedConversation?: boolean): Promise<Nullable<Conversation>>;
    regulateSortOrder(conversation: Conversation): boolean;
    private generateConversationSortOrder;
    getNeedUpdateSortOrderConversation(): Promise<Nullable<Conversation[]>>;
    /**
     * 轻量的更新会话数据，将一批要更新的字段放到UpdateConversationParams一并更新，优化Android的多次更新逻辑
     * @param updateParams
     * @returns
     */
    updateConversationLightWeight(updateParams: UpdateConversationParams): Promise<Nullable<boolean>>;
    insertOrUpdateConversations(conversationList: Conversation[]): Promise<Conversation[]>;
    insertOrUpdateConversation(conversation: Conversation, updateStranger?: boolean): Promise<boolean>;
    hasConversation(conversationId: string): Promise<boolean>;
    /**
     * 这里思考：是否应该把valuesBucket返回给上层，方便感知到具体update了哪些字段，并将其更新同步到内存ConversationListMode的会话Map中
     * @param lastMessage
     * @returns
     */
    updateLastMsgToConversation(lastMessage: Message): Promise<number>;
    getConversationStatus(conversationId: string): Promise<number>;
    computeUnreadCount(conversation: Conversation): Promise<number>;
    /**
     * 退出群聊
     * @param convId 群聊会话id
     * @returns true 退出成功；false 失败
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
     * @param convId
     * @returns
     */
    dissolveConversation(convId: string): Promise<Nullable<boolean>>;
    setConversationDisplayed(convId: string, displayed: number): Promise<Nullable<boolean>>;
    /**
     * @param conversationId
     * @return 返回某个会话的readIndex
     */
    getConversationReadIndex(cid: string): Promise<bigint>;
    /**
     * 会话移入移出折叠盒子
     * @param convId
     * @param mode
     * @returns
     */
    addOrRemoveConversationFromFoldBox(convId: string, mode: number): Promise<boolean>;
    markConversationDelete(convId: string, conversation?: Nullable<Conversation>): Promise<number>;
    private buildValues;
    private buildConversations;
    setConversationHasMore(convId: string, hasMore: boolean): Promise<number>;
    updateTargetKeyByCid(convId: string, keyValue: ValuesBucket): Promise<number>;
    updateConversationOrderTimestamp(conversationId: string, orderTimestamp: number): Promise<boolean>;
    updateConversationUnreadDowngradeTime(conversationId: string, unreadDowngradeTime: number): Promise<boolean>;
    /**
     * 更新会话最后更新时间
     * @param conversationId
     * @param updateTime
     * @returns
     */
    setConversationTime(conversationId: string, updateTime: number): Promise<boolean>;
}
