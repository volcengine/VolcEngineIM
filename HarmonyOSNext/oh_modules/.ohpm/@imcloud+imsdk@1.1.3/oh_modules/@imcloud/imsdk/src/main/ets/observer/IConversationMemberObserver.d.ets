import { Conversation } from '../api/model/Conversation';
/**
 * 这个目前看只在im-sdk内部使用了
 */
export interface IConversationMemberObserver {
    onMemberChange?: (conversation: Conversation) => void;
}
