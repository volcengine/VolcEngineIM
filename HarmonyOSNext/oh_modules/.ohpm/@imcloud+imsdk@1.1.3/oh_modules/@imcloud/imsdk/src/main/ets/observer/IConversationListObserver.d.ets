import { Conversation } from '../api/model/Conversation';
import { IConversationObserver } from './IConversationObserver';
export interface IConversationListObserver extends IConversationObserver {
    /**
     * 会话列表通知业务
     * @param conversationList 返回给业务的会话列表
     * @param nextCursor @see Conversation 为sortOrder字段
     * @param hasMore 是否还有更多，含义为“会话列表length是否大于limit”
     */
    onQueryConversationPage: (conversationList: Conversation[], nextCursor: number, hasMore: boolean) => void;
}
