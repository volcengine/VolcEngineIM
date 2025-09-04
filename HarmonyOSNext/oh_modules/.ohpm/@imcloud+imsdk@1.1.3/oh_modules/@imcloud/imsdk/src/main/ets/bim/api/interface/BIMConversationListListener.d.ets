import { BIMConversation } from '../model/BIMConversation';
/**
 * @detail callback
 * @brief 会话监听方。
 */
export interface BIMConversationListListener {
    /**
     * @detail callback
     * @brief 获取到新的会话。
     * @param conversationList 会话列表，参看 {@link BIMConversation BIMConversation}。
     */
    onNewConversation: (conversationList: BIMConversation[]) => void;
    /**
     * @detail callback
     * @brief 会话发生更新。
     * @param conversationList 会话列表，参看 {@link BIMConversation BIMConversation}。
     */
    onConversationChanged: (conversationList: BIMConversation[]) => void;
    /**
     * @detail callback
     * @brief 会话被删除。
     * @param conversationList 会话列表，参看 {@link BIMConversation BIMConversation}。
     */
    onConversationDelete: (conversationList: BIMConversation[]) => void;
    /**
     * @detail callback
     * @brief 会话未读消息数发生变化。
     * @param totalUnreadCount 会话未读消息数。
     * @notes 会话未读消息不包括设置为免打扰会话中的未读消息。
     */
    onTotalUnreadMessageCountChanged: (totalUnreadCount: number) => void;
}
