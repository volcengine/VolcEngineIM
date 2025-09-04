import { Member } from '../../../api/model/Member';
import { BIMBlockStatus } from '../enum/BIMBlockStatus';
import { BIMMemberRole } from '../enum/BIMMemberRole';
/**
 * @detail keytype
 * @brief 群成员信息。
 */
export declare class BIMMember {
    /**
     * @hidden
     */
    private member;
    /**
     * @hidden
     */
    constructor(member: Member);
    /**
     * @detail api
     * @brief 获取群成员 userID。
     * @return 群成员 userID
     */
    getUserID(): string;
    /**
     * @detail keytype
     * @brief 获取群成员排序 order (按入群时间序)。
     * @return 群成员排序 order (按入群时间序)
     */
    getSortOrder(): string;
    /**
     * @detail api
     * @brief 获取群成员角色。
     * @return 群成员角色，参看 {@link BIMMemberRole BIMMemberRole}。
     */
    getRole(): BIMMemberRole;
    /**
     * @hidden
     * @detail api
     * @brief 设置群成员角色。
     * @param role 群成员角色，参看 BIMMemberRole{@link #BIMMemberRole}。
     */
    setRole(role: BIMMemberRole): void;
    /**
     * @detail api
     * @brief 获取群成员别名。
     * @return 群成员别名
     */
    getAlias(): string;
    /**
     * @detail api
     * @brief 获取群 conversationID。
     * @return conversationID
     */
    getConversationID(): string;
    /**
     * @hidden
     */
    getSecUserID(): string;
    /**
     * @detail api
     * @brief 获取用户在会话中的额外信息。
     * @return 用户在会话中的额外信息
     */
    getExt(): Map<string, string>;
    /**
     * @hidden
     * @detail api
     * @brief 获取用户在会话中的禁言状态。
     * @return 用户在会话中的禁言状态
     */
    getSilent(): BIMBlockStatus;
    /**
     * @hidden
     * @detail api
     * @brief 是否被服务端禁言
     * @returns 是否被服务端禁言
     */
    isServerBlocked(): boolean;
    /** @hidden */
    getMarkTypes(): string[];
    /** @hidden */
    getAvatarUrl(): string;
    /**
     * @detail api
     * @brief 用户是否在线(仅支持直播群)。
     * @return 用户是否在线(仅支持直播群)
     */
    isOnline(): boolean;
    /**
     * @hidden
     */
    setSilentStatus(silent: number): void;
    /**
     * @hidden
     */
    getSilentTime(): number;
    /**
     * @hidden
     */
    setSilentTime(silentTime: number): void;
}
