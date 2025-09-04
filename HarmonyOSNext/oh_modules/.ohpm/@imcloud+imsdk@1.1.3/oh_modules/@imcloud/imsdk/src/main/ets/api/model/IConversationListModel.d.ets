import { GetSpecifiedMsgResult } from '../../handler/group/GetSpecifiedMsgListHandler';
import { IMModel } from '../../model/IMModel';
import { IConMsgReadCountObserver } from '../../model/ReadStatusModel';
import { IMResult } from '../bean/IMHandlerResult';
import { MessageReadStatusModel } from '../bean/message/MessageReadStatusModel';
import { im_proto } from '../proto';
import { IHintInfoKeyConvert } from '../transform/IHintInfoKeyConvert';
import { IHintMessageFilter } from '../transform/IHintMessageFilter';
import { IMessageFilterV2 } from '../transform/IMessageFilterV2';
import { Conversation, UpdateConversationInfo } from './Conversation';
import { Member } from './Member';
import { Message } from './Message';
/**
 * 会话列表相关操作接口
 */
export interface IConversationListModel extends IMModel {
    getImUnreadTotal(): Promise<number>;
    /**
     * 创建单聊会话
     * @param inboxType 参考 https://bytedance.larkoffice.com/wiki/GrpwwCGHbitjTek3GtgcZcZZnce
     * @param uid 单聊对方用户id
     * @returns 返回单聊会话数据结构
     */
    createSingleConversation(uid: string, inboxType?: Nullable<number>): Promise<IMResult<Conversation>>;
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
     * 创建群聊会话
     * @param inboxType 参考 https://bytedance.larkoffice.com/wiki/GrpwwCGHbitjTek3GtgcZcZZnce
     * @param uids 群聊用户的uid数组
     * @param bizExt 业务透传参数
     * @returns 成功则返回群聊会话数据结构
     */
    createGroupConversation(uids: string[], bizExt?: Nullable<Map<string, string>>, groupName?: Nullable<string>, inboxType?: Nullable<number>): Promise<IMResult<Conversation>>;
    /**
     * 删除会话
     * @param convId 会话id
     * @param isLocal 是否本地会话
     * @returns 操作成功则返回会话id
     */
    deleteConversation(convId: string, isLocal: boolean): Promise<IMResult<string>>;
    /**
     * 在会话列表loadMore/加载更多会话
     * @param fromSortOrder UI列表上最后一条会话的sortOrder
     * @param limit 想要加载的会话数
     * @returns 成功则返回会话列表
     */
    loadMoreConversationList(fromSortOrder: number, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 预处理会话列表数据、并回调业务通知会话列表构建
     * @param convList 首屏会话列表
     * @returns
     */
    initConversationList(convList?: Nullable<Conversation[]>): Promise<void>;
    /**
     * 同步内存中会话的数据
     * @param from
     * @param convList
     * @returns
     */
    syncUpdateConversationsInMemory(from: string, convList: Conversation[]): Promise<void>;
    /**
     * 查询会话是否在前台
     *
     * @param conversationId
     * @return
     */
    isConversationForeground(conversationId: string): boolean;
    /**
     * 通知创建会话
     * @param conversation 新建会话
     * @returns
     */
    onCreateConversation(conversation: Conversation): Promise<void>;
    /**
     * 通知单个会话更新
     * @param conversation 会话数据结构
     * @param updateInfo 更新原因
     * @returns
     */
    onUpdateConversation(conversation: Conversation, updateInfo: UpdateConversationInfo): Promise<void>;
    /**
     * 通知多个会话更新
     * @param updateInfo 更新原因
     * @returns
     */
    onUpdateConversationBatch(updateInfo: UpdateConversationInfo): Promise<void>;
    /**
     * 通知会话已解散
     * @param conversation
     * @returns
     */
    onDissolveConversation(conversation: Conversation): Promise<void>;
    /**
     * 通知会话已删除
     * @param conversation
     * @param fromCmdMsg
     * @returns
     */
    onDeletedConversation(conversation: Conversation, fromCmdMsg?: boolean): Promise<void>;
    /**
     * 通知会话群成员更新
     * @param updatedMembers
     * @returns
     */
    onUpdateMembers(updatedMembers: Member[]): Promise<void>;
    /**
     * 通知会话群成员移除
     * @param memberUidRemoved 被移除群聊的群成员uid, 这样里面设计原因，可能拿不到群成员数据结构，因此这里直接设计为uidList
     * @returns
     */
    onRemoveMembers(conversationId: string, memberUidRemoved: string[]): Promise<void>;
    /**
     * 通知会话群成员添加
     * @param addedMembers 新加入群聊的用户member
     * @returns
     */
    onAddMembers(addedMembers: Member[]): Promise<void>;
    /**
     * 根据会话ID查询会话数据：内存 -> 数据库
     * @param conversationId 查询的会话id
     * @param memoryFirst 是否从内存开始查找、默认为true
     * @param includeDeletedConversation 是否包含标记删除的会话
     * @return 成功则返回会话数据结构；否则返回undefined
     */
    getConversationByCid(conversationId: string, memoryFirst?: boolean, includeDeletedConversation?: boolean): Promise<Nullable<Conversation>>;
    /**
     * 慎用！
     * 提供一个拿到会话列表原始数据的方法，map结构
     * @returns 返回会话列表的原始数据
     */
    getAllConversationMapInMemory(): Map<string, Conversation>;
    /**
     * 慎用！
     * 获取内存中所有会话，数组结构
     * @param memoryFirst
     * @returns
     */
    getAllConversation(memoryFirst?: boolean, includeDeletedConversation?: boolean): Promise<Nullable<Conversation[]>>;
    /**
     * 查询内存中的会话数据
     * @param conversationId 会话id
     * @param includeDeletedConversation 是否包含已经标记删除的会话
     * @returns 成功则返回会话数据结构
     */
    getConversationOnlyInMemory(conversationId: string): Promise<Nullable<Conversation>>;
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
     * @see getMessageFilter
     * 业务注入的消息处理，专为陌生人处理
     * 混链拉到消息后，经过一个消息过滤器，筛@自己的消息或群主空降发言
     * @returns
     */
    getStrangerMessageFilter(): IMessageFilterV2[];
    /**
     * set方法
     * @see getStrangerMessageFilter
     * @param filterList
     */
    setStrangerMessageFilter(filterList: IMessageFilterV2[]): void;
    /**
     * 业务注入的消息处理
     * 混链拉到消息后，经过一个消息过滤器，筛@自己的消息或群主空降发言
     * @returns
     */
    getMessageFilter(): IMessageFilterV2[];
    /**
     * 用于会话列表中每个会话外显hintInfo处理、群聊hint提示
     * @returns
     */
    getHintMessageFilter(): Nullable<IHintMessageFilter>;
    /**
     * 用于会话列表中每个会话外显hintInfo处理、群聊hint提示
     * @returns
     */
    getHintInfoKeyConvert(): Nullable<IHintInfoKeyConvert>;
    /**
     * set 方法
     * @see getHintInfoKeyConvert
     * @param convert
     */
    setHintInfoKeyConvert(convert: IHintInfoKeyConvert): void;
    /**
     * 批量更新会话标签
     * @param from
     * @param conversations
     */
    batchUpdateConversationLabel(from: string, conversations: Conversation[]): Promise<void>;
    /**
     * 批量已读逻辑
     * @param queryMessage
     * @param from
     * @returns
     */
    batchGetConversationListReadStatus(queryMessage: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    /**
     * 对齐Android的方法名，注册会话内消息已读数的回调监听
     */
    registerMsgReadCountObservers(observer: IConMsgReadCountObserver): void;
    /**
     * 补充一个注销的方法，参考registerMsgReadCountObservers
     */
    unregisterMsgReadCountObservers(observer: IConMsgReadCountObserver): void;
    /**
     * 资源回收
     */
    onInstanceDestroy(): void;
}
