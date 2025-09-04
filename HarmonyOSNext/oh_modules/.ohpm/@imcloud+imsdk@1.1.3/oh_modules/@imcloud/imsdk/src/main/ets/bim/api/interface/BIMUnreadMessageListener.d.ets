import { BIMUnReadInfo } from "../model/BIMUnReadInfo";
/**
 * @hidden
 * @detail callback
 * @brief 未读数监听(内部)。
 */
export interface BIMUnreadMessageListener {
    /**
     * @detail callback
     * @brief 会话未读消息数发生变化。
     * @param unreadInfo 会话未读消息数。
     * @notes 会话未读消息不包括设置为免打扰会话中的未读消息。
     */
    onTotalUnreadMessageCountChanged: (unreadInfo: BIMUnReadInfo) => void;
}
