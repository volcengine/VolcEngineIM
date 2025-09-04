import { BIMConversation, BIMLiveGroupMarkTypeChangeInfo } from "../../../../../../Index";
/**
 * @hidden。
 * @detail callback
 * @brief 直播群标记类型回调监听方。
 */
export interface BIMLiveGroupMarkTypeListener {
    /**
     * @detail callback
     * @brief 直播群新增标记类型。
     * @param changeInfo 标记更新信息，参看 BIMLiveGroupMarkTypeChangeInfo{@link #BIMLiveGroupMarkTypeChangeInfo}。
     * @param conversation 会话信息，参看 BIMConversation{@link #BIMConversation}。
     */
    onMarkTypesAdd: (conversation: BIMConversation, changeInfo: BIMLiveGroupMarkTypeChangeInfo) => void;
    /**
     * @detail callback
     * @brief 直播群删除标记类型。
     * @param changeInfo 标记更新信息，参看 BIMLiveGroupMarkTypeChangeInfo{@link #BIMLiveGroupMarkTypeChangeInfo}。
     */
    onMarkTypesDeleted: (conversation: BIMConversation, changeInfo: BIMLiveGroupMarkTypeChangeInfo) => void;
}
