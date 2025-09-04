import { Message } from '../api/model/Message';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { MessageListLoadResult } from '../observer/IMessageObserver';
import { IMessageListObserver } from '../observer/IMessageListObserver';
import { IMessageModel } from './IMessageModel';
import { IReadStatusModel, IReadStatusUpdateObserver } from './ReadStatusModel';
/**
 * 消息列表数据加载配置参数
 */
export interface MessageInitLoadAnchor {
    targetMsgOrderIndex?: Nullable<bigint>;
    targetMsgIndexInConversation?: Nullable<bigint>;
}
export declare class MessageModel extends IMSdkBaseObject implements IMessageModel {
    private continuousMsgListInMemory;
    private conversationId;
    private readStatusModel;
    private msgListObserverSet;
    private msgLoader;
    constructor(context: IMSdkContext, conversationId: string, enableMsgRead?: boolean);
    register(observer: IMessageListObserver): void;
    unregister(observer?: IMessageListObserver): void;
    getReadStatusModel(): IReadStatusModel;
    /**
     * 查询会话内消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgUuid 待查询消息的uuid
     * @returns 返回消息 @see Message
     */
    getMsgByUuid(conversationId: string, msgUuid: string): Promise<Nullable<Message>>;
    /**
     * @see getMsgByUuid
     * 批量查询会话内消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgServerId 待查询消息的uuid list
     * @returns 返回消息列表 @see Message
     */
    batchGetMsgByUuid(conversationId: string, msgUuid: string[]): Promise<Message[]>;
    /**
     * 根据消息结构中唯一的 Message.msgId 获取消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgServerId 待查询消息的server id @see Message#msgId
     * @returns 返回消息 @see Message
     */
    getMsgByServerId(conversationId: string, msgId: bigint): Promise<Message>;
    /**
     * @see getMsgByServerId
     * 根据消息结构中唯一的 Message.msgId 获取消息
     * @param conversationId 待查询消息所属会话id @see Conversation
     * @param msgServerId 待查询消息的server id @see Message#msgId
     * @returns 返回消息列表 @see Message
     */
    batchGetMsgByServerIdList(conversationId: string, msgServerIdList: bigint[]): Promise<Message[]>;
    /**
     * 这个方法暂时不使用，仅用于测试
     * @param conversationId 给定会话id
     * @returns 查询msg表中指定会话id的所有消息
     */
    getMsgArray(conversationId: string): Promise<Nullable<Message[]>>;
    /**
     * 进入会话后初始化消息列表
     * @param limit 分页加载条数, Android默认为50
     * @param anchor 携带定位锚点，如从搜索场景进入
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    initMessageList(limit: number, anchor?: MessageInitLoadAnchor): Promise<MessageListLoadResult>;
    /**
     * 从旧到新加载更新的会话
     * @param conversationId 会话id
     * @param fromOrderIndex 会话内消息的orderIndex、用于标记从哪里开始加载，用于DB查询消息
     * @param fromIndexInConversation 会话内消息的indexInConversation、用于标记从哪里开始加载，用于网络接口api请求
     * @param limit 加载分页 Android默认为50
     * @returns 返回加载结果
     * @see MessageListLoadResult
     */
    loadNewerMessageList(conversationId: string, fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<MessageListLoadResult | undefined>;
    /**
     * 从新到旧加载更老的历史消息
     * @param conversationId 会话id
     * @param fromOrderIndex 会话内消息的orderIndex、用于标记从哪里开始加载，用于DB查询消息
     * @param fromIndexInConversation 会话内消息的indexInConversation、用于标记从哪里开始加载，用于网络接口api请求
     * @param limit 加载分页 Android默认为50
     * @returns 返回加载结果
     * @see MessageListLoadResult
     */
    loadOlderMessageList(conversationId: string, fromMsgOrderIndex: bigint, fromMsgIndexInConversation: bigint, limit: number): Promise<MessageListLoadResult | undefined>;
    /**
     * 初始化消息内存
     */
    private getMsgInMemoryMap;
    registerReadStatusObserver(readStatusUpdateObserver: IReadStatusUpdateObserver): void;
    updateReadStatusSpotMessage(msg: Message): void;
}
