import { Message } from '../api/model/Message';
import { IMessageListObserver } from '../observer/IMessageListObserver';
import { MessageListLoadResult } from '../observer/IMessageObserver';
import { IMModel } from './IMModel';
import { MessageInitLoadAnchor } from './MessageModel';
import { IReadStatusModel, IReadStatusUpdateObserver } from './ReadStatusModel';
/**
 * 消息操作相关接口
 */
export interface IMessageModel extends IMModel {
    /**
     * 注册会话内消息列表加载结果
     * @param observer
     */
    register(observer: IMessageListObserver): void;
    /**
     * 注销回调监听
     * @param observer
     */
    unregister(observer?: IMessageListObserver): void;
    /**
     * 进入会话后初始化消息列表
     * @param limit 分页加载条数
     * @param targetOrderIndex 搜索等场景点击进入消息列表携带了消息锚点，orderIndex，用于DB查询消息
     * @param targetIndexInConversation 搜索等场景点击进入消息列表携带了消息锚点，indexInConversation，用于网络接口api请求
     * @returns 返回初始化的消息列表、一般为不超过20条消息
     */
    initMessageList(limit: number, anchor?: MessageInitLoadAnchor): Promise<Nullable<MessageListLoadResult>>;
    /**
     * 从旧到新加载更新的会话
     * @param conversationId 会话id
     * @param fromOrderIndex 会话内消息的orderIndex、用于标记从哪里开始加载，用于DB查询消息
     * @param fromIndexInConversation 会话内消息的indexInConversation、用于标记从哪里开始加载，用于网络接口api请求
     * @param limit 加载分页
     * @returns 返回加载结果
     * @see MessageListLoadResult
     */
    loadNewerMessageList(conversationId: string, fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<Nullable<MessageListLoadResult>>;
    /**
     * 从新到旧加载更老的历史消息
     * @param conversationId 会话id
     * @param fromOrderIndex 会话内消息的orderIndex、用于标记从哪里开始加载，用于DB查询消息
     * @param fromIndexInConversation 会话内消息的indexInConversation、用于标记从哪里开始加载，用于网络接口api请求
     * @param limit 加载分页
     * @returns 返回加载结果
     * @see MessageListLoadResult
     */
    loadOlderMessageList(conversationId: string, fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<Nullable<MessageListLoadResult>>;
    /**
     * 获取内存中的消息列表
     * @param conversationId 会话id
     * @returns 消息数组
     */
    getMsgArray(conversationId: string): Promise<Nullable<Message[]>>;
    /**
     * 消息的已读状态
     * @returns
     */
    getReadStatusModel(): IReadStatusModel;
    /**
     * 注册消息已读状态更新
     * @param readStatusUpdateObserver
     */
    registerReadStatusObserver(readStatusUpdateObserver: IReadStatusUpdateObserver): void;
    /**
     * 消息已读设置
     * @param msg
     */
    updateReadStatusSpotMessage(msg: Message): void;
}
