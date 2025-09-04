import { BIMConversation } from "../../../../../../Index";
/**
 * @detail callback
 * @brief 直播群成员事件回调监听方。
 */
export interface BIMLiveConversationListener {
    /**
     * @detail callback
     * @brief 直播群信息发生变化。
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     */
    onConversationChanged: (conversation: BIMConversation) => void;
}
