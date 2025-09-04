/**
 * @hidden
 */
export declare class BIMUnReadInfo {
    /**
     * @brief 会话未读消息数
     */
    unreadCount: number;
    /**
     * @hidden 免打扰的部分（灰色的部分）
     */
    muteUnreadCount: number;
    /**
     * @hidden
     */
    constructor(unreadCount: number, muteUnreadCount: number);
}
