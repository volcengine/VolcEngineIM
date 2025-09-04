import { IMSdkContext } from '../../client/IMSdkContext';
import { MessageListLoadResult } from '../../observer/IMessageObserver';
import { MessageInitLoadAnchor } from '../MessageModel';
export declare const DEFAULT_PAGE_LIMIT = 50;
export declare enum LoadTypeEnum {
    INIT = 0,
    LOADER_OLDER = 1,
    LOADER_NEWER = 2
}
/**
 * 消息列表数据加载器
 */
export declare class MessageBrowserLoader {
    /**
     * 初始化消息列表
     * @param context
     * @param conversationId 会话ID
     * @param limit 分页
     * @param anchor 携带锚点，从哪一个消息位置开始上下加载消息
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    static initMsgList(context: IMSdkContext, conversationId: string, msgFilter: number[], limit: number, anchor?: MessageInitLoadAnchor): Promise<MessageListLoadResult>;
    /**
     * 加载历史消息（包含从新到旧、和从旧到新）
     * @param context
     * @param conversationId
     * @param limit
     * @param fromOrderIndex
     * @param fromIndexInConversation
     * @param loadType
     * @param includeFromOrderIndex 返回的数据是否包括锚点
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    static loadMsgList(context: IMSdkContext, conversationId: string, msgFilter: number[], limit: number, fromOrderIndex: bigint, fromIndexInConversation: bigint, loadType: LoadTypeEnum, includeFromOrderIndex: boolean): Promise<MessageListLoadResult>;
}
