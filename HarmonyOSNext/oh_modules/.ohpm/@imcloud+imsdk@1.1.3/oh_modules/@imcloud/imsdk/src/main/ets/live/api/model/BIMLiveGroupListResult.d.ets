import { BIMConversation } from '../../../../../../Index';
/**
 * @detail keytype
 * @brief 会话列表数据分页结果
 */
export declare class BIMLiveGroupListResult {
    /**
     * @hidden
     */
    private conversationList;
    /**
     * @hidden
     */
    private nextCursor;
    /**
     * @hidden
     */
    private hasMore;
    /**
     * @hidden
     */
    constructor(conversationList: BIMConversation[], nextCursor: number, hasMore: boolean);
    /**
     * @detail api
     * @brief 获取当前页会话列表数据
     * @return 当前页会话列表数据, 参看 BIMConversation{@link #BIMConversation}
     */
    getConversationList(): BIMConversation[];
    /**
     * @detail api
     * @brief 获取会话列表。
     * @return 下一页的游标
     */
    getNextCursor(): number;
    /**
     * @detail api
     * @brief 获取是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     * @return 是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     */
    isHasMore(): boolean;
}
