import { Message } from '../../api/model/Message';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { MessageListLoadResult } from '../../observer/IMessageObserver';
import { RangeList } from '../LeakMsgRepairedRangeStore';
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
export declare class MessageLoader {
    private leakRepairJob;
    /**
     * 初始化消息列表
     * @param context
     * @param conversationId 会话ID
     * @param limit 分页
     * @param anchor 携带锚点，从哪一个消息位置开始上下加载消息
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    initMsgList(imObj: IMSdkBaseObject, conversationId: string, limit: number, anchor?: MessageInitLoadAnchor): Promise<MessageListLoadResult>;
    /**
     * 加载历史消息（包含从新到旧、和从旧到新）
     * @param context
     * @param conversationId
     * @param limit 限制条数
     * @param fromMsgOrderIndex 从哪一个锚点开始加载更新的消息
     * @param fromMsgIndexInConversation 从哪一个锚点开始加载更新的消息
     * @param loadType
     * @returns 返回的消息数据列表都是从老消息到新消息，数据下标 [0,1,2,3,4,5,6]，0为最老的消息；6为最新的消息
     */
    loadMsgList(imObj: IMSdkBaseObject, conversationId: string, limit: number, fromOrderIndex: bigint, fromIndexInConversation: bigint, loadType: LoadTypeEnum): Promise<MessageListLoadResult>;
    /**
     * 给定一个列表originData, 计算出最长连续的新消息子序列，并触发异步空洞修复
     * @param imObj
     * @param convId
     * @param originData
     * @param repairedRange
     * @returns
     */
    tryRepairDBIfNeeded(imObj: IMSdkBaseObject, convId: string, originData: Nullable<Message[]>, repairedRange: RangeList): Promise<Nullable<Message[]>>;
}
