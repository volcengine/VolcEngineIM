import { IMessageListObserver } from '../observer/IMessageListObserver';
import { MessageListLoadResult } from '../observer/IMessageObserver';
import { IMModel } from './IMModel';
import { MessageInitLoadAnchor } from './MessageModel';
/**
 * 群聊会话设置页中的聊天相册、分享内容
 */
export interface IMessageBrowserModel extends IMModel {
    /**
     * 注册监听
     * @param observer
     */
    register(observer: IMessageListObserver): void;
    /**
     * 回收、注销监听
     */
    unregister(observer?: IMessageListObserver): void;
    /**
     * 初始化特定消息类型的消息列表
     * @param limit
     * @param anchor
     * @returns
     */
    initMessageList(limit: number, anchor?: MessageInitLoadAnchor | undefined): Promise<Nullable<MessageListLoadResult>>;
    /**
     * 从旧到新加载特定消息类型的消息列表
     * @param conversationId
     * @param fromOrderIndex
     * @param fromIndexInConversation
     * @param limit
     * @returns
     */
    loadNewerMessageList(fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<Nullable<MessageListLoadResult>>;
    /**
     * 从新到旧加载特定消息类型的消息列表
     * @param conversationId
     * @param fromOrderIndex
     * @param fromIndexInConversation
     * @param limit
     * @returns
     */
    loadOlderMessageList(fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<Nullable<MessageListLoadResult>>;
}
