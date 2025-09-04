import { BIMMember } from "../../../bim/api/model/BIMMember";
/**
 * @detail keytype
 * @brief 直播群在线信息
 */
export declare class BIMLiveMemberOnlineInfo {
    /**
     * @hidden
     */
    private conversationId;
    /**
     * @hidden
     */
    private userID;
    /**
     * @hidden
     */
    private inGroup;
    /**
     * @hidden
     */
    private joinTime;
    /**
     * @hidden
     */
    private lastPingTime;
    /**
     * @hidden
     */
    private member;
    /**
     * @hidden
     */
    constructor(conversationId: string, inGroup: boolean, userID: string, joinTime: number, lastPingTime: number, member: BIMMember);
    /**
     * @return 会话 shortID
     * @detail api
     * @brief 获取会话 shortID
     */
    getConversationId(): string;
    /**
     * @return 用户 ID
     * @detail api
     * @brief 获取用户 ID
     */
    getUserID(): string;
    /**
     * @return 入群时间 (单位:ms)
     * @detail api
     * @brief 当前是否在直播群 (单位:ms)
     */
    getJoinTime(): number;
    /**
     * @return 当前是否在直播群 (在线)
     * @detail api
     * @brief 当前是否在直播群 (在线)
     */
    isInGroup(): boolean;
    /**
     * @return 最后一次 ping 成功时间(单位:ms)
     * @detail api
     * @brief 最后一次 ping 成功时间(单位:ms)
     */
    getLastPingTime(): number;
    /**
     * 获取成员信息
     * @detail api
     * @return  成员信息
     */
    getMember(): BIMMember;
    /** @hidden */
    toString(): string;
}
