import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IMessageListObserver } from '../observer/IMessageListObserver';
import { MessageListLoadResult } from '../observer/IMessageObserver';
import { IMessageBrowserModel } from './IMessageBrowserModel';
import { MessageInitLoadAnchor } from './MessageModel';
export declare class MessageBrowserModel extends IMSdkBaseObject implements IMessageBrowserModel {
    private msgFilter;
    private conversationId;
    private msgListObserverSet;
    constructor(context: IMSdkContext, conversationId: string, msgFilter: number[]);
    register(observer: IMessageListObserver): void;
    unregister(observer?: IMessageListObserver): void;
    /**
     * 消息列表初始化
     * @param limit 限制条数
     * @param anchor 进入列表时携带锚点
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    initMessageList(limit: number, anchor?: MessageInitLoadAnchor | undefined): Promise<Nullable<MessageListLoadResult>>;
    /**
     *
     * @param fromMsgOrderIndex 从哪一个锚点开始加载更新的消息
     * @param fromMsgIndexInConversation 从哪一个锚点开始加载更新的消息
     * @param limit 限制条数
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    loadNewerMessageList(fromOrderIndex: bigint, fromIndexInConversation: bigint, limit: number): Promise<MessageListLoadResult | undefined>;
    /**
     * @param fromMsgOrderIndex 从哪一个锚点开始加载更老的消息
     * @param fromMsgIndexInConversation 从哪一个锚点开始加载更老的消息
     * @param limit 限制条数
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    loadOlderMessageList(fromMsgOrderIndex: bigint, fromMsgIndexInConversation: bigint, limit: number): Promise<MessageListLoadResult | undefined>;
}
