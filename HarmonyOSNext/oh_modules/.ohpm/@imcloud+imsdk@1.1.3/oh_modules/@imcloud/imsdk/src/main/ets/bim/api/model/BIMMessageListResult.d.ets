import { BIMMessage } from './BIMMessage';
/**
 * @detail keytype
 * @brief 消息列表信息。
 */
export declare class BIMMessageListResult {
    /**
     * @hidden
     */
    private _anchorMessage;
    /**
     * @hidden
     */
    private _hasMore;
    /**
     * @hidden
     */
    private _messageList;
    /**
     * @return 下一页锚点消息
     * @detail api
     * @brief 获取下一页锚点消息
     */
    get anchorMessage(): BIMMessage | undefined;
    /**
     * @return 是否还有更多消息
     * @detail api
     * @brief 是否还有更多消息
     */
    get hasMore(): boolean;
    /**
     * @return 当前页消息列表
     * @detail api
     * @brief 当前页消息列表
     */
    get messageList(): BIMMessage[];
    /**
     * @hidden
     */
    constructor(anchorMessage: BIMMessage | undefined, hasMore: boolean, messageList: BIMMessage[]);
}
