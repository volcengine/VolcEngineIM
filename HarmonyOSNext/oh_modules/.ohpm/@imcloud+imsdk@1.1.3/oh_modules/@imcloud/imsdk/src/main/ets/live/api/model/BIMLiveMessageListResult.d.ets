import { BIMMessage } from "../../../../../../Index";
/**
 * @detail keytype
 * @brief 直播群消息列表结果
 */
export declare class BIMLiveMessageListResult {
    /**
     * @hidden
     */
    private hasMore;
    /**
     * @hidden
     */
    private nextCursor;
    /**
     * @hidden
     */
    private messageList;
    /**
     * @hidden
     */
    constructor(hasMore: boolean, nextCursor: number, messageList: BIMMessage[]);
    /**
     * @return 是否还有更多消息
     * @detail api
     * @brief 是否还有更多消息
     */
    isHasMore(): boolean;
    /**
     * @return 分页游标
     * @detail api
     * @brief 分页游标
     */
    getNextCursor(): number;
    /**
     * @return 直播群消息
     * @detail api
     * @brief 直播群消息
     */
    getMessageList(): BIMMessage[];
}
