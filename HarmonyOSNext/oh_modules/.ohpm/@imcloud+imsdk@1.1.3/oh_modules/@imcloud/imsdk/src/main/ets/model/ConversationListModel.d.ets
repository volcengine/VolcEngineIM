import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IMSdkContext } from '../client/IMSdkContext';
import { Conversation, UpdateConversationInfo } from '../api/model/Conversation';
import { IConversationListModel } from '../api/model/IConversationListModel';
import { im_proto } from '../api/proto';
import { IHintInfoKeyConvert } from '../api/transform/IHintInfoKeyConvert';
import { IConversationUnreadCountInfoObserver } from '../observer/IConversationUnreadCountInfoObserver';
import { Member } from '../api/model/Member';
import { GetSpecifiedMsgResult } from '../handler/group/GetSpecifiedMsgListHandler';
import { IHintMessageFilter } from '../api/transform/IHintMessageFilter';
import { IMessageFilterV2 } from '../api/transform/IMessageFilterV2';
import { IMResult } from '../api/bean/IMHandlerResult';
import { Message } from '../api/model/Message';
import { IConMsgReadCountObserver } from './ReadStatusModel';
import { MessageReadStatusModel } from '../api/bean/message/MessageReadStatusModel';
/**
 * ConversationListModel:获取会话列表、会话列表管理（增删改查，网络请求/读写数据库）
 * 当前App下的所有的会话管理model，不区分inboxType
 */
export declare class ConversationListModel extends IMSdkBaseObject implements IConversationListModel {
    private conversationMap;
    private foregroundConversationIdSet;
    private hintInfoKeyConvert?;
    private messageFilterList;
    private hintMessageFilter?;
    private strangerMsgFilters;
    private isPreSynced;
    private lastSortOrder;
    constructor(context: IMSdkContext);
    onInstanceDestroy(): void;
    getImUnreadTotal(): Promise<number>;
    /**
     * 业务注入消息过滤器
     * @param filterList
     */
    setMessageFilter(filterList: IMessageFilterV2[]): void;
    /**
     * 消息过滤器
     * @returns
     */
    getMessageFilter(): IMessageFilterV2[];
    /**
     * 业务注入消息过滤器
     * @param filterList
     */
    setHintMessageFilter(filter: IHintMessageFilter): void;
    /**
     * 消息过滤器
     * @returns
     */
    getHintMessageFilter(): IHintMessageFilter;
    /**
     * 业务注入消息过滤器
     * @param filterList
     */
    setStrangerMessageFilter(filterList: IMessageFilterV2[]): void;
    /**
     * 消息过滤器
     * @returns
     */
    getStrangerMessageFilter(): IMessageFilterV2[];
    /**
     * 群聊hint提示
     * @param convert
     */
    setHintInfoKeyConvert(convert: IHintInfoKeyConvert): void;
    getHintInfoKeyConvert(): Nullable<IHintInfoKeyConvert>;
    /**
     * 会话是否在前台
     *
     * @param conversationId
     * @return
     */
    isConversationForeground(conversationId: string): boolean;
    /**
     * 设置前台会话的id
     * @param conversationId
     */
    addForegroundConversationId(conversationId: string): void;
    /**
     * 移除前台会话
     * @param conversationId
     */
    removeForegroundConversationId(conversationId: string): void;
    /**
     * 初始化会话列表
     * 三个核心处理流程实现了会话列表加载逻辑
     * 1. [convList] 没有传递数据，数据库也没有数据：此时先标记isPreSynced=true, 然后查询数据库, 如果依然没有数据 isPreSynced=false
     * 2. [convList] 有数据可以直接消费：初始化链请求返回的首屏会话数据，此时不关心数据库中是否有数据
     *    (a) 首屏会话上屏前后，网络接口返回了数据正在处理存储到本地数据库，此时会话列表loadMore数据库大概率没有查到数据，则标记没有更多
     *    (b) 因此，在每一次初始化链接口返回数据后，都需要回调业务，通知有更多会话可以上屏
     * 3. 结合2.a和2.b的逻辑，我们需要
     *    (a) 在[initConversationList->loadConversationList]调用数据库传参this.lastSortOrder
     *    (b) 在[initConversationList->notifyQueryResult]中记录this.lastSortOrder作为会话列表最后一个会话的锚点位置
     *
     * 最终的效果就是, 不论initConversationList调用多少次，对于业务而言，它能正确的知道每一次loadMore得到的数据锚点nextCursor
     * 或者说，直接调用initConversationList即可，而无需在调用处判断是要loadMore还是refresh，都能通过this.lastSortOrder串起来
     * @param convList 首屏会话列表
     */
    initConversationList(convList?: Nullable<Conversation[]>): Promise<void>;
    /**
     * 同步更新内存中的会话数据
     * @param from
     * @param convList
     */
    syncUpdateConversationsInMemory(from: string, convList: Conversation[]): Promise<void>;
    /**
     * 对齐Android的handlerInitConversionList方法
     * 初始化链数据解析、加载到会话后的im-sdk内部处理
     * @param conversationList
     * @param conversationBoxList
     * @param strangerBoxList
     * @param foldBoxList
     * @param notDisplayList
     * @param from
     * @returns
     */
    onLoadInitConversation(conversationList: Conversation[], conversationBoxList: Conversation[], strangerBoxList: Conversation[], foldBoxList: Conversation[], notDisplayList: Conversation[], from: string, pageSize: number, isFirstReq: boolean): Promise<void>;
    retryWaitingInfoConversations(conList: Conversation[]): Promise<void>;
    /**
     * @returns 返回数据库中所有的会话数据
     */
    getAllConversation(memoryFirst?: boolean, includeDeletedConversation?: boolean): Promise<Nullable<Conversation[]>>;
    /**
     * 直接操作内存中的所有会话
     * 谨慎操作
     * @returns
     */
    getAllConversationMapInMemory(): Map<string, Conversation>;
    /**
     * 根据会话ID查询会话数据：内存 -> 数据库 -> 网络
     * @param conversationId 查询的会话id
     * @param memoryFirst 优先从内存中获取，默认为true
     * @param includeDeletedConversation 是否包括已删除的会话，默认为false
     * @return 查询得到的会话
     */
    getConversationByCid(conversationId: string, memoryFirst?: boolean, includeDeletedConversation?: boolean): Promise<Nullable<Conversation>>;
    /**
     * 查询内存中的会话数据
     * @param conversationId 会话id
     * @param includeDeletedConversation 是否包含已经标记删除的会话
     * @returns 成功则返回会话数据结构
     */
    getConversationOnlyInMemory(conversationId: string, includeDeletedConversation?: boolean): Promise<Nullable<Conversation>>;
    /**
     * 在会话列表loadMore/加载更多会话
     * @param fromSortOrder UI列表上最后一条会话的sortOrder
     * @param limit 想要加载的会话数
     */
    loadMoreConversationList(fromSortOrder: number, limit: number): Promise<Nullable<Conversation[]>>;
    private notifyQueryResult;
    /**
     * 创建单聊会话
     * @param inboxType: 会话盒子类型 https://bytedance.larkoffice.com/wiki/GrpwwCGHbitjTek3GtgcZcZZnce
     * @param uid: 需要与哪一个uid创建单聊会话
     * @returns
     */
    createSingleConversation(uid: string, inboxType?: Nullable<number>): Promise<IMResult<Conversation>>;
    /**
     *
     * @param uids 创建群聊会话的uid列表
     * @param bizExt 业务透传
     * @param groupName 群名称，可选
     * @param inboxType 会话盒子类型 https://bytedance.larkoffice.com/wiki/GrpwwCGHbitjTek3GtgcZcZZnce
     * @returns
     */
    createGroupConversation(uids: string[], bizExt?: Nullable<Map<string, string>>, groupName?: Nullable<string>, inboxType?: Nullable<number>): Promise<IMResult<Conversation>>;
    /**
     * 获取群主发言等特定类型的消息
     * @param convId 会话id
     * @param type 消息类型，目前只有群主发言
     * @param offset 分页加载、偏移量
     * @param count 一页加载的数量
     * @returns
     */
    getSpecifiedMessageList(convId: string, type: im_proto.ConversationMessageListType, offset: bigint, count: bigint): Promise<IMResult<GetSpecifiedMsgResult>>;
    /**
     * 标记会话已读
     * @param conversationId 会话id
     * @returns 返回会话id代表的会话数据结构
     */
    markConversationRead(conversationId: string): Promise<Nullable<Conversation>>;
    /**
     * 标记会话不可见
     * @param conversationId
     */
    notDisplayConversation(conversationId: string): Promise<boolean>;
    /**
     * 根据会话id删除会话
     * @param convId 会话id
     * @param isLocal 是否本地会话
     * @returns
     */
    deleteConversation(convId: string, isLocal: boolean): Promise<IMResult<string>>;
    onCreateConversation(conversation: Conversation): Promise<void>;
    /**
     * 添加群成员-回调通知
     * @param addedMembers
     */
    onAddMembers(addedMembers: Member[]): Promise<void>;
    /**
     * 移除群成员-回调通知
     * @param memberUidRemoved 被移除群聊的群成员uid, 这样里面设计原因，可能拿不到群成员数据结构，因此这里直接设计为uidList
     */
    onRemoveMembers(conversationId: string, memberUidRemoved: string[]): Promise<void>;
    /**
     * 群成员更新-回调通知
     * @param memberRemoved
     */
    onUpdateMembers(updatedMembers: Member[]): Promise<void>;
    onDeletedConversation(conversation: Conversation, fromCmdMsg?: boolean): Promise<void>;
    /**
     * 解散会话/群聊
     * @param conversation
     */
    onDissolveConversation(conversation: Conversation): Promise<void>;
    onUpdateConversation(conversation: Conversation, updateInfo: UpdateConversationInfo): Promise<void>;
    onUpdateConversationBatch(updateInfo: UpdateConversationInfo): Promise<void>;
    private removeConversation;
    private insertOrUpdateConversationInMemory;
    private logAndJudge;
    addUnreadCountObserver(observer: IConversationUnreadCountInfoObserver): void;
    removeUnreadCountObserver(observer: IConversationUnreadCountInfoObserver): void;
    /**
     * 批量更新会话标签
     * @param from
     * @param conversations
     * @returns
     */
    batchUpdateConversationLabel(from: string, conversations: Conversation[]): Promise<void>;
    batchGetConversationListReadStatus(messages: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    /**
     * 用于消息Tab，注册监听感知会话内消息已读数的回调
     * @param observer
     */
    registerMsgReadCountObservers(observer: IConMsgReadCountObserver): void;
    /**
     * 注销，对应[registerMsgReadCountObservers]
     * @param observer
     */
    unregisterMsgReadCountObservers(observer: IConMsgReadCountObserver): void;
}
