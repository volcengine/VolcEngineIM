import { BIMConversation } from './BIMConversation';
/**
 * @detail keytype
 * @brief 会话列表数据分页结果
 */
export declare class BIMConversationListResult {
    /**
     * @hidden
     */
    private _nextCursor;
    /**
     * @detail api
     * @brief 获取会话列表。
     * @return 下一页的游标
     */
    get nextCursor(): number;
    /**
     * @hidden
     */
    private _hasMore;
    /**
     * @detail api
     * @brief 获取是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     * @return 是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     */
    get hasMore(): boolean;
    /**
     * @hidden
     */
    private _conversationList;
    /**
     * @detail api
     * @brief 获取当前页会话列表数据
     * @return 当前页会话列表数据, 参看 {@link BIMConversation BIMConversation}
     */
    get conversationList(): BIMConversation[];
    /**
     * @hidden
     */
    constructor(nextCursor: number, hasMore: boolean, conversationList: BIMConversation[]);
}
