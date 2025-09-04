import { Conversation, UpdateConversationInfo } from '../api/model/Conversation';
/**
 * 对齐android IStrangerListObserver接口定义
 */
export interface IStrangerListObserver {
    /**
     * 会话列表通知业务
     * @param conversationList 返回给业务的会话列表
     * @param nextCursor @see Conversation 为sortOrder字段
     * @param hasMore 是否还有更多，含义为“会话列表length是否大于limit”
     */
    onQueryConversation: (conversationList: Conversation[], hasMore: boolean) => void;
    onLoadMoreConversation: (conversationList: Conversation[], hasMore: boolean) => void;
    onDeleteConversation: (conversation: Conversation) => void;
    onUpdateConversation: (conversation: Conversation, updateInfo: UpdateConversationInfo) => void;
    onGetConversation: (conversation: Conversation) => void;
    onMarkAllRead: () => void;
    onDeleteAllConversation: () => void;
}
