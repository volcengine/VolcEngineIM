import { Conversation } from '../../../api/model/Conversation';
import { BIMConversationType } from '../enum/BIMConversationType';
import { BIMMessage } from './BIMMessage';
import { BIMMember } from './BIMMember';
import { BIMBlockStatus } from '../enum/BIMBlockStatus';
/**
 * @detail keytype
 * @brief 会话信息。
 */
export declare class BIMConversation {
    /**
     * @hidden
     */
    private _innerConversation;
    /**
     * @hidden
     */
    constructor(conversation: Conversation);
    /**
     * @return 会话排序 sortOrder
     * @detail api
     * @brief 获取会话排序 sortOrder
     */
    getSortOrder(): number;
    /**
     * @return 会话 ShortId
     * @detail api
     * @brief 获取会话 ShortId
     */
    getConversationShortID(): string;
    /**
     * @return 会话ID
     * @detail api
     * @brief 获取会话ID
     */
    getConversationId(): string;
    /**
     * @return 会话类型
     * @detail api
     * @brief 获取会话类型, 参看 {@link BIMConversationType BIMConversationType}
     */
    getConversationType(): BIMConversationType;
    /**
     * @return 草稿
     * @detail api
     * @brief 获取草稿, 可能为 null
     */
    getDraftText(): string;
    /**
     * @return 草稿更新时间戳
     * @detail api
     * @brief 获取草稿更新时间戳
     */
    getDraftTime(): number;
    /**
     * @return 会话最后一条消息
     * @detail api
     * @brief 获取会话最后一条消息
     */
    getLastMessage(): BIMMessage | undefined;
    /**
     * @return 会话未读数
     * @detail api
     * @brief 获取会话未读数
     */
    getUnreadCount(): number;
    /**
     * @return 单聊对方 uid
     * @detail api
     * @brief 获取单聊对方 uid
     */
    getOppositeUserID(curId: string): string;
    /**
     * @return 会话是否解散, 解散返回 true, 反之返回 false。
     * @detail api
     * @brief 获取会话是否解散, 解散返回 true, 反之返回 false。
     */
    isDissolved(): boolean;
    /**
     * @return 当前用户是否是会话成员, 当前用户在会话返回 true, 被踢出、主动退出等情况返回 false。
     * @detail api
     * @brief 获取当前用户是否是会话成员, 当前用户在会话返回 true, 被踢出、主动退出等情况返回 false。
     */
    isMember(): boolean;
    /**
     * @return 会话是否置顶, 置顶则返回 true, 反之返回 false。
     * @detail api
     * @brief 获取会话是否置顶, 置顶则返回 true, 反之返回 false。
     */
    isStickTop(): boolean;
    /**
     * @return 会话成员个数。
     * @detail api
     * @brief 获取会话成员个数。
     */
    getMemberCount(): number;
    /**
     * @return 会话最后更新日期。
     * @detail api
     * @brief 获取会话最后更新日期。
     */
    getUpdatedTime(): number;
    /**
     * @return 会话是否免打扰。
     * @detail api
     * @brief 获取会话是否免打扰。
     */
    isMute(): boolean;
    /**
     * @return 当前用户在会话中的信息。
     * @detail api
     * @brief 当前用户在会话中的信息，参看 {@link BIMMember BIMMember}。
     */
    getCurrentMember(): BIMMember | undefined;
    /**
     * @return 会话群主 ID
     * @detail api
     * @brief 获取会话群主 ID
     */
    getOwnerID(): string;
    /**
     * @param id 会话群主 id
     * @detail api
     * @brief 设置会话群主。
     */
    setOwner(id: string): void;
    /**
     * @return 本地额外信息
     * @detail api
     * @brief 获取本地额外信息
     */
    getLocalExt(): Map<string, string>;
    /**
     * @return 公有(成员共享)额外信息
     * @detail api
     * @brief 获取公有(成员共享)额外信息
     */
    getCoreExt(): Map<string, string>;
    /**
     * @return 私有(仅当前用户生效)额外信息
     * @detail api
     * @brief 获取私有(仅当前用户生效)额外信息
     */
    getMyExt(): Map<string, string>;
    /**
     * @return 会话名称
     * @detail api
     * @brief 获取会话名称
     */
    getName(): string | undefined;
    /**
     * @return 会话公告
     * @detail api
     * @brief 获取会话公告
     */
    getNotice(): string | undefined;
    /**
     * @return 会话简介
     * @detail api
     * @brief 获取会话简介
     */
    getDescription(): string | undefined;
    /**
     * @return 会话简介
     * @detail api
     * @brief 获取会话简介
     */
    getIntroduction(): string | undefined;
    /**
     * @return 会话图标
     * @detail api
     * @brief 获取会话图标
     */
    getPortraitURL(): string | undefined;
    /**
     * @hidden
     */
    isSilent(): boolean;
    /**
     * @hidden
     */
    getUnreadMentionMessageList(): BIMMessage[];
    /**
     * @hidden
     */
    get conversation(): Conversation;
    /**
     * @return 会话在线人数。
     * @detail api
     * @brief 获取会话在线人数。
     */
    getOnLineMemberCount(): number;
    /**
     * @return 会话禁言状态
     * @detail api
     * @brief 获取会话禁言状态
     */
    getBlockStatus(): BIMBlockStatus;
}
