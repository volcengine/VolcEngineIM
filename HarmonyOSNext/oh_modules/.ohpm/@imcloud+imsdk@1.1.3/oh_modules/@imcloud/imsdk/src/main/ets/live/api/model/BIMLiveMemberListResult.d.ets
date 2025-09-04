import { BIMMember } from "../../../bim/api/model/BIMMember";
/**
 * @detail keytype
 * @brief 成员列表数据分页结果
 */
export declare class BIMLiveMemberListResult {
    /**
     * @hidden
     */
    private memberList;
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
    constructor(members: BIMMember[], hasMore: boolean, nextCursor: number);
    /**
     * @return 当前页会话成员列表数据, 参看 BIMMember{@link #BIMMember}
     * @detail api
     * @brief 获取当前页会话成员列表数据
     */
    getMemberList(): BIMMember[];
    /**
     * @return 是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     * @detail api
     * @brief 获取是否存在更多未拉取数据。存在则返回 true 反之返回 false。
     */
    isHasMore(): boolean;
    /**
     * @return 下一页的游标
     * @detail api
     * @brief 获取会话列表。
     */
    getNextCursor(): number;
}
